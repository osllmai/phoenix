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
    if (m_pWebSocketServer->listen(QHostAddress::Any, port)) {
        if (m_debug)
            qDebug() << "ChatServer listening on port" << port;
        connect(m_pWebSocketServer, &QWebSocketServer::newConnection,
                this, &ChatServer::onNewConnection);
        connect(m_pWebSocketServer, &QWebSocketServer::closed, this, &ChatServer::closed);
    }
}
//! [constructor]

ChatServer::~ChatServer()
{
    m_pWebSocketServer->close();
    qDeleteAll(m_clients.begin(), m_clients.end());
}

//! [onNewConnection]
void ChatServer::onNewConnection()
{
    QWebSocket *pSocket = m_pWebSocketServer->nextPendingConnection();

    connect(pSocket, &QWebSocket::textMessageReceived, this, &ChatServer::processTextMessage);
    connect(pSocket, &QWebSocket::binaryMessageReceived, this, &ChatServer::processBinaryMessage);
    connect(pSocket, &QWebSocket::disconnected, this, &ChatServer::socketDisconnected);

    m_clients << pSocket;
}
//! [onNewConnection]

//! [processTextMessage]
void ChatServer::processTextMessage(QString message){
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    if (!pClient) return;

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8(), &parseError);
    if (parseError.error != QJsonParseError::NoError || !doc.isObject()) {
        qWarning() << "Invalid JSON received:" << message;
        return;
    }
    QJsonObject obj = doc.object();
    if (!obj.contains("modelId") || !obj.contains("prompt")) {
        qWarning() << "JSON missing required fields.";
        return;
    }

    m_socketToModelId[pClient] = obj["modelId"].toInt();
    m_socketToPrompt[pClient] = obj["prompt"].toString();
    m_socketToGeneratedText[pClient] = "";

    //create or update model-settings
    auto *settings = m_socketToModelSettings.value(pClient, nullptr);
    if (!settings) {
        settings = new ModelSettings(this);
        m_socketToModelSettings[pClient] = settings;
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


    if(responseInProgress()){
        m_socketToGeneratedText[pClient] = "The server is responding to other clients, please wait.";
    }

    m_currentClient = pClient;

    prompt();
}
//! [processTextMessage]

//! [processBinaryMessage]
void ChatServer::processBinaryMessage(QByteArray message)
{
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    if (m_debug)
        qDebug() << "Binary Message received:" << message;
    if (pClient) {
        pClient->sendBinaryMessage(message);
    }
}
//! [processBinaryMessage]

//! [socketDisconnected]
void ChatServer::socketDisconnected()
{
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    if (m_debug)
        qDebug() << "socketDisconnected:" << pClient;
    if (pClient) {
        m_clients.removeAll(pClient);
        pClient->deleteLater();
    }
}
//! [socketDisconnected]


void ChatServer::prompt(){

    if (!m_currentClient) {
        qWarning() << "No current client set.";
        return;
    }

    if (!m_socketToModelId.contains(m_currentClient)) {
        qWarning() << "No model ID assigned for this client.";
        return;
    }

    int idModel = m_socketToModelId[m_currentClient];
    QString input = m_socketToPrompt.value(m_currentClient);


    if(!m_isLoadModel){
        loadModel(idModel);
        setIsLoadModel(true);
        if(m_provider != nullptr){
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
        }

        if(m_model->backend() == BackendType::OfflineModel){
            m_provider = new OfflineProvider(this);
        }else if(m_model->backend() == BackendType::OnlineModel){
            m_provider = new OnlineProvider(this, m_model->company()->name() + "/" + m_model->modelName(),m_model->key());
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
            emit requestLoadModel( m_model->modelName(), m_model->key());
        }

    }

    if(idModel != m_model->id()){
        setIsLoadModel(false);
        prompt();
        return;
    }

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

void ChatServer::unloadModel(){
    setIsLoadModel(false);
    m_provider->unLoadModel();
}

void ChatServer::loadModelResult(const bool result, const QString &warning){

}

void ChatServer::tokenResponse(const QString &token)
{
    if (!m_currentClient) return;

    m_socketToGeneratedText[m_currentClient] += token;

    QJsonObject response;
    response["text"] = token;
    m_currentClient->sendTextMessage(QJsonDocument(response).toJson(QJsonDocument::Compact));
}


void ChatServer::finishedResponse(const QString &warning) {
    setResponseInProgress(false);

    if (!m_currentClient) return;

    m_socketToPrompt.remove(m_currentClient);
    m_socketToGeneratedText.remove(m_currentClient);
    m_socketToModelId.remove(m_currentClient);

    if (m_socketToModelSettings.contains(m_currentClient)) {
        delete m_socketToModelSettings[m_currentClient];
        m_socketToModelSettings.remove(m_currentClient);
    }

    m_currentClient = nullptr;
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
}

QString ChatServer::modelPromptTemplate() const{return m_modelPromptTemplate;}
void ChatServer::setModelPromptTemplate(const QString &newModelPromptTemplate){
    if (m_modelPromptTemplate == newModelPromptTemplate)
        return;
    m_modelPromptTemplate = newModelPromptTemplate;
    emit modelPromptTemplateChanged();
}

QString ChatServer::modelText() const{return m_modelText;}
void ChatServer::setModelText(const QString &newModelText){
    if (m_modelText == newModelText)
        return;
    m_modelText = newModelText;
    emit modelTextChanged();
}

QString ChatServer::modelIcon() const{return m_modelIcon;}
void ChatServer::setModelIcon(const QString &newModelIcon){
    if (m_modelIcon == newModelIcon)
        return;
    m_modelIcon = newModelIcon;
    emit modelIconChanged();
}

int ChatServer::modelId() const{return m_modelId;}
void ChatServer::setModelId(int newModelId){
    if (m_modelId == newModelId)
        return;
    m_modelId = newModelId;
    emit modelIdChanged();
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

bool ChatServer::isLoadModel() const{return m_isLoadModel;}
void ChatServer::setIsLoadModel(bool newIsLoadModel){
    if (m_isLoadModel == newIsLoadModel)
        return;
    m_isLoadModel = newIsLoadModel;
    emit isLoadModelChanged();
}

ModelSettings *ChatServer::modelSettings() const{return m_modelSettings;}

Model *ChatServer::model() const{return m_model;}
void ChatServer::setModel(Model *newModel){
    if (m_model == newModel)
        return;
    m_model = newModel;
    emit modelChanged();
}
