#include "chatserver.h"

#include "codedeveloperlist.h"

QT_USE_NAMESPACE

//! [constructor]
ChatServer::ChatServer(quint16 port, bool debug, QObject *parent) :
    QObject(parent),
    m_provider(nullptr),
    m_model(new Model(this)),
    m_modelSettings(new ModelSettings(150,this)),
    m_pWebSocketServer(new QWebSocketServer(QStringLiteral("Echo Server"),
                                            QWebSocketServer::NonSecureMode, this)),
    m_debug(debug),
    // m_isLoadModel(false),
    m_loadModelInProgress(false),
    m_responseInProgress(false)
{
    if (!m_pWebSocketServer->listen(QHostAddress::Any, port)) {
        qCWarning(logDeveloper) << "WebSocket server failed to listen on port" << port << ":" << m_pWebSocketServer->errorString();
        return;
    }

    if (m_debug)
        qCInfo(logDeveloper) << "ChatServer listening on port" << port;
    connect(m_pWebSocketServer, &QWebSocketServer::newConnection,
            this, &ChatServer::onNewConnection);
    connect(m_pWebSocketServer, &QWebSocketServer::closed, this, &ChatServer::closed);

    qCInfo(logDeveloper) << "ChatServer constructed with debug =" << m_debug;
}
//! [constructor]

ChatServer::~ChatServer()
{
    m_pWebSocketServer->close();
    qDeleteAll(m_clients.begin(), m_clients.end());
    qCInfo(logDeveloper) << "ChatServer destroyed, WebSocket server closed and clients deleted";
}

//! [onNewConnection]
void ChatServer::onNewConnection()
{
    qCInfo(logDeveloper) << "New WebSocket connection received";

    QWebSocket *pSocket = m_pWebSocketServer->nextPendingConnection();
    if (!pSocket) {
        qCWarning(logDeveloper) << "nextPendingConnection() returned nullptr!";
        return;
    }

    connect(pSocket, &QWebSocket::textMessageReceived, this, &ChatServer::processTextMessage);
    connect(pSocket, &QWebSocket::binaryMessageReceived, this, &ChatServer::processBinaryMessage);
    connect(pSocket, &QWebSocket::disconnected, this, &ChatServer::socketDisconnected);

    m_clients << pSocket;
    qCInfo(logDeveloper) << "Client connected, total clients:" << m_clients.size();
}
//! [onNewConnection]

//! [processTextMessage]
void ChatServer::processTextMessage(QString message){

    // if (!CodeDeveloperList::instance(nullptr)->isRunningSocket())
    //     return;

    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    if (!pClient) {
        qCWarning(logDeveloper) << "processTextMessage called but sender is not a QWebSocket";
        return;
    }

    if(m_loadModelInProgress ||m_responseInProgress){
        QJsonObject response;
        response["response"] = "Server is busy processing another request. Please wait...";
        m_currentClient->sendTextMessage(QJsonDocument(response).toJson(QJsonDocument::Compact));
        qCWarning(logDeveloperView) << "Server is busy processing another request. Please wait..";
        return;
    }
    setLoadModelInProgress(true);
    m_currentClient = pClient;

    qCInfo(logDeveloper) << "Received text message from client:" << message;

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8(), &parseError);
    if (parseError.error != QJsonParseError::NoError || !doc.isObject()) {
        qCWarning(logDeveloper) << "Invalid JSON received:" << message << "Error:" << parseError.errorString();
        setLoadModelInProgress(false);
        return;
    }
    QJsonObject obj = doc.object();

    if (!obj.contains("message") || !obj["message"].isString()) {
        qCWarning(logDeveloperView) << "JSON missing required fields:" << message;
        setLoadModelInProgress(false);
        return;
    }
    m_socketToPrompt[m_currentClient] = obj["message"].toString();
    m_socketToGeneratedText[m_currentClient] = "";

    qCInfo(logDeveloperView) << "WebSocket Request. message: "<< obj["message"].toString();

    if(obj.contains("model") && obj["model"].isString()){
        QString modelName = obj["model"].toString();

        loadModel(modelName);
        if(m_socketToModelId[m_currentClient] == -1){
            qCWarning(logDeveloperView) << "models is not evailable";
            setLoadModelInProgress(false);
            return;
        }

    }else if(CodeDeveloperList::instance(nullptr)->modelId() != -1){
        // setModelId(CodeDeveloperList::instance(nullptr)->modelId());
        loadModel(CodeDeveloperList::instance(nullptr)->modelId());
        if(m_socketToModelId[m_currentClient] == -1){
            qCWarning(logDeveloperView) << "models is not evailable";
            setLoadModelInProgress(false);
            return;
        }

    }else{
        qCWarning(logDeveloperView) << "WebSocket data missing or invalid 'model' field";
        setLoadModelInProgress(false);
        return;
    }

    //create or update model-settings
    auto *settings = m_socketToModelSettings.value(m_currentClient, nullptr);
    // if (!settings) {
    //     settings = new ModelSettings(this);
    //     m_socketToModelSettings[m_currentClient] = settings;
    //     qCInfo(logDeveloper) << "Created new ModelSettings for client";
    // }

    settings = new ModelSettings(this);
    m_socketToModelSettings[m_currentClient] = settings;
    qCInfo(logDeveloper) << "Created new ModelSettings for client";

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
//! [processTextMessage]

