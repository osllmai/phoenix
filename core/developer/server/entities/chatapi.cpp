#include "chatapi.h"

ChatAPI::ChatAPI(const QString &scheme, const QString &hostName, int port)
    : CrudAPI(scheme, hostName, port),
    m_model(new Model(this)),
    m_modelSettings(new ModelSettings(1, this)),
    m_provider(nullptr)
{}

ChatAPI::~ChatAPI(){
    if(m_provider){
        delete m_provider;
        m_provider = nullptr;
    }
}

QHttpServerResponse ChatAPI::getFullList() const {
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

QHttpServerResponse ChatAPI::getItem(qint64 itemId) const{
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

void ChatAPI::postItem(const QHttpServerRequest &request, QSharedPointer<QHttpServerResponder> responder){
    responder->writeBeginChunked("text/event-stream");

    if (m_responseInProgress) {
        qCWarning(logDeveloperView) << "Another POST request is already in progress";
        QJsonObject obj;
        obj["error"] = "Server is busy. Please wait for the previous request to finish.";
        QJsonDocument doc(obj);
        QByteArray jsonData = doc.toJson(QJsonDocument::Compact);
        responder->writeEndChunked(jsonData);
        return;
    }


    m_responseInProgress = true;
    m_responder = responder;

    const std::optional<QJsonObject> json = byteArrayToJsonObject(request.body());
    if (!json) {
        writeFinished("Invalid JSON");
        return;
    }

    if (!json->contains("message") || !(*json)["message"].isString()) {
        writeFinished("Missing or invalid 'message' field");
        return;
    }

    qCInfo(logDeveloperView) << "POST Request. message: "<< (*json)["message"].toString();

    if(json->contains("model") && (*json)["model"].isString()){
        if(!loadModel((*json)["model"].toString())){
            writeFinished("Invalid 'model' field");
            return;
        }
        qCInfo(logDeveloperView) << "Model selected successfully: " << m_model->name();

    }else if(CodeDeveloperList::instance(nullptr)->modelId() != -1){
        if(!loadModel(CodeDeveloperList::instance(nullptr)->modelId())){
            writeFinished("Missing 'model' field");
            return;
        }
        qCInfo(logDeveloperView) << "Default model selected successfully. Model: " << m_model->name();

    }else{
        writeFinished("Missing or invalid 'model' field");
        return;
    }

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
                     : static_cast<Provider *>(new OnlineProvider(this, /*m_model->company()->name() + "/" +*/ m_model->modelName(), m_model->key()));

    connect(this, &ChatAPI::requestLoadModel, m_provider, &Provider::loadModel, Qt::QueuedConnection);
    connect(m_provider, &Provider::requestLoadModelResult, this, &ChatAPI::loadModelResult, Qt::QueuedConnection);
    connect(m_provider, &Provider::requestTokenResponse, this, &ChatAPI::tokenResponse, Qt::QueuedConnection);
    connect(m_provider, &Provider::requestFinishedResponse, this, &ChatAPI::finishedResponse, Qt::QueuedConnection);

    if (m_model->backend() == BackendType::OfflineModel) {
        emit requestLoadModel(m_model->modelName(), m_model->key());
    }

    const bool stream = json->contains("stream")? toBoolFlexible((*json)["stream"], m_modelSettings->stream()): m_modelSettings->stream();
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
        // modelName.remove(0, QString("localModel/").length());
        OfflineModel *offlineModel = OfflineModelList::instance(nullptr)->findModelByModelName(modelName);
        if (offlineModel && offlineModel->downloadFinished()) {
            setModel(offlineModel);
        } else {
            return false;
        }
    } else {
        OnlineModel* onlineModel = OnlineCompanyList::instance(nullptr)->findCompanyByName(modelName)->onlineModelList()->findModelByModelName(modelName);
        if(OnlineCompanyList::instance(nullptr)->findCompanyByName(modelName)->installModel() && onlineModel){
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
    } else if (OnlineModel *online = OnlineCompanyList::instance(nullptr)->findCompanyById(id)->onlineModelList()->currentModel()) {
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
    if (m_responder.isNull()) {
        qCWarning(logDeveloperView) << "Responder is null. Stopping generation.";
        m_provider->stop();
        return;
    }
    writeToken(token);
}

void ChatAPI::finishedResponse(const QString &warning) {
    if (m_provider) {
        disconnect(this, &ChatAPI::requestLoadModel, m_provider, &Provider::loadModel);
        disconnect(m_provider, &Provider::requestLoadModelResult, this, &ChatAPI::loadModelResult);
        disconnect(m_provider, &Provider::requestTokenResponse, this, &ChatAPI::tokenResponse);
        disconnect(m_provider, &Provider::requestFinishedResponse, this, &ChatAPI::finishedResponse);
        m_provider->deleteLater();
        m_provider = nullptr;
    }

    if (m_responder.isNull()) {
        m_responseInProgress = false;
        m_responder.clear();
        return;
    }
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

bool ChatAPI::toBoolFlexible(const QJsonValue &value, bool defaultValue) {
    if (value.isBool()) {
        return value.toBool();
    } else if (value.isString()) {
        QString str = value.toString().trimmed().toLower();
        if (str == "true") return true;
        if (str == "false") return false;
    }
    return defaultValue;
}

Provider *ChatAPI::provider() const { return m_provider; }
void ChatAPI::setProvider(Provider *newProvider) {
    if (m_provider == newProvider)
        return;
    m_provider = newProvider;
    emit providerChanged();
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
    if (end){
        m_responder->writeEndChunked(sseData);
        m_responder.clear();
    }else
        m_responder->writeChunk(sseData);
}

void ChatAPI::writeToken(const QString &token) {
    qCInfo(logDeveloperView) << token;
    QJsonObject obj;
    obj["response"] = token;
    writeJson(obj);
}

void ChatAPI::writeFinished(const QString &warning) {
    if(warning != "")
        qCWarning(logDeveloperView) << warning;
    QJsonObject obj;
    obj["status"] = "end";
    obj["warning"] = warning;
    writeJson(obj, true);
    m_responseInProgress = false;
}

void ChatAPI::beginChunked() {
    m_responder->writeBeginChunked("text/event-stream");
}
