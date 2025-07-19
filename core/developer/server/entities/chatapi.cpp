#include "chatapi.h"

ChatAPI::ChatAPI(const QString &scheme, const QString &hostName, int port)
    : CrudAPI(scheme, hostName, port),
    m_loadModelInProgress(false),
    m_responseInProgress(false),
    m_model(new Model(this)),
    m_modelSettings(new ModelSettings(1, this)),
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

void ChatAPI::postItem(const QHttpServerRequest &request, QSharedPointer<QHttpServerResponder> responder){
    responder->writeBeginChunked("text/event-stream");

    const std::optional<QJsonObject> json = byteArrayToJsonObject(request.body());
    if (!json) {
        writeError("Invalid JSON");
        return;
    }

    if (!json->contains("message") || !(*json)["message"].isString()) {
        writeError("Missing or invalid 'message' field");
        return;
    }

    qCInfo(logDeveloperView) << "POST Request. message: "<< (*json)["message"].toString();

    if(json->contains("model") && (*json)["model"].isString()){
        if(!loadModel((*json)["model"].toString())){
            writeError("Invalid 'model' field");
            return;
        }
        qCInfo(logDeveloperView) << "Model selected successfully: " << m_model->name();

    }else if(CodeDeveloperList::instance(nullptr)->modelId() != -1){
        if(!loadModel(CodeDeveloperList::instance(nullptr)->modelId())){
            writeError("Missing 'model' field");
            return;
        }
        qCInfo(logDeveloperView) << "Default model selected successfully. Model: " << m_model->name();

    }else{
        writeError("Missing or invalid 'model' field");
        return;
    }

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

    QString input = (*json)["message"].toString();

    if (m_provider) {
        m_provider->deleteLater();
        m_provider = nullptr;
    }

    m_provider = (m_model->backend() == BackendType::OfflineModel)
                     ? static_cast<Provider *>(new OfflineProvider(this))
                     : static_cast<Provider *>(new OnlineProvider(this, m_model->company()->name() + "/" + m_model->modelName(), m_model->key()));

    connect(this, &ChatAPI::requestLoadModel, m_provider, &Provider::loadModel, Qt::QueuedConnection);
    connect(m_provider, &Provider::requestLoadModelResult, this, &ChatAPI::loadModelResult, Qt::QueuedConnection);
    connect(m_provider, &Provider::requestTokenResponse, this, &ChatAPI::tokenResponse, Qt::QueuedConnection);
    connect(m_provider, &Provider::requestFinishedResponse, this, &ChatAPI::finishedResponse, Qt::QueuedConnection);

    if (m_model->backend() == BackendType::OfflineModel) {
        emit requestLoadModel(m_model->modelName(), m_model->key());
    }

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

bool ChatAPI::loadModel(QString modelName){
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

bool ChatAPI::loadModel(int id){
    if (OfflineModel *offline = OfflineModelList::instance(nullptr)->findModelById(id)) {
        setModel(offline);
    } else if (OnlineModel *online = OnlineModelList::instance(nullptr)->findModelById(id)) {
        setModel(online);
    } else {
        return false;
    }
    return true;
}

void ChatAPI::loadModelResult(const bool result, const QString &warning){
    qCInfo(logDeveloperView) << "Model load result:" << result << "| Warning:" << warning;
}

void ChatAPI::tokenResponse(const QString &token) {
    writeToken(token);
}

void ChatAPI::finishedResponse(const QString &warning) {
    writeFinished(warning);
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

ModelSettings *ChatAPI::modelSettings() const{return m_modelSettings;}

Model *ChatAPI::model() const{return m_model;}
void ChatAPI::setModel(Model *newModel){
    if (m_model == newModel)
        return;
    m_model = newModel;
    emit modelChanged();
}

void ChatAPI::writeInfo(const QString &message) {
    qCInfo(logDeveloperView) << message;
    QJsonObject obj;
    obj["message"] = message;
    writeJson(obj);
}

void ChatAPI::writeError(const QString &errorMessage, bool end) {
    qCWarning(logDeveloperView) << errorMessage;
    QJsonObject obj;
    obj["error"] = errorMessage;
    writeJson(obj, end);
}

void ChatAPI::writeJson(const QJsonObject &obj, bool end) {
    QJsonDocument doc(obj);
    QByteArray jsonData = doc.toJson(QJsonDocument::Compact);
    QByteArray sseData = "data: " + jsonData + "\n\n";
    if (end)
        m_responder->writeEndChunked(sseData);
    else
        m_responder->writeChunk(sseData);
}

void ChatAPI::writeToken(const QString &token) {
    qCInfo(logDeveloperView) << token;
    QJsonObject obj;
    obj["response"] = token;
    writeJson(obj);
}

void ChatAPI::writeFinished(const QString &warning) {
    qCInfo(logDeveloperView) << warning;
    QJsonObject obj;
    obj["status"] = "end";
    obj["warning"] = warning;
    writeJson(obj, true);
}

void ChatAPI::beginChunked() {
    m_responder->writeBeginChunked("text/event-stream");
}

