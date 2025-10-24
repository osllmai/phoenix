#include "systemmonitor.h"

#if defined(Q_OS_WIN)
#include <windows.h>
#elif defined(Q_OS_LINUX)
#include <QFile>
#include <QStringList>
#include <sys/sysinfo.h>
#elif defined(Q_OS_MAC)
#include <mach/mach.h>
#include <sys/sysctl.h>
#include <unistd.h>
#endif

#include <QDebug>

SystemMonitor* SystemMonitor::m_instance = nullptr;

SystemMonitor* SystemMonitor::instance(QObject* parent) {
    if (!m_instance)
        m_instance = new SystemMonitor(parent);
    return m_instance;
}

SystemMonitor::SystemMonitor(QObject* parent)
    : QObject(parent),
      m_timer(new QTimer(this)),
      m_cpuInfo(0),
      m_memoryInfo(0)
{
    connect(m_timer, &QTimer::timeout, this, &SystemMonitor::getSystemMonitor);
}

void SystemMonitor::runSystemMonitor(bool isRun) {
    if (isRun)
        m_timer->start(1000);
    else
        m_timer->stop();
}

int SystemMonitor::cpuInfo() const { return m_cpuInfo; }
int SystemMonitor::memoryInfo() const { return m_memoryInfo; }

CpuStats SystemMonitor::getCpuStats() {
    CpuStats stats = {0, 0};

#if defined(Q_OS_WIN)
    FILETIME idleTime, kernelTime, userTime;
    if (GetSystemTimes(&idleTime, &kernelTime, &userTime)) {
        stats.idleTime = ((quint64)idleTime.dwHighDateTime << 32) | idleTime.dwLowDateTime;
        stats.totalTime =
            (((quint64)kernelTime.dwHighDateTime << 32) | kernelTime.dwLowDateTime) +
            (((quint64)userTime.dwHighDateTime << 32) | userTime.dwLowDateTime);
    }

#elif defined(Q_OS_LINUX)
    QFile file("/proc/stat");
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QString line = file.readLine();
        if (line.startsWith("cpu")) {
            QStringList values = line.split(" ", Qt::SkipEmptyParts);
            if (values.size() >= 8) {
                quint64 user = values[1].toULongLong();
                quint64 nice = values[2].toULongLong();
                quint64 system = values[3].toULongLong();
                quint64 idle = values[4].toULongLong();
                quint64 iowait = values[5].toULongLong();
                quint64 irq = values[6].toULongLong();
                quint64 softirq = values[7].toULongLong();

                stats.idleTime = idle + iowait;
                stats.totalTime = user + nice + system + idle + iowait + irq + softirq;
            }
        }
    }

#elif defined(Q_OS_MAC)
    host_cpu_load_info_data_t cpuinfo;
    mach_msg_type_number_t count = HOST_CPU_LOAD_INFO_COUNT;
    if (host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (host_info_t)&cpuinfo, &count) == KERN_SUCCESS) {
        quint64 user = cpuinfo.cpu_ticks[CPU_STATE_USER];
        quint64 system = cpuinfo.cpu_ticks[CPU_STATE_SYSTEM];
        quint64 idle = cpuinfo.cpu_ticks[CPU_STATE_IDLE];
        quint64 nice = cpuinfo.cpu_ticks[CPU_STATE_NICE];

        stats.idleTime = idle;
        stats.totalTime = user + system + idle + nice;
    }
#endif

    return stats;
}

int SystemMonitor::calculateCpuUsage(const CpuStats &prev, const CpuStats &current) {
    quint64 totalDiff = current.totalTime - prev.totalTime;
    quint64 idleDiff = current.idleTime - prev.idleTime;

    if (totalDiff == 0)
        return 0;

    double usage = 100.0 * (1.0 - (double)idleDiff / totalDiff);
    return static_cast<int>(usage * 100); // تبدیل به 0-10000
}

void SystemMonitor::getMemoryInfo() {
#if defined(Q_OS_WIN)
    MEMORYSTATUSEX memoryStatus;
    memoryStatus.dwLength = sizeof(MEMORYSTATUSEX);
    if (GlobalMemoryStatusEx(&memoryStatus)) {
        double used = (double)(memoryStatus.ullTotalPhys - memoryStatus.ullAvailPhys) / memoryStatus.ullTotalPhys;
        m_memoryInfo = static_cast<int>(used * 10000);
    }

#elif defined(Q_OS_LINUX)
    struct sysinfo info;
    if (sysinfo(&info) == 0) {
        double used = 1.0 - ((double)info.freeram / info.totalram);
        m_memoryInfo = static_cast<int>(used * 10000);
    }

#elif defined(Q_OS_MAC)
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    vm_statistics_data_t vmstat;
    if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count) == KERN_SUCCESS) {
        int64_t pageSize;
        size_t size = sizeof(pageSize);
        sysctlbyname("hw.pagesize", &pageSize, &size, NULL, 0);

        quint64 freeMem = (quint64)vmstat.free_count * pageSize;
        quint64 activeMem = (quint64)vmstat.active_count * pageSize;
        quint64 inactiveMem = (quint64)vmstat.inactive_count * pageSize;
        quint64 wiredMem = (quint64)vmstat.wire_count * pageSize;
        quint64 totalMem = 0;
        sysctlbyname("hw.memsize", &totalMem, &size, NULL, 0);

        double used = (double)(activeMem + inactiveMem + wiredMem) / totalMem;
        m_memoryInfo = static_cast<int>(used * 10000);
    }
#endif
}

void SystemMonitor::getSystemMonitor() {
    getMemoryInfo();

    CpuStats previous = current;
    current = getCpuStats();

    if (current.totalTime > 0)
        m_cpuInfo = calculateCpuUsage(previous, current);

    emit cpuInfoChanged();
    emit memoryInfoChanged();
}
