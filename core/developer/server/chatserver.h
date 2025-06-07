#ifndef CHATSERVER_H
#define CHATSERVER_H

#include <QtCore/QObject>
#include <QtCore/QList>
#include <QtCore/QByteArray>
#include <QTimer>


#include <QtCore/QDateTime>
#include <QtCore/QJsonArray>
#include <QtCore/QJsonObject>
#include <QtCore/QJsonParseError>
#include <QtCore/QString>
#include <QList>

#include <algorithm>
#include <optional>
#include "../crudapi.h"

#include "onlinemodel.h"
#include "offlinemodel.h"
#include "onlinemodellist.h"
#include "offlinemodellist.h"
#include "offlinemodellistfilter.h"
#include "onlinemodellistfilter.h"

#include "model.h"
#include "modelsettings.h"

#include "provider.h"
#include "offlineprovider.h"
#include "onlineprovider.h"

#include <QLoggingCategory>
#include "logcategories.h"

QT_FORWARD_DECLARE_CLASS(QWebSocketServer)
QT_FORWARD_DECLARE_CLASS(QWebSocket)

class ChatServer : public QObject
{
    Q_OBJECT
    QML_SINGLETON

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
    explicit ChatServer(quint16 port, bool debug = false, QObject *parent = nullptr);
    ~ChatServer();

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

Q_SIGNALS:
    void closed();

private Q_SLOTS:
    void onNewConnection();
    void processTextMessage(QString message);
    void processBinaryMessage(QByteArray message);
    void socketDisconnected();

public slots:
    void loadModelResult(const bool result, const QString &warning);
    void tokenResponse(const QString &token);
    void finishedResponse(const QString &warning);
    void updateModelSettingsDeveloper();

signals:
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
    void prompt();
    void loadModel(const int id);
    void unloadModel();

    Provider *m_provider;
    Model *m_model;
    ModelSettings *m_modelSettings;

    bool m_isLoadModel;
    bool m_loadModelInProgress;
    bool m_responseInProgress;

    int m_modelId;
    QString m_modelIcon;
    QString m_modelText;
    QString m_modelPromptTemplate;
    QString m_modelSystemPrompt;
    bool m_modelSelect;

    QWebSocketServer *m_pWebSocketServer;
    QList<QWebSocket *> m_clients;
    QMap<QWebSocket *, int> m_socketToModelId;
    QMap<QWebSocket *, QString> m_socketToPrompt;
    QMap<QWebSocket *, QString> m_socketToGeneratedText;
    QMap<QWebSocket*, ModelSettings*> m_socketToModelSettings;

    QWebSocket *m_currentClient = nullptr;

    bool m_debug;
};


#endif // CHATSERVER_H
