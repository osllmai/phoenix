#include "chatapi.h"

ChatAPI::ChatAPI(const QString &scheme, const QString &hostName, int port)
    : CrudAPI(scheme, hostName, port),
    m_modelSelect(false),
    m_isLoadModel(false),
    m_loadModelInProgress(false),
    m_responseInProgress(false),
    m_model(new Model(this)),
    m_modelSettings(new ModelSettings(1, true, "### Human:\n%1\n\n### Assistant:\n",
                                      "### System:\nYou are an AI assistant who gives a quality response to whatever humans ask of you.\n\n",
                                      0.7, 40, 0.4,0.0,1.18,128,4096,64,2048,80, this)),
    m_provider(nullptr)
{}

QHttpServerResponse ChatAPI::getFullList() const {
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

QHttpServerResponse ChatAPI::getItem(qint64 itemId) const{
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

void ChatAPI::postItem(const QHttpServerRequest &request, QSharedPointer<QHttpServerResponder> responder)
{
    responder->writeBeginChunked("text/event-stream");

    const std::optional<QJsonObject> json = byteArrayToJsonObject(request.body());
    if (!json) {
        QJsonObject errorObj;
        errorObj["error"] = "Invalid JSON";
        QJsonDocument doc(errorObj);
        responder->writeChunk(doc.toJson(QJsonDocument::Compact));
        responder->writeEndChunked("{}");
        return;
    }

    if (!json->contains("prompt") || !(*json)["prompt"].isString()) {
        QJsonObject errorObj;
        errorObj["error"] = "Missing or invalid 'prompt' field";
        QJsonDocument doc(errorObj);
        responder->writeChunk(doc.toJson(QJsonDocument::Compact));
        responder->writeEndChunked("{}");
        return;
    }

    if (!json->contains("modelId") || !(*json)["modelId"].isDouble()) {
        QJsonObject errorObj;
        errorObj["error"] = "Missing or invalid 'modelId' field";
        QJsonDocument doc(errorObj);
        responder->writeChunk(doc.toJson(QJsonDocument::Compact));
        responder->writeEndChunked("{}");
        return;
    }

    m_responder = responder;

    prompt(json);
}

QHttpServerResponse ChatAPI::updateItem(qint64 itemId, const QHttpServerRequest &request){
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

QHttpServerResponse ChatAPI::updateItemFields(qint64 itemId, const QHttpServerRequest &request){
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

QHttpServerResponse ChatAPI::deleteItem(qint64 itemId){
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

void ChatAPI::prompt(const std::optional<QJsonObject> json){

    int idModel = (*json)["modelId"].toInt();
    QString input = (*json)["prompt"].toString();
    setModelId(idModel);

    if(!m_isLoadModel){
        loadModel(idModel);
        setIsLoadModel(true);
        if(m_provider != nullptr){
            //disconnect load and unload model
            disconnect(this, &ChatAPI::requestLoadModel, m_provider, &Provider::loadModel);
            disconnect(m_provider, &Provider::requestLoadModelResult, this, &ChatAPI::loadModelResult);
            disconnect(this, &ChatAPI::requestUnLoadModel, m_provider, &Provider::unLoadModel);

            //disconnect prompt
            disconnect(m_provider, &Provider::requestTokenResponse, this, &ChatAPI::tokenResponse);

            //disconnect finished response
            disconnect(m_provider, &Provider::requestFinishedResponse, this, &ChatAPI::finishedResponse);
            disconnect(this, &ChatAPI::requestStop, m_provider, &Provider::stop);
            delete m_provider;
        }

        if(m_model->backend() == BackendType::OfflineModel){
            m_provider = new OfflineProvider(this);
        }else if(m_model->backend() == BackendType::OnlineModel){
            m_provider = new OnlineProvider(this, m_model->company()->name() + "/" + m_model->modelName(),m_model->key());
        }
        //load and unload model
        connect(this, &ChatAPI::requestLoadModel, m_provider, &Provider::loadModel, Qt::QueuedConnection);
        connect(m_provider, &Provider::requestLoadModelResult, this, &ChatAPI::loadModelResult, Qt::QueuedConnection);
        connect(this, &ChatAPI::requestUnLoadModel, m_provider, &Provider::unLoadModel, Qt::QueuedConnection);

        //prompt
        connect(m_provider, &Provider::requestTokenResponse, this, &ChatAPI::tokenResponse, Qt::QueuedConnection);

        //finished response
        connect(m_provider, &Provider::requestFinishedResponse, this, &ChatAPI::finishedResponse, Qt::QueuedConnection);
        connect(this, &ChatAPI::requestStop, m_provider, &Provider::stop, Qt::QueuedConnection);

        if(m_model->backend() == BackendType::OfflineModel){
            emit requestLoadModel( m_model->modelName(), m_model->key());
        }

    }
    if(idModel != m_model->id()){
        setIsLoadModel(false);
        prompt(json);
        return;
    }

    setResponseInProgress(true);

    const bool stream = json->contains("stream") ? (*json)["stream"].toBool() : m_modelSettings->stream();
    const QString promptTemplate = json->contains("promptTemplate") ? (*json)["promptTemplate"].toString() : m_modelSettings->promptTemplate();
    const QString systemPrompt = json->contains("systemPrompt") ? (*json)["systemPrompt"].toString() : m_modelSettings->systemPrompt();
    const double temperature = json->contains("temperature") ? (*json)["temperature"].toDouble() : m_modelSettings->temperature();
    const int topK = json->contains("topK") ? (*json)["topK"].toInt() : m_modelSettings->topK();
    const double topP = json->contains("topP") ? (*json)["topP"].toDouble() : m_modelSettings->topP();
    const double minP = json->contains("minP") ? (*json)["minP"].toDouble() : m_modelSettings->minP();
    const double repeatPenalty = json->contains("repeatPenalty") ? (*json)["repeatPenalty"].toDouble() : m_modelSettings->repeatPenalty();
    const int promptBatchSize = json->contains("promptBatchSize") ? (*json)["promptBatchSize"].toInt() : m_modelSettings->promptBatchSize();
    const int maxTokens = json->contains("maxTokens") ? (*json)["maxTokens"].toInt() : m_modelSettings->maxTokens();
    const int repeatPenaltyTokens = json->contains("repeatPenaltyTokens") ? (*json)["repeatPenaltyTokens"].toInt() : m_modelSettings->repeatPenaltyTokens();
    const int contextLength = json->contains("contextLength") ? (*json)["contextLength"].toInt() : m_modelSettings->contextLength();
    const int numberOfGPULayers = json->contains("numberOfGPULayers") ? (*json)["numberOfGPULayers"].toInt() : m_modelSettings->numberOfGPULayers();

    m_provider->prompt(input, stream, promptTemplate, systemPrompt, temperature, topK, topP, minP, repeatPenalty,
                       promptBatchSize, maxTokens, repeatPenaltyTokens, contextLength, numberOfGPULayers);

}

void ChatAPI::loadModel(const int id){

    OfflineModel* offlineModel = OfflineModelList::instance(nullptr)->findModelById(id);
    if(offlineModel != nullptr){
        setModel(offlineModel);
    }
    OnlineModel* onlineModel = OnlineModelList::instance(nullptr)->findModelById(id);
    if(onlineModel != nullptr){
        setModel(onlineModel);
    }
}

void ChatAPI::unloadModel(){
    setIsLoadModel(false);
    m_provider->unLoadModel();
}

void ChatAPI::loadModelResult(const bool result, const QString &warning){

}

void ChatAPI::tokenResponse(const QString &token) {
    QJsonObject obj;
    obj["token"] = token;
    QJsonDocument doc(obj);
    QByteArray jsonData = doc.toJson(QJsonDocument::Compact);
    QByteArray sseData = "data: " + jsonData + "\n\n";
    m_responder->writeChunk(sseData);
}

void ChatAPI::finishedResponse(const QString &warning) {
    QJsonObject obj;
    obj["status"] = "end";
    obj["warning"] = warning;
    QJsonDocument doc(obj);
    QByteArray jsonData = doc.toJson(QJsonDocument::Compact);
    QByteArray sseData = "data: " + jsonData + "\n\n";
    m_responder->writeEndChunked(sseData);
}


void ChatAPI::updateModelSettingsDeveloper(){
    emit requestUpdateModelSettingsDeveloper(m_modelSettings->id(), m_modelSettings->stream(),
                                             m_modelSettings->promptTemplate(), m_modelSettings->systemPrompt(),
                                             m_modelSettings->temperature(), m_modelSettings->topK(),
                                             m_modelSettings->topP(), m_modelSettings->minP(),
                                             m_modelSettings->repeatPenalty(), m_modelSettings->promptBatchSize(),
                                             m_modelSettings->maxTokens(), m_modelSettings->repeatPenaltyTokens(),
                                             m_modelSettings->contextLength(), m_modelSettings->numberOfGPULayers());
}

void ChatAPI::setModelRequest(const int id, const QString &text,  const QString &icon, const QString &promptTemplate, const QString &systemPrompt){
    setModelId(id);
    setModelText(text);
    setModelIcon(icon);
    setModelPromptTemplate(promptTemplate);
    setModelSystemPrompt(systemPrompt);
    if(id == -1)
        setModelSelect(false);
    else
        setModelSelect(true);

    // if(!m_isEmptyChatAPI){
    //     if(m_modelPromptTemplate != "")
    //         m_currentChatAPI->modelSettings()->setPromptTemplate(m_modelPromptTemplate);
    //     if(m_modelSystemPrompt != "")
    //         m_currentChatAPI->modelSettings()->setSystemPrompt(m_modelSystemPrompt);
    // }
}


QString ChatAPI::modelSystemPrompt() const{return m_modelSystemPrompt;}
void ChatAPI::setModelSystemPrompt(const QString &newModelSystemPrompt){
    if (m_modelSystemPrompt == newModelSystemPrompt)
        return;
    m_modelSystemPrompt = newModelSystemPrompt;
    emit modelSystemPromptChanged();
}

QString ChatAPI::modelPromptTemplate() const{return m_modelPromptTemplate;}
void ChatAPI::setModelPromptTemplate(const QString &newModelPromptTemplate){
    if (m_modelPromptTemplate == newModelPromptTemplate)
        return;
    m_modelPromptTemplate = newModelPromptTemplate;
    emit modelPromptTemplateChanged();
}

QString ChatAPI::modelText() const{return m_modelText;}
void ChatAPI::setModelText(const QString &newModelText){
    if (m_modelText == newModelText)
        return;
    m_modelText = newModelText;
    emit modelTextChanged();
}

QString ChatAPI::modelIcon() const{return m_modelIcon;}
void ChatAPI::setModelIcon(const QString &newModelIcon){
    if (m_modelIcon == newModelIcon)
        return;
    m_modelIcon = newModelIcon;
    emit modelIconChanged();
}

int ChatAPI::modelId() const{return m_modelId;}
void ChatAPI::setModelId(int newModelId){
    if (m_modelId == newModelId)
        return;
    m_modelId = newModelId;
    emit modelIdChanged();
}

Provider *ChatAPI::provider() const { return m_provider; }
void ChatAPI::setProvider(Provider *newProvider) {
    if (m_provider == newProvider)
        return;
    m_provider = newProvider;
    emit providerChanged();
    qCInfo(logDeveloper) << "Provider changed.";
}

bool ChatAPI::modelSelect() const{return m_modelSelect;}
void ChatAPI::setModelSelect(bool newModelSelect){
    if (m_modelSelect == newModelSelect)
        return;
    m_modelSelect = newModelSelect;
    emit modelSelectChanged();
}

bool ChatAPI::responseInProgress() const{return m_responseInProgress;}
void ChatAPI::setResponseInProgress(bool newResponseInProgress){
    if (m_responseInProgress == newResponseInProgress)
        return;
    m_responseInProgress = newResponseInProgress;
    emit responseInProgressChanged();
}

bool ChatAPI::loadModelInProgress() const{return m_loadModelInProgress;}
void ChatAPI::setLoadModelInProgress(bool newLoadModelInProgress){
    if (m_loadModelInProgress == newLoadModelInProgress)
        return;
    m_loadModelInProgress = newLoadModelInProgress;
    emit loadModelInProgressChanged();
}

bool ChatAPI::isLoadModel() const{return m_isLoadModel;}
void ChatAPI::setIsLoadModel(bool newIsLoadModel){
    if (m_isLoadModel == newIsLoadModel)
        return;
    m_isLoadModel = newIsLoadModel;
    emit isLoadModelChanged();
}

ModelSettings *ChatAPI::modelSettings() const{return m_modelSettings;}

Model *ChatAPI::model() const{return m_model;}
void ChatAPI::setModel(Model *newModel){
    if (m_model == newModel)
        return;
    m_model = newModel;
    emit modelChanged();
}
