// chatserver.cpp - Stable, Cleaned & ErrorMessage Enabled Version
#include "chatserver.h"
#include "codedeveloperlist.h"

QT_USE_NAMESPACE

ChatServer::ChatServer(quint16 port, QObject *parent)
    : QObject(parent),
    m_provider(nullptr),
    m_model(new Model(this)),
    m_modelSettings(new ModelSettings(1, this)),
    m_pWebSocketServer(new QWebSocketServer(QStringLiteral("Chat Server"), QWebSocketServer::NonSecureMode, this)),
    m_loadModelInProgress(false),
    m_responseInProgress(false)
{
    if (!m_pWebSocketServer->listen(QHostAddress::Any, port)) {
        qCWarning(logDeveloperView) << "WebSocket server failed to start on port" << port << ":" << m_pWebSocketServer->errorString();
        return;
    }

    connect(m_pWebSocketServer, &QWebSocketServer::newConnection, this, &ChatServer::onNewConnection);
    connect(m_pWebSocketServer, &QWebSocketServer::closed, this, &ChatServer::closed);
}

ChatServer::~ChatServer(){
    m_pWebSocketServer->close();
    qDeleteAll(m_clients);
    m_clients.clear();
    m_currentClient.clear();

    if (m_provider) {
        m_provider->deleteLater();
        m_provider = nullptr;
    }

    qCInfo(logDeveloper) << "ChatServer destroyed. Cleaned up WebSocket server and clients.";
}

void ChatServer::onNewConnection(){
    QWebSocket *pSocket = m_pWebSocketServer->nextPendingConnection();
    if (!pSocket) {
        qCWarning(logDeveloper) << "Null socket on new connection";
        return;
    }

    connect(pSocket, &QWebSocket::textMessageReceived, this, &ChatServer::processTextMessage);
    connect(pSocket, &QWebSocket::binaryMessageReceived, this, &ChatServer::processBinaryMessage);
    connect(pSocket, &QWebSocket::disconnected, this, &ChatServer::socketDisconnected);

    m_clients.insert(pSocket);
    qCInfo(logDeveloperView) << "New client connected. Total clients:" << m_clients.size();
}

void ChatServer::processTextMessage(QString message){
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    if (!pClient) {
        qCWarning(logDeveloperView) << "Message received but sender is not a valid QWebSocket.";
        return;
    }

    if (m_loadModelInProgress || m_responseInProgress) {
        sendErrorMessage(pClient, "Server is busy. Please wait.");
        return;
    }

    setLoadModelInProgress(true);
    m_currentClient = pClient;

    sendClientMessage(pClient, "Request accepted. Processing...");

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8(), &parseError);
    if (parseError.error != QJsonParseError::NoError || !doc.isObject()) {
        setLoadModelInProgress(false);
        sendErrorMessage(pClient, "Invalid JSON: " + parseError.errorString());
        return;
    }

    QJsonObject obj = doc.object();
    if (!obj.contains("message") || !obj["message"].isString()) {
        setLoadModelInProgress(false);
        sendErrorMessage(pClient, "Missing or invalid 'message' field.");
        return;
    }

    m_socketToPrompt[m_currentClient] = obj["message"].toString();
    m_socketToGeneratedText[m_currentClient] = "";

    if (obj.contains("model")) {
        if(!loadModel(obj["model"].toString())){
            setLoadModelInProgress(false);
            sendErrorMessage(pClient, "No model specified and default model not set.");
            return;
        }
        qCInfo(logDeveloperView) << "Model selected successfully: " << m_model->name();

    } else if (CodeDeveloperList::instance(nullptr)->modelId() != -1) {
        if(!loadModel(CodeDeveloperList::instance(nullptr)->modelId())){
            setLoadModelInProgress(false);
            sendErrorMessage(pClient, "No model specified and default model not set.");
            return;
        }
        qCInfo(logDeveloperView) << "Default model selected successfully. Model: " << m_model->name();

    } else {
        setLoadModelInProgress(false);
        sendErrorMessage(pClient, "No model specified and default model not set.");
        return;
    }

    if (m_socketToModelId[m_currentClient] == -1) {
        setLoadModelInProgress(false);
        sendErrorMessage(pClient, "Failed to load model.");
        return;
    }

    auto *settings = m_socketToModelSettings.value(m_currentClient, nullptr);
    if (!settings) {
        settings = new ModelSettings(this);
        m_socketToModelSettings[m_currentClient] = settings;
    }

    //set settings
    settings->setStream(obj.contains("stream") ? obj["stream"].toBool() : m_modelSettings->stream());
    settings->setPromptTemplate(obj.contains("promptTemplate") ? obj["promptTemplate"].toString() : m_modelSettings->promptTemplate());
    settings->setSystemPrompt(obj.contains("systemPrompt") ? obj["systemPrompt"].toString() : m_modelSettings->systemPrompt());
    settings->setTemperature(obj.contains("temperature") ? obj["temperature"].toDouble() : m_modelSettings->temperature());
    settings->setTopK(obj.contains("topK") ? obj["topK"].toInt() : m_modelSettings->topK());
    settings->setTopP(obj.contains("topP") ? obj["topP"].toDouble() : m_modelSettings->topP());
    settings->setMinP(obj.contains("minP") ? obj["minP"].toDouble() : m_modelSettings->minP());
    settings->setRepeatPenalty(obj.contains("repeatPenalty") ? obj["repeatPenalty"].toDouble() : m_modelSettings->repeatPenalty());
    settings->setPromptBatchSize(obj.contains("promptBatchSize") ? obj["promptBatchSize"].toInt() : m_modelSettings->promptBatchSize());
    settings->setMaxTokens(obj.contains("maxTokens") ? obj["maxTokens"].toInt() : m_modelSettings->maxTokens());
    settings->setRepeatPenaltyTokens(obj.contains("repeatPenaltyTokens") ? obj["repeatPenaltyTokens"].toInt() : m_modelSettings->repeatPenaltyTokens());
    settings->setContextLength(obj.contains("contextLength") ? obj["contextLength"].toInt() : m_modelSettings->contextLength());
    settings->setNumberOfGPULayers(obj.contains("numberOfGPULayers") ? obj["numberOfGPULayers"].toInt() : m_modelSettings->numberOfGPULayers());

    prompt();
}

