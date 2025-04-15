#ifndef SYSTEMMONITOR_H
#define SYSTEMMONITOR_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>

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

    Q_INVOKABLE void runSystemMonitor(const bool isRun);

    const int cpuInfo() const;

    const int memoryInfo() const;

signals:
    void cpuInfoChanged();
    void memoryInfoChanged();

public slots:
    void getSystemMonitor();

private:
    explicit SystemMonitor(QObject* parent = nullptr);
    static SystemMonitor* m_instance;

    int m_cpuInfo;
    int m_memoryInfo;
    QTimer *m_timer;
    CpuStats current ={0,0};

    void getMemoryInfo();
    CpuStats getCpuStats();
    int calculateCpuUsage(const CpuStats &prev, const CpuStats &current);
};

#endif // SYSTEMMONITOR_H
