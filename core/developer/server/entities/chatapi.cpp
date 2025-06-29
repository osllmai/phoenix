#include "chatapi.h"

ChatAPI::ChatAPI(const QString &scheme, const QString &hostName, int port)
    : CrudAPI(scheme, hostName, port),
    m_isLoadModel(false),
    m_loadModelInProgress(false),
    m_responseInProgress(false),
    m_model(new Model(this)),
    m_modelId(-1),
    m_modelSettings(new ModelSettings(1, true, "### Human:\n%1\n\n### Assistant:\n",
                                      "### System:\nYou are an AI assistant who gives a quality response to whatever humans ask of you.\n\n",
                                      0.7, 40, 0.4,0.0,1.18,128,4096,64,2048,80, this)),
    m_provider(nullptr)
{
    qCInfo(logDeveloper) << "ChatAPI constructed with scheme:" << scheme << "host:" << hostName << "port:" << port;
}

QHttpServerResponse ChatAPI::getFullList() const {
    qCInfo(logDeveloper) << "GET Request";
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

QHttpServerResponse ChatAPI::getItem(qint64 itemId) const{
    qCInfo(logDeveloper) << "GET-Item Request";
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

void ChatAPI::postItem(const QHttpServerRequest &request, QSharedPointer<QHttpServerResponder> responder)
{
    qCInfo(logDeveloper) << "POST Request";

    responder->writeBeginChunked("text/event-stream");

    const std::optional<QJsonObject> json = byteArrayToJsonObject(request.body());
    if (!json) {
        qCWarning(logDeveloper) << "postItem received invalid JSON";
        QJsonObject errorObj;
        errorObj["error"] = "Invalid JSON";
        QJsonDocument doc(errorObj);
        responder->writeChunk(doc.toJson(QJsonDocument::Compact));
        responder->writeEndChunked("{}");
        return;
    }

    if (!json->contains("message") || !(*json)["message"].isString()) {
        qCWarning(logDeveloper) << "postItem missing or invalid 'message' field";
        qCWarning(logDeveloperView) << "postItem missing or invalid 'message' field";
        QJsonObject errorObj;
        errorObj["error"] = "Missing or invalid 'message' field";
        QJsonDocument doc(errorObj);
        responder->writeChunk(doc.toJson(QJsonDocument::Compact));
        responder->writeEndChunked("{}");
        return;
    }

    qCInfo(logDeveloperView) << "POST Request. message: "<< (*json)["message"].toString();

    if(json->contains("model") && (*json)["model"].isString()){
        QString modelName = (*json)["model"].toString();
        if (modelName.startsWith("localModel/")){
            modelName.remove(0, QString("localModel/").length());
            OfflineModel* offlineModel = OfflineModelList::instance(nullptr)->findModelByModelName(modelName);

            if(offlineModel != nullptr && offlineModel->isDownloading()){
                setModelId(offlineModel->id());
            }else{
                qCWarning(logDeveloper) << "models is not evailable";
                qCWarning(logDeveloperView) << "models is not evailable";
                QJsonObject errorObj;
                errorObj["error"] = "models is not evailable";
                QJsonDocument doc(errorObj);
                responder->writeChunk(doc.toJson(QJsonDocument::Compact));
                responder->writeEndChunked("{}");
                return;
            }
        }else{
            OnlineModel* onlineModel = OnlineModelList::instance(nullptr)->findModelByModelName(modelName);
            if(onlineModel != nullptr &&onlineModel->installModel() ){
                setModelId(onlineModel->id());
            }else{
                qCWarning(logDeveloper) << "models is not evailable";
                qCWarning(logDeveloperView) << "models is not evailable";
                QJsonObject errorObj;
                errorObj["error"] = "models is not evailable";
                QJsonDocument doc(errorObj);
                responder->writeChunk(doc.toJson(QJsonDocument::Compact));
                responder->writeEndChunked("{}");
                return;
            }
        }
    }else if(CodeDeveloperList::instance(nullptr)->modelId() == -1){
        setModelId(CodeDeveloperList::instance(nullptr)->modelId());
    }else{
        qCWarning(logDeveloper) << "postItem missing or invalid 'modelId' field";
        qCWarning(logDeveloperView) << "postItem missing or invalid 'modelId' field";
        QJsonObject errorObj;
        errorObj["error"] = "Missing or invalid 'modelId' field";
        QJsonDocument doc(errorObj);
        responder->writeChunk(doc.toJson(QJsonDocument::Compact));
        responder->writeEndChunked("{}");
        return;
    }

    qCInfo(logDeveloper) << "postItem valid JSON received, message:" << (*json)["message"].toString().left(50) << "model:" << (*json)["model"].toString();

    m_responder = responder;

    prompt(json);
}

QHttpServerResponse ChatAPI::updateItem(qint64 itemId, const QHttpServerRequest &request){
    qCInfo(logDeveloper) << "UPDATE-Item Request";
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

QHttpServerResponse ChatAPI::updateItemFields(qint64 itemId, const QHttpServerRequest &request){
    qCInfo(logDeveloper) << "UPDATE-Item Request";
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

QHttpServerResponse ChatAPI::deleteItem(qint64 itemId){
    qCInfo(logDeveloper) << "DELETE-Item Request";
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

void ChatAPI::prompt(const std::optional<QJsonObject> json){
    qCInfo(logDeveloper) << "prompt called";

    QString input = (*json)["message"].toString();
    qCInfo(logDeveloper) << "prompt with modelId:" << m_modelId << "and input preview:" << input.left(50);

    if(!m_isLoadModel){
        qCInfo(logDeveloper) << "Model is not loaded, loading model with id:" << m_modelId;
        loadModel(m_modelId);
        setIsLoadModel(true);

        if(m_provider != nullptr){
            qCInfo(logDeveloper) << "Disconnecting existing provider signals";
            disconnect(this, &ChatAPI::requestLoadModel, m_provider, &Provider::loadModel);
            disconnect(m_provider, &Provider::requestLoadModelResult, this, &ChatAPI::loadModelResult);
            disconnect(this, &ChatAPI::requestUnLoadModel, m_provider, &Provider::unLoadModel);
            disconnect(m_provider, &Provider::requestTokenResponse, this, &ChatAPI::tokenResponse);
            disconnect(m_provider, &Provider::requestFinishedResponse, this, &ChatAPI::finishedResponse);
            disconnect(this, &ChatAPI::requestStop, m_provider, &Provider::stop);
            delete m_provider;
            m_provider = nullptr;
            qCInfo(logDeveloper) << "Old provider deleted";
        }

        if(m_model->backend() == BackendType::OfflineModel){
            m_provider = new OfflineProvider(this);
            qCInfo(logDeveloper) << "Created OfflineProvider";
        }else if(m_model->backend() == BackendType::OnlineModel){
            m_provider = new OnlineProvider(this, m_model->company()->name() + "/" + m_model->modelName(),m_model->key());
            qCInfo(logDeveloper) << "Created OnlineProvider for company/model:" << m_model->company()->name() + "/" + m_model->modelName();
        }
        //load and unload model connections
        connect(this, &ChatAPI::requestLoadModel, m_provider, &Provider::loadModel, Qt::QueuedConnection);
        connect(m_provider, &Provider::requestLoadModelResult, this, &ChatAPI::loadModelResult, Qt::QueuedConnection);
        connect(this, &ChatAPI::requestUnLoadModel, m_provider, &Provider::unLoadModel, Qt::QueuedConnection);
        //prompt connections
        connect(m_provider, &Provider::requestTokenResponse, this, &ChatAPI::tokenResponse, Qt::QueuedConnection);
        //finished response connections
        connect(m_provider, &Provider::requestFinishedResponse, this, &ChatAPI::finishedResponse, Qt::QueuedConnection);
        connect(this, &ChatAPI::requestStop, m_provider, &Provider::stop, Qt::QueuedConnection);

        if(m_model->backend() == BackendType::OfflineModel){
            qCInfo(logDeveloper) << "Emitting requestLoadModel for model name:" << m_model->modelName();
            emit requestLoadModel( m_model->modelName(), m_model->key());
        }
    }

    if(m_modelId != m_model->id()){
        qCInfo(logDeveloper) << "Model ID mismatch, reloading model. Old ID:" << m_model->id() << "New ID:" << m_modelId;
        setIsLoadModel(false);
        prompt(json);
        return;
    }

    setResponseInProgress(true);
    qCInfo(logDeveloper) << "Response in progress set to true";

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

    qCInfo(logDeveloper) << "Calling provider->prompt with parameters:"
                         << "stream=" << stream
                         << "temperature=" << temperature
                         << "topK=" << topK
                         << "topP=" << topP
                         << "minP=" << minP
                         << "repeatPenalty=" << repeatPenalty
                         << "promptBatchSize=" << promptBatchSize
                         << "maxTokens=" << maxTokens
                         << "repeatPenaltyTokens=" << repeatPenaltyTokens
                         << "contextLength=" << contextLength
                         << "numberOfGPULayers=" << numberOfGPULayers;

    m_provider->prompt(input, stream, promptTemplate, systemPrompt, temperature, topK, topP, minP, repeatPenalty,
                       promptBatchSize, maxTokens, repeatPenaltyTokens, contextLength, numberOfGPULayers);
}

void ChatAPI::loadModel(const int id){
    qCInfo(logDeveloper) << "loadModel called with id:" << id;

    OfflineModel* offlineModel = OfflineModelList::instance(nullptr)->findModelById(id);
    if(offlineModel != nullptr){
        qCInfo(logDeveloper) << "Offline model found for id:" << id;
        setModel(offlineModel);
    }
    OnlineModel* onlineModel = OnlineModelList::instance(nullptr)->findModelById(id);
    if(onlineModel != nullptr){
        qCInfo(logDeveloper) << "Online model found for id:" << id;
        setModel(onlineModel);
    }
}

void ChatAPI::unloadModel(){
    qCInfo(logDeveloper) << "unloadModel called";
    setIsLoadModel(false);
    m_provider->unLoadModel();
}

void ChatAPI::loadModelResult(const bool result, const QString &warning){
    qCInfo(logDeveloper) << "loadModelResult called with result:" << result << "warning:" << warning;
}

void ChatAPI::tokenResponse(const QString &token) {
    qCInfo(logDeveloper) << "tokenResponse called with token:" << token;
    qCInfo(logDeveloperView) << token;
    QJsonObject obj;
    obj["response"] = token;
    QJsonDocument doc(obj);
    QByteArray jsonData = doc.toJson(QJsonDocument::Compact);
    QByteArray sseData = "data: " + jsonData + "\n\n";

    m_responder->writeChunk(sseData);
}

void ChatAPI::finishedResponse(const QString &warning) {
    qCInfo(logDeveloper) << "finishedResponse called with warning:" << warning;
    qCInfo(logDeveloper) << "finishedResponse called ";
    QJsonObject obj;
    obj["status"] = "end";
    obj["warning"] = warning;
    QJsonDocument doc(obj);
    QByteArray jsonData = doc.toJson(QJsonDocument::Compact);
    QByteArray sseData = "data: " + jsonData + "\n\n";
    m_responder->writeEndChunked(sseData);
}

void ChatAPI::updateModelSettingsDeveloper(){
    qCInfo(logDeveloper) << "updateModelSettingsDeveloper called";
    emit requestUpdateModelSettingsDeveloper(m_modelSettings->id(), m_modelSettings->stream(),
                                             m_modelSettings->promptTemplate(), m_modelSettings->systemPrompt(),
                                             m_modelSettings->temperature(), m_modelSettings->topK(),
                                             m_modelSettings->topP(), m_modelSettings->minP(),
                                             m_modelSettings->repeatPenalty(), m_modelSettings->promptBatchSize(),
                                             m_modelSettings->maxTokens(), m_modelSettings->repeatPenaltyTokens(),
                                             m_modelSettings->contextLength(), m_modelSettings->numberOfGPULayers());
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