void ChatServer::processBinaryMessage(QByteArray message){
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    if (pClient && pClient->state() == QAbstractSocket::ConnectedState) {
        pClient->sendBinaryMessage(message);
    }
}

void ChatServer::socketDisconnected(){
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    if (!pClient) return;

    m_clients.remove(pClient);

    if (pClient == m_currentClient) {
        finishedResponse("Client disconnected");
        m_currentClient.clear();
    }

    pClient->deleteLater();
    qCInfo(logDeveloperView) << "Client disconnected. Remaining clients:" << m_clients.size();
}

void ChatServer::prompt(){
    if (!m_currentClient || !m_socketToModelId.contains(m_currentClient)) {
        setLoadModelInProgress(false);
        sendErrorMessage(m_currentClient, "Invalid client or model ID.");
        return;
    }

    if (m_provider) {
        m_provider->deleteLater();
        m_provider = nullptr;
    }

    m_provider = (m_model->backend() == BackendType::OfflineModel)
                     ? static_cast<Provider *>(new OfflineProvider(this))
                     : static_cast<Provider *>(new OnlineProvider(this, m_model->company()->name() + "/" + m_model->modelName(), m_model->key()));

    connect(this, &ChatServer::requestLoadModel, m_provider, &Provider::loadModel, Qt::QueuedConnection);
    connect(m_provider, &Provider::requestLoadModelResult, this, &ChatServer::loadModelResult, Qt::QueuedConnection);
    connect(m_provider, &Provider::requestTokenResponse, this, &ChatServer::tokenResponse, Qt::QueuedConnection);
    connect(m_provider, &Provider::requestFinishedResponse, this, &ChatServer::finishedResponse, Qt::QueuedConnection);

    if (m_model->backend() == BackendType::OfflineModel) {
        emit requestLoadModel(m_model->modelName(), m_model->key());
    }

    setResponseInProgress(true);
    ModelSettings *settings = m_socketToModelSettings.value(m_currentClient, m_modelSettings);

    m_provider->prompt(
        m_socketToPrompt.value(m_currentClient),
        settings->stream(),
        settings->promptTemplate(),
        settings->systemPrompt(),
        settings->temperature(),
        settings->topK(),
        settings->topP(),
        settings->minP(),
        settings->repeatPenalty(),
        settings->promptBatchSize(),
        settings->maxTokens(),
        settings->repeatPenaltyTokens(),
        settings->contextLength(),
        settings->numberOfGPULayers()
        );
}

bool ChatServer::loadModel(QString modelName){
    if (modelName.startsWith("localModel/")) {
        modelName.remove(0, QString("localModel/").length());
        OfflineModel *offlineModel = OfflineModelList::instance(nullptr)->findModelByModelName(modelName);
        if (offlineModel && offlineModel->isDownloading()) {
            setModel(offlineModel);
        } else {
            return false;
        }
    } else {
        OnlineModel *onlineModel = OnlineModelList::instance(nullptr)->findModelByModelName(modelName);
        if (onlineModel && onlineModel->installModel()) {
            setModel(onlineModel);
        } else {
            return false;
        }
    }
    return true;
}