//! [processBinaryMessage]
void ChatServer::processBinaryMessage(QByteArray message)
{
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    qCDebug(logDeveloper) << "processBinaryMessage called with message size:" << message.size();
    if (m_debug)
        qDebug() << "Binary Message received:" << message;
    if (pClient) {
        qCInfo(logDeveloper) << "Sending binary message back to client:" << pClient;
        pClient->sendBinaryMessage(message);
    } else {
        qCWarning(logDeveloper) << "No valid client to send binary message.";
    }
}
//! [processBinaryMessage]

//! [socketDisconnected]
void ChatServer::socketDisconnected()
{
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    qCInfo(logDeveloper) << "socketDisconnected called for client:" << pClient;
    if (m_debug)
        qDebug() << "socketDisconnected:" << pClient;
    if (pClient) {
        qCInfo(logDeveloper) << "Client removed from clients list and deleted:" << pClient;
        pClient->deleteLater();
    } else {
        qCWarning(logDeveloper) << "socketDisconnected called but no valid client found.";
    }
    finishedResponse("delete server");
}
//! [socketDisconnected]

void ChatServer::prompt(){
    // m_isModelChanged = false;
    qCInfo(logDeveloper) << "---------------------------------------------" << m_model->name();

    if (!m_currentClient) {
        qCWarning(logDeveloper) << "No current client set.";
        setLoadModelInProgress(false);
        return;
    }

    if (!m_socketToModelId.contains(m_currentClient)) {
        qCWarning(logDeveloper) << "No model ID assigned for this client:" << m_currentClient;
        setLoadModelInProgress(false);
        return;
    }

    // int idModel = m_socketToModelId[m_currentClient];
    QString input = m_socketToPrompt.value(m_currentClient);

    // if(!m_isLoadModel){

        if(m_model->backend() == BackendType::OfflineModel){
            m_provider = new OfflineProvider(this);
        }else if(m_model->backend() == BackendType::OnlineModel){
            m_provider = new OnlineProvider(this, m_model->company()->name() + "/" + m_model->modelName(),m_model->key());
        }

        //load and unload model
        connect(this, &ChatServer::requestLoadModel, m_provider, &Provider::loadModel, Qt::QueuedConnection);
        connect(m_provider, &Provider::requestLoadModelResult, this, &ChatServer::loadModelResult, Qt::QueuedConnection);

        //prompt
        connect(m_provider, &Provider::requestTokenResponse, this, &ChatServer::tokenResponse, Qt::QueuedConnection);

        //finished response
        connect(m_provider, &Provider::requestFinishedResponse, this, &ChatServer::finishedResponse, Qt::QueuedConnection);

        if(m_model->backend() == BackendType::OfflineModel){
            emit requestLoadModel( m_model->modelName(), m_model->key());
        }
    // }

    ModelSettings *settings = m_socketToModelSettings.value(m_currentClient, m_modelSettings);

    setResponseInProgress(true);

    m_provider->prompt(
        input,
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

void ChatServer::loadModel(QString modelName){

    if (modelName.startsWith("localModel/")){
        modelName.remove(0, QString("localModel/").length());
        OfflineModel* offlineModel = OfflineModelList::instance(nullptr)->findModelByModelName(modelName);

        if(offlineModel != nullptr && offlineModel->isDownloading()){
            m_socketToModelId[m_currentClient] = offlineModel->id();
            setModel(offlineModel);
        }else{
            m_socketToModelId[m_currentClient] = -1;
        }
    }else{
        OnlineModel* onlineModel = OnlineModelList::instance(nullptr)->findModelByModelName(modelName);
        if(onlineModel != nullptr &&onlineModel->installModel() ){
            m_socketToModelId[m_currentClient] = onlineModel->id();
            setModel(onlineModel);
        }else{
            m_socketToModelId[m_currentClient] =  -1;
        }
    }
}

void ChatServer::loadModel(const int id){

    OfflineModel* offlineModel = OfflineModelList::instance(nullptr)->findModelById(id);
    if(offlineModel != nullptr){
        setModel(offlineModel);
    }
    OnlineModel* onlineModel = OnlineModelList::instance(nullptr)->findModelById(id);
    if(onlineModel != nullptr){
        setModel(onlineModel);
    }
}

// void ChatServer::unloadModel(){
//     qCInfo(logDeveloper) << "unloadModel called";
//     setIsLoadModel(false);
//     if (m_provider) {
//         // m_provider->unLoadModel();
//         qCInfo(logDeveloper) << "Provider unloadModel called";
//     }
// }

void ChatServer::loadModelResult(const bool result, const QString &warning){
    qCInfo(logDeveloper) << "loadModelResult called with result:" << result << "warning:" << warning;
}

void ChatServer::tokenResponse(const QString &token)
{
    if (!m_currentClient) {
        qCWarning(logDeveloper) << "tokenResponse called but no current client.";
        setLoadModelInProgress(false);
        setResponseInProgress(false);
        return;
    }

    m_socketToGeneratedText[m_currentClient] += token;
    qCInfo(logDeveloperView) << token;

    QJsonObject response;
    response["response"] = token;
    m_currentClient->sendTextMessage(QJsonDocument(response).toJson(QJsonDocument::Compact));
}

void ChatServer::finishedResponse(const QString &warning) {
    qCInfo(logDeveloperView) << "start finishedResponse called";

    if(m_provider != nullptr){
        //disconnect load and unload model
        disconnect(this, &ChatServer::requestLoadModel, m_provider, &Provider::loadModel);
        disconnect(m_provider, &Provider::requestLoadModelResult, this, &ChatServer::loadModelResult);

        //disconnect prompt
        disconnect(m_provider, &Provider::requestTokenResponse, this, &ChatServer::tokenResponse);

        //disconnect finished response
        disconnect(m_provider, &Provider::requestFinishedResponse, this, &ChatServer::finishedResponse);
        delete m_provider;
    }

    setResponseInProgress(false);
    setLoadModelInProgress(false);
    qCInfo(logDeveloperView) << "end finishedResponse called";

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

// void ChatServer::closeServer() {
//     for (auto client : m_clients) {
//         client->close();
//     }
//     if (m_pWebSocketServer) {
//         m_pWebSocketServer->close();
//     }
// }


// int ChatServer::modelId() const{return m_modelId;}
// void ChatServer::setModelId(int newModelId){
//     if (m_modelId == newModelId)
//         return;
//     m_modelId = newModelId;
//     emit modelIdChanged();
// }

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
