#ifndef PHOENIXCONTROLLER_H
#define PHOENIXCONTROLLER_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QDebug>
#include <QThread>
#include <QProcess>
#include <QSysInfo>


#include "chatlistmodel.h"
#include "download.h"
#include "modellist.h"
#include "database.h"
#include "model.h"

#if defined(Q_OS_WIN)
#include <windows.h>
#elif defined(Q_OS_LINUX)
#include <QFile>
#include <QStringList>
#include <sys/sysinfo.h>
#endif


struct CpuStats {
    quint64 idleTime;
    quint64 totalTime;
};


class PhoenixController : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(ChatListModel *chatListModel READ chatListModel NOTIFY chatListModelChanged )
    Q_PROPERTY(ModelList *modelList READ modelList NOTIFY modelListChanged )

    Q_PROPERTY(int cpuInfo READ cpuInfo NOTIFY cpuInfoChanged)
    Q_PROPERTY(int memoryInfo READ memoryInfo NOTIFY memoryInfoChanged)

public:
    explicit PhoenixController(QObject *parent = nullptr);
    Q_INVOKABLE void setIsSystemMonitor(const bool isStart);
    Q_INVOKABLE void addModelToCurrentChat(const int index);

    //*---------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*---------------------------------------------------------------------------------------* Read Property *----------------------------------------------------------------------------------------*//
    ChatListModel* chatListModel() const;
    ModelList* modelList() const;
    int cpuInfo() const;
    int memoryInfo() const;
    //*-------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//

signals:
    void chatListModelChanged();
    void modelListChanged();
    void cpuInfoChanged();
    void memoryInfoChanged();

public slots:
    void getSystemMonitor();

private:
    ChatListModel* m_chatListModel;
    ModelList* m_modelList;
    QTimer *m_timer;
    int m_cpuInfo;
    int m_memoryInfo;
    CpuStats current ={0,0};

    void getMemoryInfo();
    CpuStats getCpuStats();
    int calculateCpuUsage(const CpuStats &prev, const CpuStats &current);
};

#endif // PHOENIXCONTROLLER_H
