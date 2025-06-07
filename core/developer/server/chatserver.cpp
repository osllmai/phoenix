#include "chatserver.h"

#include "QtWebSockets/qwebsocketserver.h"
#include "QtWebSockets/qwebsocket.h"
#include <QtCore/QDebug>

QT_USE_NAMESPACE

//! [constructor]
ChatServer::ChatServer(quint16 port, bool debug, QObject *parent) :
    QObject(parent), m_provider(nullptr), m_model(new Model(this)), m_modelSettings(new ModelSettings(150,this)),
    m_pWebSocketServer(new QWebSocketServer(QStringLiteral("Echo Server"),
                                            QWebSocketServer::NonSecureMode, this)),
    m_debug(debug)
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
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    if (!pClient) {
        qCWarning(logDeveloper) << "processTextMessage called but sender is not a QWebSocket";
        return;
    }

    qCInfo(logDeveloper) << "Received text message from client:" << message;

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8(), &parseError);
    if (parseError.error != QJsonParseError::NoError || !doc.isObject()) {
        qCWarning(logDeveloper) << "Invalid JSON received:" << message << "Error:" << parseError.errorString();
        return;
    }
    QJsonObject obj = doc.object();
    if (!obj.contains("modelId") || !obj.contains("prompt")) {
        qCWarning(logDeveloper) << "JSON missing required fields:" << message;
        return;
    }

    m_socketToModelId[pClient] = obj["modelId"].toInt();
    m_socketToPrompt[pClient] = obj["prompt"].toString();
    m_socketToGeneratedText[pClient] = "";

    qCInfo(logDeveloper) << "Set modelId to" << m_socketToModelId[pClient] << "and prompt to" << m_socketToPrompt[pClient];

    //create or update model-settings
    auto *settings = m_socketToModelSettings.value(pClient, nullptr);
    if (!settings) {
        settings = new ModelSettings(this);
        m_socketToModelSettings[pClient] = settings;
        qCInfo(logDeveloper) << "Created new ModelSettings for client";
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

    qCInfo(logDeveloper) << "Updated ModelSettings for client:" << settings;

    if(responseInProgress()){
        m_socketToGeneratedText[pClient] = "The server is responding to other clients, please wait.";
        qCWarning(logDeveloper) << "Response in progress, client must wait.";
    }

    m_currentClient = pClient;

    qCInfo(logDeveloper) << "Calling prompt() for current client";

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
        m_clients.removeAll(pClient);
        qCInfo(logDeveloper) << "Client removed from clients list and deleted:" << pClient;
        pClient->deleteLater();
    } else {
        qCWarning(logDeveloper) << "socketDisconnected called but no valid client found.";
    }
}
//! [socketDisconnected]

