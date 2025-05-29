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

#if QT_CONFIG(ssl)
#  include <QSslCertificate>
#  include <QSslKey>
#  include <QSslServer>
#endif

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

#define SCHEME "http"
#define HOST "127.0.0.1"
#define PORT 49425

class CodeDeveloperList: public QAbstractListModel
{
    Q_OBJECT
    QML_SINGLETON

    Q_PROPERTY(int port READ port NOTIFY portChanged FINAL)
    Q_PROPERTY(bool isRunning READ isRunning NOTIFY isRunningChanged FINAL)

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

    Q_INVOKABLE void start();
    Q_INVOKABLE void setCurrentLanguage(int id);

    ProgramLanguage *getCurrentProgramLanguage() const;
    void setCurrentProgramLanguage(ProgramLanguage *newCurrentProgramLanguage);

    int port() const;
    void setPort(int newPort);

    bool isRunning() const;
    void setIsRunning(bool newIsRunning);

signals:
    void countChanged();
    void portChanged();
    void isRunningChanged();
    void currentProgramLanguageChanged();

private:
    explicit CodeDeveloperList(QObject* parent);
    static CodeDeveloperList* m_instance;

    void addCrudRoutes(const QString &apiPath, std::optional<std::unique_ptr<CrudAPI>> &apiOpt);

    int m_port;
    bool m_isRunning;

    ProgramLanguage *m_currentProgramLanguage;

    QCommandLineParser m_parser;
    QCoreApplication *app;
    QHttpServer* m_httpServer = nullptr;
    std::unique_ptr<QTcpServer> m_tcpServer;
    std::optional<std::unique_ptr<CrudAPI>> m_modelsApi;
    std::optional<std::unique_ptr<CrudAPI>> m_chatApi;

    QString logger;

    QList<ProgramLanguage*> m_programLanguags;
};

#endif // CODEDEVELOPERLIST_H
