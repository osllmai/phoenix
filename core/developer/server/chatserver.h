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

#include "QtWebSockets/qwebsocketserver.h"
#include "QtWebSockets/qwebsocket.h"
#include <QtCore/QDebug>

#include <QPointer>

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
    Q_PROPERTY(bool loadModelInProgress READ loadModelInProgress WRITE setLoadModelInProgress NOTIFY loadModelInProgressChanged FINAL)
    Q_PROPERTY(bool responseInProgress READ responseInProgress WRITE setResponseInProgress NOTIFY responseInProgressChanged FINAL)

public:
    explicit ChatServer(quint16 port, QObject *parent = nullptr);
    ~ChatServer();

    Provider *provider() const;
    void setProvider(Provider *newProvider);

    Model *model() const;
    void setModel(Model *newModel);

    ModelSettings *modelSettings() const;

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
    void modelChanged();
    void modelSettingsChanged();
    void loadModelInProgressChanged();
    void responseInProgressChanged();
    void requestUpdateModelSettingsDeveloper(const int id, const bool &stream,
                                             const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                                             const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                             const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                             const int &contextLength, const int &numberOfGPULayers);
    void requestLoadModel(const QString &model, const QString &key);
    void requestStop();


private:
    void prompt();
    bool loadModel(QString modelName);
    bool loadModel(const int id);

    void sendErrorMessage(QWebSocket *client, const QString &message);
    void sendClientMessage(QWebSocket *client, const QString &message);

    Provider *m_provider;
    Model *m_model;
    ModelSettings *m_modelSettings;

    bool m_loadModelInProgress;
    bool m_responseInProgress;

    QWebSocketServer *m_pWebSocketServer;
    QSet<QWebSocket *> m_clients;
    QMap<QWebSocket *, int> m_socketToModelId;
    QMap<QWebSocket *, QString> m_socketToPrompt;
    QMap<QWebSocket *, QString> m_socketToGeneratedText;
    QMap<QWebSocket*, ModelSettings*> m_socketToModelSettings;

    QPointer<QWebSocket> m_currentClient;
};

#endif // CHATSERVER_H
