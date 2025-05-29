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
#include "../model/modelsettings.h"
#include "../model/model.h"
#include "../provider/provider.h"
#include "../provider/offlineprovider.h"
#include "../provider/onlineprovider.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QCoreApplication>
#include <QLoggingCategory>
#include "../log/logcategories.h"

#include <QHttpServer>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>

#include "server/crudapi.h"
#include "server/entities/chatapi.h"
#include "server/entities/modelapi.h"
#include "server/entities/chatapi.h"
#include "server/entities/modelapi.h"
#include "server/type.h"
#include "server/utils.h"
#include <QtCore/QCoreApplication>
#include <QtHttpServer/QHttpServer>

#define SCHEME "http"
#define HOST "127.0.0.1"
#define PORT 49425

class CodeDeveloperList: public QAbstractListModel
{
    Q_OBJECT
    QML_SINGLETON
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
    Q_PROPERTY(int port READ port NOTIFY portChanged FINAL)
    Q_PROPERTY(bool isRunning READ isRunning NOTIFY isRunningChanged FINAL)
    Q_PROPERTY(ProgramLanguage *currentProgramLanguage READ getCurrentProgramLanguage WRITE setCurrentProgramLanguage NOTIFY currentProgramLanguageChanged FINAL)
    Q_PROPERTY(Model *model READ model NOTIFY modelChanged FINAL)
    Q_PROPERTY(ModelSettings *modelSettings READ modelSettings NOTIFY modelSettingsChanged FINAL)
    Q_PROPERTY(bool isLoadModel READ isLoadModel WRITE setIsLoadModel NOTIFY isLoadModelChanged FINAL)
    Q_PROPERTY(bool loadModelInProgress READ loadModelInProgress WRITE setLoadModelInProgress NOTIFY loadModelInProgressChanged FINAL)
    Q_PROPERTY(bool responseInProgress READ responseInProgress WRITE setResponseInProgress NOTIFY responseInProgressChanged FINAL)

    Q_PROPERTY(int modelId READ modelId NOTIFY modelIdChanged FINAL)
    Q_PROPERTY(QString modelIcon READ modelIcon NOTIFY modelIconChanged FINAL)
    Q_PROPERTY(QString modelText READ modelText NOTIFY modelTextChanged FINAL)
    Q_PROPERTY(QString modelPromptTemplate READ modelPromptTemplate NOTIFY modelPromptTemplateChanged FINAL)
    Q_PROPERTY(QString modelSystemPrompt READ modelSystemPrompt NOTIFY modelSystemPromptChanged FINAL)
    Q_PROPERTY(bool modelSelect READ modelSelect NOTIFY modelSelectChanged FINAL)

public:
    static CodeDeveloperList* instance(QObject* parent);

    enum CodeDeveloperRoles {
        IDRole = Qt::UserRole + 1,
        NameRole
    };

    Q_INVOKABLE void setModelRequest(const int id, const QString &text,  const QString &icon, const QString &promptTemplate, const QString &systemPrompt);
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

    bool isRunning() const;
    void setIsRunning(bool newIsRunning);

    Provider *provider() const;
    void setProvider(Provider *newProvider);


    int modelId() const;
    void setModelId(int newModelId);

    QString modelIcon() const;
    void setModelIcon(const QString &newModelIcon);

    QString modelText() const;
    void setModelText(const QString &newModelText);

    QString modelPromptTemplate() const;
    void setModelPromptTemplate(const QString &newModelPromptTemplate);

    QString modelSystemPrompt() const;
    void setModelSystemPrompt(const QString &newModelSystemPrompt);

    bool modelSelect() const;
    void setModelSelect(bool newModelSelect);

    Model *model() const;
    void setModel(Model *newModel);

    ModelSettings *modelSettings() const;

    bool isLoadModel() const;
    void setIsLoadModel(bool newIsLoadModel);

    bool loadModelInProgress() const;
    void setLoadModelInProgress(bool newLoadModelInProgress);

    bool responseInProgress() const;
    void setResponseInProgress(bool newResponseInProgress);

public slots:
    void loadModelResult(const bool result, const QString &warning);
    void tokenResponse(const QString &token);
    void finishedResponse(const QString &warning);
    void updateModelSettingsDeveloper();

signals:
    void countChanged();
    void currentProgramLanguageChanged();
    void portChanged();
    void isRunningChanged();
    void providerChanged();
    void modelIdChanged();
    void modelIconChanged();
    void modelTextChanged();
    void modelPromptTemplateChanged();
    void modelSystemPromptChanged();
    void modelSelectChanged();
    void modelChanged();
    void modelSettingsChanged();
    void isLoadModelChanged();
    void loadModelInProgressChanged();
    void responseInProgressChanged();
    void requestUpdateModelSettingsDeveloper(const int id, const bool &stream,
                                                const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                                                const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                                const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                                const int &contextLength, const int &numberOfGPULayers);
    void requestLoadModel(const QString &model, const QString &key);
    void requestUnLoadModel();
    void requestStop();

private:
    explicit CodeDeveloperList(QObject* parent);
    static CodeDeveloperList* m_instance;

    void prompt(const QString &input, const int idModel);
    void loadModel(const int id);
    void unloadModel();

    void addCrudRoutes(const QString &apiPath, std::optional<std::unique_ptr<CrudAPI>> &apiOpt);

    ProgramLanguage *m_currentProgramLanguage;

    int m_port;
    bool m_isRunning;

    Provider *m_provider;
    Model *m_model;
    ModelSettings *m_modelSettings;

    QCommandLineParser m_parser;
    QCoreApplication *app;
    QHttpServer* m_httpServer = nullptr;
    std::unique_ptr<QTcpServer> m_tcpServer;
    std::optional<std::unique_ptr<CrudAPI>> m_colorsApi;
    std::optional<std::unique_ptr<CrudAPI>> m_usersApi;

    bool m_isLoadModel;
    bool m_loadModelInProgress;
    bool m_responseInProgress;

    QString logger;

    QList<ProgramLanguage*> m_programLanguags;

    int m_modelId;
    QString m_modelIcon;
    QString m_modelText;
    QString m_modelPromptTemplate;
    QString m_modelSystemPrompt;
    bool m_modelSelect;
};

#endif // CODEDEVELOPERLIST_H
