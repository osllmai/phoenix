#ifndef CODEDEVELOPERLIST_H
#define CODEDEVELOPERLIST_H

#include <QObject>
#include <QQmlEngine>
#include <QAbstractListModel>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>

#include <QHostAddress>
#include <QHttpServer>
#include <QHttpServerResponder>

#include <QFile>
#include <QJsonObject>
#include <QString>
#include <QTcpServer>

#include "programlanguage.h"
#include "codegenerator.h"
#include "curlcodegenerator.h"
#include "javascriptfetchcodegenerator.h"
#include "nodejsaxioscodegenerator.h"
#include "pythonrequestscodegenerator.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QCoreApplication>
#include <QLoggingCategory>
#include "logcategories.h"

#include <QHttpServer>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>

#include "crudapi.h"
#include "chatapi.h"
#include "modelapi.h"
#include "chatapi.h"
#include "modelapi.h"
#include "utils.h"
#include <QtCore/QCoreApplication>
#include <QtHttpServer/QHttpServer>
#include <QSharedPointer>

#include <QVariant>

#include <chrono>
#include <thread>
#include <memory>

#define SCHEME "http"
#define HOST "127.0.0.1"

#include "chatserver.h"
#include <QtCore/QCommandLineParser>
#include <QtCore/QCommandLineOption>

#include <QTimer>

class CodeDeveloperList: public QAbstractListModel
{
    Q_OBJECT
    QML_SINGLETON

    Q_PROPERTY(quint16 portSocket READ portSocket WRITE setPortSocket NOTIFY portSocketChanged FINAL)
    Q_PROPERTY(bool isRunningSocket READ isRunningSocket WRITE setIsRunningSocket NOTIFY isRunningSocketChanged FINAL)

    Q_PROPERTY(quint16 portAPI READ portAPI WRITE setPortAPI NOTIFY portAPIChanged FINAL)
    Q_PROPERTY(bool isRunningAPI READ isRunningAPI WRITE setIsRunningAPI NOTIFY isRunningAPIChanged FINAL)

    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
    Q_PROPERTY(ProgramLanguage *currentProgramLanguage READ getCurrentProgramLanguage WRITE setCurrentProgramLanguage NOTIFY currentProgramLanguageChanged FINAL)

public:
    static CodeDeveloperList* instance(QObject* parent);

    enum CodeDeveloperRoles {
        IDRole = Qt::UserRole + 1,
        NameRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void setCurrentLanguage(int id);

    ProgramLanguage *getCurrentProgramLanguage() const;
    void setCurrentProgramLanguage(ProgramLanguage *newCurrentProgramLanguage);

    quint16 portSocket() const;
    void setPortSocket(quint16 newPortSocket);

    bool isRunningSocket() const;
    void setIsRunningSocket(bool newIsRunningSocket);

    quint16 portAPI() const;
    void setPortAPI(quint16 newPortAPI);

    bool isRunningAPI() const;
    void setIsRunningAPI(bool newIsRunningAPI);

signals:
    void countChanged();
    void portSocketChanged();
    void isRunningSocketChanged();
    void currentProgramLanguageChanged();
    void portAPIChanged();
    void isRunningAPIChanged();

private:
    explicit CodeDeveloperList(QObject* parent);
    static CodeDeveloperList* m_instance;

    void addCrudRoutes(const QString &apiPath, std::optional<std::unique_ptr<CrudAPI>> &apiOpt);

    quint16 m_portSocket;
    bool m_isRunningSocket;
    quint16 m_portAPI;
    bool m_isRunningAPI;

    ProgramLanguage *m_currentProgramLanguage;

    QCommandLineParser m_parserModel;
    QCoreApplication *appAPI;
    QHttpServer* m_httpServer = nullptr;
    std::unique_ptr<QTcpServer> m_tcpServer;
    std::optional<std::unique_ptr<CrudAPI>> m_modelsApi;
    std::optional<std::unique_ptr<CrudAPI>> m_chatApi;

    QString logger;

    QList<ProgramLanguage*> m_programLanguags;

    ChatServer *m_chatServer = nullptr;
    QCommandLineParser m_parserChat;
    QCoreApplication *appSocket;
};

#endif // CODEDEVELOPERLIST_H
