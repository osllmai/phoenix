#include "phoenixcontroller.h"

PhoenixController::PhoenixController(QObject *parent)
    : QObject{parent},
    m_timer(new QTimer(this)),
    m_cpuInfo(0),
    m_memoryInfo(0)
{
    phoenix_databace::initDb();
    m_chatListModel = new ChatListModel(this);
    m_modelList = new ModelList(this);
    connect(m_timer, &QTimer::timeout, this , &PhoenixController::getSystemMonitor , Qt::QueuedConnection);
}

void PhoenixController::setIsSystemMonitor(const bool isStart){
    if(isStart == true){
        qInfo()<< "start";
        m_timer->start(1000);
    }else{
        m_timer->stop();
        qInfo()<< "stop";
    }
}

void PhoenixController::addModelToCurrentChat(const int index){
    Model* model = m_modelList->currentModelList()->getModel(index);
    m_chatListModel->currentChat()->loadModelRequested(model);
}

//*---------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*---------------------------------------------------------------------------------------* Read Property *----------------------------------------------------------------------------------------*//
ChatListModel* PhoenixController::chatListModel() const{
    return m_chatListModel;
}

ModelList* PhoenixController::modelList() const{
    return m_modelList;
}

int PhoenixController::cpuInfo() const{
    return m_cpuInfo;
}

int PhoenixController::memoryInfo() const{
    return m_memoryInfo;
}
//*-------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//

CpuStats PhoenixController::getCpuStats() {
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

void PhoenixController::getMemoryInfo(){
#if defined(Q_OS_WIN)
    MEMORYSTATUSEX memoryStatus;
    memoryStatus.dwLength = sizeof(MEMORYSTATUSEX);
    if (GlobalMemoryStatusEx(&memoryStatus)) {
        m_memoryInfo = (memoryStatus.ullAvailPhys*100)/(memoryStatus.ullTotalPhys);
        qDebug() << "Memory:" << m_memoryInfo<<"      "<<(memoryStatus.ullAvailPhys*100)/(memoryStatus.ullTotalPhys);
    }
#elif defined(Q_OS_LINUX)
    struct sysinfo info;
    if (sysinfo(&info) == 0) {
        m_memoryInfo = static_cast<double>(info.freeram) / info.totalram;
        qDebug() << "Memory:" << m_memoryInfo;
    }
#endif
}

int PhoenixController::calculateCpuUsage(const CpuStats &prev, const CpuStats &current) {
    quint64 totalDiff = current.totalTime - prev.totalTime;
    quint64 idleDiff = current.idleTime - prev.idleTime;

    if (totalDiff == 0) return 0.0; // Avoid division by zero
    return static_cast<int>(100.0 * (1.0 - (double)idleDiff / totalDiff));
}

void PhoenixController::getSystemMonitor(){
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
