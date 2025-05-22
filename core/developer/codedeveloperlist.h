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

#include "./code/programlanguage.h"
#include "./code/codegenerator.h"
#include "./code/code_generator/curlcodegenerator.h"
#include "./code/code_generator/javascriptfetchcodegenerator.h"
#include "./code/code_generator/nodejsaxioscodegenerator.h"
#include "./code/code_generator/pythonrequestscodegenerator.h"

#include "../model/offline/offlinemodellist.h"
#include "../model/online/onlinemodellist.h"
#include "../provider/provider.h"

class CodeDeveloperList: public QAbstractListModel
{
    Q_OBJECT
    QML_SINGLETON
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
    Q_PROPERTY(int port READ port NOTIFY portChanged FINAL)
    Q_PROPERTY(bool isRuning READ isRuning NOTIFY isRuningChanged FINAL)
    Q_PROPERTY(ProgramLanguage *currentProgramLanguage READ getCurrentProgramLanguage WRITE setCurrentProgramLanguage NOTIFY currentProgramLanguageChanged FINAL)
    Q_PROPERTY(Provider *provider READ provider WRITE setProvider NOTIFY providerChanged FINAL)
    Q_PROPERTY(Model *model READ model WRITE setModel NOTIFY modelChanged FINAL)

public:
    static CodeDeveloperList* instance(QObject* parent);

    enum CodeDeveloperRoles {
        IDRole = Qt::UserRole + 1,
        NameRole
    };

    Q_INVOKABLE void setCurrentLanguage(int id);
    Q_INVOKABLE void start();

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    ProgramLanguage *getCurrentProgramLanguage() const;
    void setCurrentProgramLanguage(ProgramLanguage *newCurrentProgramLanguage);

    int port() const;
    void setPort(int newPort);

    bool isRuning() const;
    void setIsRuning(bool newIsRuning);

    Provider *provider() const;
    void setProvider(Provider *newProvider);

    Model *model() const;
    void setModel(Model *newModel);

signals:
    void countChanged();
    void currentProgramLanguageChanged();
    void portChanged();
    void isRuningChanged();
    void providerChanged();
    void modelChanged();

private:
    explicit CodeDeveloperList(QObject* parent);
    static CodeDeveloperList* m_instance;

    ProgramLanguage *m_currentProgramLanguage;

    int m_port;
    bool m_isRuning;
    QHttpServer* m_httpServer = nullptr;

    Provider *m_provider;
    Model *m_model;

    QList<ProgramLanguage*> m_programLanguags;
};

#endif // CODEDEVELOPERLIST_H