bool ChatServer::loadModel(int id){
    if (OfflineModel *offline = OfflineModelList::instance(nullptr)->findModelById(id)) {
        setModel(offline);
    } else if (OnlineModel *online = OnlineModelList::instance(nullptr)->findModelById(id)) {
        setModel(online);
    } else {
        return false;
    }
    return true;
}

void ChatServer::loadModelResult(bool result, const QString &warning){
    qCInfo(logDeveloperView) << "Model load result:" << result << "| Warning:" << warning;
}

void ChatServer::tokenResponse(const QString &token){
    if (!m_currentClient || m_currentClient->state() != QAbstractSocket::ConnectedState) {
        if (m_provider) m_provider->stop();
        setLoadModelInProgress(false);
        setResponseInProgress(false);
        return;
    }

    m_socketToGeneratedText[m_currentClient] += token;
    QJsonObject response;
    response["response"] = token;
    m_currentClient->sendTextMessage(QJsonDocument(response).toJson(QJsonDocument::Compact));

    qCInfo(logDeveloperView) << token;
}

void ChatServer::finishedResponse(const QString &warning){
    if (m_provider) {
        disconnect(this, &ChatServer::requestLoadModel, m_provider, &Provider::loadModel);
        disconnect(m_provider, &Provider::requestLoadModelResult, this, &ChatServer::loadModelResult);
        disconnect(m_provider, &Provider::requestTokenResponse, this, &ChatServer::tokenResponse);
        disconnect(m_provider, &Provider::requestFinishedResponse, this, &ChatServer::finishedResponse);
        m_provider->deleteLater();
        m_provider = nullptr;
    }

    setResponseInProgress(false);
    setLoadModelInProgress(false);

    if (!warning.isEmpty())
        qCInfo(logDeveloperView) << "Completed with warning: " << warning;
    else
        qCInfo(logDeveloperView) << "Response generation completed successfully.";
}

void ChatServer::sendErrorMessage(QWebSocket *client, const QString &message){
    if (client && client->state() == QAbstractSocket::ConnectedState) {
        QJsonObject errorResponse;
        errorResponse["error"] = message;
        client->sendTextMessage(QJsonDocument(errorResponse).toJson(QJsonDocument::Compact));
    }
    qWarning(logDeveloperView) << message;
}

void ChatServer::sendClientMessage(QWebSocket *client, const QString &message){
    if (client && client->state() == QAbstractSocket::ConnectedState) {
        QJsonObject errorResponse;
        errorResponse["message"] = message;
        client->sendTextMessage(QJsonDocument(errorResponse).toJson(QJsonDocument::Compact));
    }
    qCInfo(logDeveloperView) << message;
}

void ChatServer::updateModelSettingsDeveloper(){
    emit requestUpdateModelSettingsDeveloper(m_modelSettings->id(), m_modelSettings->stream(),
                                             m_modelSettings->promptTemplate(), m_modelSettings->systemPrompt(),
                                             m_modelSettings->temperature(), m_modelSettings->topK(),
                                             m_modelSettings->topP(), m_modelSettings->minP(),
                                             m_modelSettings->repeatPenalty(), m_modelSettings->promptBatchSize(),
                                             m_modelSettings->maxTokens(), m_modelSettings->repeatPenaltyTokens(),
                                             m_modelSettings->contextLength(), m_modelSettings->numberOfGPULayers());
}

Provider *ChatServer::provider() const { return m_provider; }
void ChatServer::setProvider(Provider *newProvider) {
    if (m_provider == newProvider)
        return;
    m_provider = newProvider;
    emit providerChanged();
}

bool ChatServer::responseInProgress() const{return m_responseInProgress;}
void ChatServer::setResponseInProgress(bool newResponseInProgress){
    if (m_responseInProgress == newResponseInProgress)
        return;
    m_responseInProgress = newResponseInProgress;
    emit responseInProgressChanged();
}

bool ChatServer::loadModelInProgress() const{return m_loadModelInProgress;}
void ChatServer::setLoadModelInProgress(bool newLoadModelInProgress){
    if (m_loadModelInProgress == newLoadModelInProgress)
        return;
    m_loadModelInProgress = newLoadModelInProgress;
    emit loadModelInProgressChanged();
}

ModelSettings *ChatServer::modelSettings() const{return m_modelSettings;}

Model *ChatServer::model() const{return m_model;}
void ChatServer::setModel(Model *newModel){
    if (m_model == newModel)
        return;
    m_model = newModel;
    emit modelChanged();
}