void ChatServer::prompt(){
    qCInfo(logDeveloper) << "prompt() called";

    if (!m_currentClient) {
        qCWarning(logDeveloper) << "No current client set.";
        return;
    }

    if (!m_socketToModelId.contains(m_currentClient)) {
        qCWarning(logDeveloper) << "No model ID assigned for this client:" << m_currentClient;
        return;
    }

    int idModel = m_socketToModelId[m_currentClient];
    QString input = m_socketToPrompt.value(m_currentClient);

    qCInfo(logDeveloper) << "Prompt input received for client:" << m_currentClient << ", modelId:" << idModel;

    if(!m_isLoadModel){
        qCInfo(logDeveloper) << "Model not loaded. Loading model with id:" << idModel;
        loadModel(idModel);
        setIsLoadModel(true);
        if(m_provider != nullptr){
            qCInfo(logDeveloper) << "Disconnecting previous provider signals and deleting provider.";
            //disconnect load and unload model
            disconnect(this, &ChatServer::requestLoadModel, m_provider, &Provider::loadModel);
            disconnect(m_provider, &Provider::requestLoadModelResult, this, &ChatServer::loadModelResult);
            disconnect(this, &ChatServer::requestUnLoadModel, m_provider, &Provider::unLoadModel);

            //disconnect prompt
            disconnect(m_provider, &Provider::requestTokenResponse, this, &ChatServer::tokenResponse);

            //disconnect finished response
            disconnect(m_provider, &Provider::requestFinishedResponse, this, &ChatServer::finishedResponse);
            disconnect(this, &ChatServer::requestStop, m_provider, &Provider::stop);
            delete m_provider;
            m_provider = nullptr;
        }

        if(m_model->backend() == BackendType::OfflineModel){
            m_provider = new OfflineProvider(this);
            qCInfo(logDeveloper) << "OfflineProvider created.";
        }else if(m_model->backend() == BackendType::OnlineModel){
            m_provider = new OnlineProvider(this, m_model->company()->name() + "/" + m_model->modelName(),m_model->key());
            qCInfo(logDeveloper) << "OnlineProvider created for model:" << m_model->modelName();
        }
        //load and unload model
        connect(this, &ChatServer::requestLoadModel, m_provider, &Provider::loadModel, Qt::QueuedConnection);
        connect(m_provider, &Provider::requestLoadModelResult, this, &ChatServer::loadModelResult, Qt::QueuedConnection);
        connect(this, &ChatServer::requestUnLoadModel, m_provider, &Provider::unLoadModel, Qt::QueuedConnection);

        //prompt
        connect(m_provider, &Provider::requestTokenResponse, this, &ChatServer::tokenResponse, Qt::QueuedConnection);

        //finished response
        connect(m_provider, &Provider::requestFinishedResponse, this, &ChatServer::finishedResponse, Qt::QueuedConnection);
        connect(this, &ChatServer::requestStop, m_provider, &Provider::stop, Qt::QueuedConnection);

        if(m_model->backend() == BackendType::OfflineModel){
            qCInfo(logDeveloper) << "Emitting requestLoadModel signal for offline model:" << m_model->modelName();
            emit requestLoadModel( m_model->modelName(), m_model->key());
        }
    }

    if(idModel != m_model->id()){
        qCInfo(logDeveloper) << "Model ID changed from" << m_model->id() << "to" << idModel << ", reloading model.";
        setIsLoadModel(false);
        prompt();
        return;
    }

    ModelSettings *settings = m_socketToModelSettings.value(m_currentClient, m_modelSettings);
    qCInfo(logDeveloper) << "Using ModelSettings for prompt. Stream:" << settings->stream() << "PromptTemplate:" << settings->promptTemplate();

    setResponseInProgress(true);
    qCInfo(logDeveloper) << "Calling provider->prompt with input size:" << input.size();

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

void ChatServer::loadModel(const int id){
    qCInfo(logDeveloper) << "loadModel called with id:" << id;

    OfflineModel* offlineModel = OfflineModelList::instance(nullptr)->findModelById(id);
    if(offlineModel != nullptr){
        setModel(offlineModel);
        qCInfo(logDeveloper) << "Offline model found and set with id:" << id;
    }
    OnlineModel* onlineModel = OnlineModelList::instance(nullptr)->findModelById(id);
    if(onlineModel != nullptr){
        setModel(onlineModel);
        qCInfo(logDeveloper) << "Online model found and set with id:" << id;
    }
}

void ChatServer::unloadModel(){
    qCInfo(logDeveloper) << "unloadModel called";
    setIsLoadModel(false);
    if (m_provider) {
        m_provider->unLoadModel();
        qCInfo(logDeveloper) << "Provider unloadModel called";
    }
}

void ChatServer::loadModelResult(const bool result, const QString &warning){
    qCInfo(logDeveloper) << "loadModelResult called with result:" << result << "warning:" << warning;
}

void ChatServer::tokenResponse(const QString &token)
{
    if (!m_currentClient) {
        qCWarning(logDeveloper) << "tokenResponse called but no current client.";
        return;
    }

    m_socketToGeneratedText[m_currentClient] += token;
    qCInfo(logDeveloper) << "tokenResponse received token:" << token << "for client:" << m_currentClient;

    QJsonObject response;
    response["response"] = token;
    m_currentClient->sendTextMessage(QJsonDocument(response).toJson(QJsonDocument::Compact));
    qCInfo(logDeveloper) << "Sent token response to client.";
}

void ChatServer::finishedResponse(const QString &warning) {
    qCInfo(logDeveloper) << "finishedResponse called with warning:" << warning;
    setResponseInProgress(false);
}

void ChatServer::updateModelSettingsDeveloper(){
    qCInfo(logDeveloper) << "updateModelSettingsDeveloper called with settings id:" << m_modelSettings->id();
    emit requestUpdateModelSettingsDeveloper(m_modelSettings->id(), m_modelSettings->stream(),
                                             m_modelSettings->promptTemplate(), m_modelSettings->systemPrompt(),
                                             m_modelSettings->temperature(), m_modelSettings->topK(),
                                             m_modelSettings->topP(), m_modelSettings->minP(),
                                             m_modelSettings->repeatPenalty(), m_modelSettings->promptBatchSize(),
                                             m_modelSettings->maxTokens(), m_modelSettings->repeatPenaltyTokens(),
                                             m_modelSettings->contextLength(), m_modelSettings->numberOfGPULayers());
}

// void ChatServer::setModelRequest(const int id, const QString &text,  const QString &icon, const QString &promptTemplate, const QString &systemPrompt){
//     setModelId(id);
//     setModelText(text);
//     setModelIcon(icon);
//     setModelPromptTemplate(promptTemplate);
//     setModelSystemPrompt(systemPrompt);
//     if(id == -1)
//         setModelSelect(false);
//     else
//         setModelSelect(true);

//     // if(!m_isEmptyChatServer){
//     //     if(m_modelPromptTemplate != "")
//     //         m_currentChatServer->modelSettings()->setPromptTemplate(m_modelPromptTemplate);
//     //     if(m_modelSystemPrompt != "")
//     //         m_currentChatServer->modelSettings()->setSystemPrompt(m_modelSystemPrompt);
//     // }
// }

QString ChatServer::modelSystemPrompt() const{return m_modelSystemPrompt;}
void ChatServer::setModelSystemPrompt(const QString &newModelSystemPrompt){
    if (m_modelSystemPrompt == newModelSystemPrompt)
        return;
    m_modelSystemPrompt = newModelSystemPrompt;
    emit modelSystemPromptChanged();
    qCInfo(logDeveloper) << "modelSystemPrompt set to" << newModelSystemPrompt;
}

QString ChatServer::modelPromptTemplate() const{return m_modelPromptTemplate;}
void ChatServer::setModelPromptTemplate(const QString &newModelPromptTemplate){
    if (m_modelPromptTemplate == newModelPromptTemplate)
        return;
    m_modelPromptTemplate = newModelPromptTemplate;
    emit modelPromptTemplateChanged();
    qCInfo(logDeveloper) << "modelPromptTemplate set to" << newModelPromptTemplate;
}

QString ChatServer::modelText() const{return m_modelText;}
void ChatServer::setModelText(const QString &newModelText){
    if (m_modelText == newModelText)
        return;
    m_modelText = newModelText;
    emit modelTextChanged();
    qCInfo(logDeveloper) << "modelText set to" << newModelText;
}

QString ChatServer::modelIcon() const{return m_modelIcon;}
void ChatServer::setModelIcon(const QString &newModelIcon){
    if (m_modelIcon == newModelIcon)
        return;
    m_modelIcon = newModelIcon;
    emit modelIconChanged();
    qCInfo(logDeveloper) << "modelIcon set to" << newModelIcon;
}

int ChatServer::modelId() const{return m_modelId;}
void ChatServer::setModelId(int newModelId){
    if (m_modelId == newModelId)
        return;
    m_modelId = newModelId;
    emit modelIdChanged();
    qCInfo(logDeveloper) << "modelId set to" << newModelId;
}

Provider *ChatServer::provider() const { return m_provider; }
void ChatServer::setProvider(Provider *newProvider) {
    if (m_provider == newProvider)
        return;
    m_provider = newProvider;
    emit providerChanged();
    qCInfo(logDeveloper) << "Provider changed.";
}

bool ChatServer::modelSelect() const{return m_modelSelect;}
void ChatServer::setModelSelect(bool newModelSelect){
    if (m_modelSelect == newModelSelect)
        return;
    m_modelSelect = newModelSelect;
    emit modelSelectChanged();
    qCInfo(logDeveloper) << "modelSelect set to" << newModelSelect;
}

bool ChatServer::responseInProgress() const{return m_responseInProgress;}
void ChatServer::setResponseInProgress(bool newResponseInProgress){
    if (m_responseInProgress == newResponseInProgress)
        return;
    m_responseInProgress = newResponseInProgress;
    emit responseInProgressChanged();
    qCInfo(logDeveloper) << "responseInProgress set to" << newResponseInProgress;
}

bool ChatServer::loadModelInProgress() const{return m_loadModelInProgress;}
void ChatServer::setLoadModelInProgress(bool newLoadModelInProgress){
    if (m_loadModelInProgress == newLoadModelInProgress)
        return;
    m_loadModelInProgress = newLoadModelInProgress;
    emit loadModelInProgressChanged();
    qCInfo(logDeveloper) << "loadModelInProgress set to" << newLoadModelInProgress;
}

bool ChatServer::isLoadModel() const{return m_isLoadModel;}
void ChatServer::setIsLoadModel(bool newIsLoadModel){
    if (m_isLoadModel == newIsLoadModel)
        return;
    m_isLoadModel = newIsLoadModel;
    emit isLoadModelChanged();
    qCInfo(logDeveloper) << "isLoadModel set to" << newIsLoadModel;
}

ModelSettings *ChatServer::modelSettings() const{return m_modelSettings;}

Model *ChatServer::model() const{return m_model;}
void ChatServer::setModel(Model *newModel){
    if (m_model == newModel)
        return;
    m_model = newModel;
    emit modelChanged();
    qCInfo(logDeveloper) << "model pointer changed";
}
