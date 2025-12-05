#ifndef SYSTEMMONITOR_H
#define SYSTEMMONITOR_H

#include <QObject>
#include <QQmlEngine>
#include <QTimer>

struct CpuStats {
    quint64 idleTime;
    quint64 totalTime;
};

class SystemMonitor: public QObject
{
    Q_OBJECT
    QML_SINGLETON
    Q_PROPERTY(int cpuInfo READ cpuInfo NOTIFY cpuInfoChanged FINAL)
    Q_PROPERTY(int memoryInfo READ memoryInfo NOTIFY memoryInfoChanged FINAL)

public:
    static SystemMonitor* instance(QObject* parent);
    Q_INVOKABLE void runSystemMonitor(bool isRun);

    int cpuInfo() const;
    int memoryInfo() const;

signals:
    void cpuInfoChanged();
    void memoryInfoChanged();

private slots:
    void getSystemMonitor();

private:
    explicit SystemMonitor(QObject* parent = nullptr);
    static SystemMonitor* m_instance;

    int m_cpuInfo;      // x100 => 7563 = 75.63%
    int m_memoryInfo;   // x100 => 4567 = 45.67%
    QTimer* m_timer;
    CpuStats current = {0, 0};

    CpuStats getCpuStats();
    int calculateCpuUsage(const CpuStats &prev, const CpuStats &current);
    void getMemoryInfo();
};

#endif // SYSTEMMONITOR_H
