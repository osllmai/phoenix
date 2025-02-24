#include "systemmonitor.h"

#if defined(Q_OS_WIN)
#include <windows.h>
#elif defined(Q_OS_LINUX)
#include <QFile>
#include <QStringList>
#include <sys/sysinfo.h>
#endif

#include <QDebug>
#include <QThread>
#include <QProcess>
#include <QSysInfo>

SystemMonitor* SystemMonitor::m_instance = nullptr;

SystemMonitor* SystemMonitor::instance(QObject* parent){
    if (!m_instance) {
        m_instance = new SystemMonitor(parent);
    }
    return m_instance;
}

SystemMonitor::SystemMonitor(QObject* parent)
    : QObject(parent),
    m_timer(new QTimer(this)),
    m_cpuInfo(0),
    m_memoryInfo(0)
{
    connect(m_timer, &QTimer::timeout, this , &SystemMonitor::getSystemMonitor , Qt::QueuedConnection);
}

void SystemMonitor::runSystemMonitor(const bool isRun){
    if(isRun == true){
        qInfo()<< "start";
        m_timer->start(1000);
    }else{
        m_timer->stop();
        qInfo()<< "stop";
    }
}

const int SystemMonitor::cpuInfo() const{return m_cpuInfo;}

const int SystemMonitor::memoryInfo() const{return m_memoryInfo;}

CpuStats SystemMonitor::getCpuStats() {
    CpuStats stats = {0, 0};

#if defined(Q_OS_WIN)
    FILETIME idleTime, kernelTime, userTime;
    if (GetSystemTimes(&idleTime, &kernelTime, &userTime)) {
        stats.idleTime = ((ULONGLONG)idleTime.dwHighDateTime << 32) | idleTime.dwLowDateTime;
        stats.totalTime =
            (((ULONGLONG)kernelTime.dwHighDateTime << 32) | kernelTime.dwLowDateTime) +
            (((ULONGLONG)userTime.dwHighDateTime << 32) | userTime.dwLowDateTime);
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

                stats.idleTime = idle;
                stats.totalTime = user + nice + system + idle + iowait + irq + softirq;
            }
        }
        file.close();
    }
#endif
    return stats;
}

void SystemMonitor::getMemoryInfo(){
#if defined(Q_OS_WIN)
    MEMORYSTATUSEX memoryStatus;
    memoryStatus.dwLength = sizeof(MEMORYSTATUSEX);
    if (GlobalMemoryStatusEx(&memoryStatus)) {
        m_memoryInfo = (memoryStatus.ullAvailPhys*10000)/(memoryStatus.ullTotalPhys);
        qDebug() << "Memory:" << m_memoryInfo<<"      "<<(memoryStatus.ullAvailPhys*100)/(memoryStatus.ullTotalPhys);
    }
#elif defined(Q_OS_LINUX)
    struct sysinfo info;
    if (sysinfo(&info) == 0) {
        m_memoryInfo = static_cast<double>info.freeram/info.totalram;
        qDebug() << "Memory:" << m_memoryInfo;
    }
#endif
}

int SystemMonitor::calculateCpuUsage(const CpuStats &prev, const CpuStats &current) {
    quint64 totalDiff = current.totalTime - prev.totalTime;
    quint64 idleDiff = current.idleTime - prev.idleTime;

    if (totalDiff == 0) return 0.0; // Avoid division by zero
    return static_cast<int>(10000.0 * (1.0 - (double)idleDiff / totalDiff));
}

void SystemMonitor::getSystemMonitor(){
    getMemoryInfo();
    CpuStats previous = current;
    current = getCpuStats();
    if (current.totalTime > 0) {
        // double cpuUsage = calculateCpuUsage(previous, current);
        m_cpuInfo = calculateCpuUsage(previous, current);;
        qDebug() << "CPU Usage:" << m_cpuInfo << "%";
    } else {
        qWarning() << "Failed to retrieve CPU stats.";
    }
    emit cpuInfoChanged();
    emit memoryInfoChanged();
    qInfo()<<"HI";
}
