#include "codedeveloperlist.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QCoreApplication>
#include <QLoggingCategory>
#include "../log/logcategories.h"

CodeDeveloperList* CodeDeveloperList::m_instance = nullptr;

CodeDeveloperList* CodeDeveloperList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new CodeDeveloperList(parent);
        qCInfo(logDeveloper) << "CodeDeveloperList instance created.";
    }
    return m_instance;
}

CodeDeveloperList::CodeDeveloperList(QObject *parent)
    : QAbstractListModel(parent),
    m_port(8080),
    m_isRuning(false),
    m_modelSelect(false),
    m_isLoadModel(false),
    m_loadModelInProgress(false),
    m_responseInProgress(false),
    m_model(new Model(this)),
    m_modelSettings(new ModelSettings(1, true, "### Human:\n%1\n\n### Assistant:\n",
                                    "### System:\nYou are an AI assistant who gives a quality response to whatever humans ask of you.\n\n",
                                     0.7, 40, 0.4,0.0,1.18,128,4096,64,2048,80, this)),
    m_provider(nullptr)
{
    QList<QPair<int, QString>> languages = {
        {0, "Curl"},
        {1, "Python"},
        {2, "NodeJS"},
        {3, "JavaScript"}
    };

    for (const auto& lang : languages) {
        m_programLanguags.append(new ProgramLanguage(lang.first, lang.second, this));
        qCDebug(logDeveloper) << "Loaded language:" << lang.second;
    }

    m_currentProgramLanguage = m_programLanguags.first();
    m_currentProgramLanguage->setCodeGenerator(new CurlCodeGenerator());
    qCInfo(logDeveloper) << "Default language set to Curl";
}

bool CodeDeveloperList::modelSelect() const{return m_modelSelect;}
void CodeDeveloperList::setModelSelect(bool newModelSelect){
    if (m_modelSelect == newModelSelect)
        return;
    m_modelSelect = newModelSelect;
    emit modelSelectChanged();
}

void CodeDeveloperList::setModelRequest(const int id, const QString &text,  const QString &icon, const QString &promptTemplate, const QString &systemPrompt){
    setModelId(id);
    setModelText(text);
    setModelIcon(icon);
    setModelPromptTemplate(promptTemplate);
    setModelSystemPrompt(systemPrompt);
    if(id == -1)
        setModelSelect(false);
    else
        setModelSelect(true);

    // if(!m_isEmptyCodeDeveloperList){
    //     if(m_modelPromptTemplate != "")
    //         m_currentCodeDeveloperList->modelSettings()->setPromptTemplate(m_modelPromptTemplate);
    //     if(m_modelSystemPrompt != "")
    //         m_currentCodeDeveloperList->modelSettings()->setSystemPrompt(m_modelSystemPrompt);
    // }
}

void CodeDeveloperList::prompt(const QString &input, const int idModel){
    if(!m_isLoadModel){
        loadModel(idModel);
        setIsLoadModel(true);
        if(m_provider != nullptr){
            //disconnect load and unload model
            disconnect(this, &CodeDeveloperList::requestLoadModel, m_provider, &Provider::loadModel);
            disconnect(m_provider, &Provider::requestLoadModelResult, this, &CodeDeveloperList::loadModelResult);
            disconnect(this, &CodeDeveloperList::requestUnLoadModel, m_provider, &Provider::unLoadModel);

            //disconnect prompt
            disconnect(m_provider, &Provider::requestTokenResponse, this, &CodeDeveloperList::tokenResponse);

            //disconnect finished response
            disconnect(m_provider, &Provider::requestFinishedResponse, this, &CodeDeveloperList::finishedResponse);
            disconnect(this, &CodeDeveloperList::requestStop, m_provider, &Provider::stop);
            delete m_provider;
        }

        if(m_model->backend() == BackendType::OfflineModel){
            m_provider = new OfflineProvider(this);
        }else if(m_model->backend() == BackendType::OnlineModel){
            m_provider = new OnlineProvider(this, m_model->company()->name() + "/" + m_model->modelName(),m_model->key());
        }
        //load and unload model
        connect(this, &CodeDeveloperList::requestLoadModel, m_provider, &Provider::loadModel, Qt::QueuedConnection);
        connect(m_provider, &Provider::requestLoadModelResult, this, &CodeDeveloperList::loadModelResult, Qt::QueuedConnection);
        connect(this, &CodeDeveloperList::requestUnLoadModel, m_provider, &Provider::unLoadModel, Qt::QueuedConnection);

        //prompt
        connect(m_provider, &Provider::requestTokenResponse, this, &CodeDeveloperList::tokenResponse, Qt::QueuedConnection);

        //finished response
        connect(m_provider, &Provider::requestFinishedResponse, this, &CodeDeveloperList::finishedResponse, Qt::QueuedConnection);
        connect(this, &CodeDeveloperList::requestStop, m_provider, &Provider::stop, Qt::QueuedConnection);

        if(m_model->backend() == BackendType::OfflineModel){
            emit requestLoadModel( m_model->modelName(), m_model->key());
        }

    }
    if(idModel != m_model->id()){
        setIsLoadModel(false);
        prompt(input, idModel);
        return;
    }

    setResponseInProgress(true);
    m_provider->prompt(input, m_modelSettings->stream(), m_modelSettings->promptTemplate(),
                       m_modelSettings->systemPrompt(),m_modelSettings->temperature(),m_modelSettings->topK(),
                       m_modelSettings->topP(),m_modelSettings->minP(),m_modelSettings->repeatPenalty(),
                       m_modelSettings->promptBatchSize(),m_modelSettings->maxTokens(),
                       m_modelSettings->repeatPenaltyTokens(),m_modelSettings->contextLength(),
                       m_modelSettings->numberOfGPULayers());
}

bool CodeDeveloperList::responseInProgress() const{return m_responseInProgress;}
void CodeDeveloperList::setResponseInProgress(bool newResponseInProgress){
    if (m_responseInProgress == newResponseInProgress)
        return;
    m_responseInProgress = newResponseInProgress;
    emit responseInProgressChanged();
}

bool CodeDeveloperList::loadModelInProgress() const{return m_loadModelInProgress;}
void CodeDeveloperList::setLoadModelInProgress(bool newLoadModelInProgress){
    if (m_loadModelInProgress == newLoadModelInProgress)
        return;
    m_loadModelInProgress = newLoadModelInProgress;
    emit loadModelInProgressChanged();
}

bool CodeDeveloperList::isLoadModel() const{return m_isLoadModel;}
void CodeDeveloperList::setIsLoadModel(bool newIsLoadModel){
    if (m_isLoadModel == newIsLoadModel)
        return;
    m_isLoadModel = newIsLoadModel;
    emit isLoadModelChanged();
}

ModelSettings *CodeDeveloperList::modelSettings() const{return m_modelSettings;}

Model *CodeDeveloperList::model() const{return m_model;}
void CodeDeveloperList::setModel(Model *newModel){
    if (m_model == newModel)
        return;
    m_model = newModel;
    emit modelChanged();
}

void CodeDeveloperList::loadModel(const int id){

    OfflineModel* offlineModel = OfflineModelList::instance(nullptr)->findModelById(id);
    if(offlineModel != nullptr){
        setModel(offlineModel);
    }
    OnlineModel* onlineModel = OnlineModelList::instance(nullptr)->findModelById(id);
    if(onlineModel != nullptr){
        setModel(onlineModel);
    }
}

void CodeDeveloperList::unloadModel(){
    setIsLoadModel(false);
    m_provider->unLoadModel();
}

void CodeDeveloperList::loadModelResult(const bool result, const QString &warning){

}

void CodeDeveloperList::tokenResponse(const QString &token){

}

void CodeDeveloperList::finishedResponse(const QString &warning){

}

void CodeDeveloperList::updateModelSettingsDeveloper(){
    emit requestUpdateModelSettingsDeveloper(m_modelSettings->id(), m_modelSettings->stream(),
                                                m_modelSettings->promptTemplate(), m_modelSettings->systemPrompt(),
                                                m_modelSettings->temperature(), m_modelSettings->topK(),
                                                m_modelSettings->topP(), m_modelSettings->minP(),
                                                m_modelSettings->repeatPenalty(), m_modelSettings->promptBatchSize(),
                                                m_modelSettings->maxTokens(), m_modelSettings->repeatPenaltyTokens(),
                                                m_modelSettings->contextLength(), m_modelSettings->numberOfGPULayers());
}


QString CodeDeveloperList::modelSystemPrompt() const{return m_modelSystemPrompt;}
void CodeDeveloperList::setModelSystemPrompt(const QString &newModelSystemPrompt){
    if (m_modelSystemPrompt == newModelSystemPrompt)
        return;
    m_modelSystemPrompt = newModelSystemPrompt;
    emit modelSystemPromptChanged();
}

QString CodeDeveloperList::modelPromptTemplate() const{return m_modelPromptTemplate;}
void CodeDeveloperList::setModelPromptTemplate(const QString &newModelPromptTemplate){
    if (m_modelPromptTemplate == newModelPromptTemplate)
        return;
    m_modelPromptTemplate = newModelPromptTemplate;
    emit modelPromptTemplateChanged();
}

QString CodeDeveloperList::modelText() const{return m_modelText;}
void CodeDeveloperList::setModelText(const QString &newModelText){
    if (m_modelText == newModelText)
        return;
    m_modelText = newModelText;
    emit modelTextChanged();
}

QString CodeDeveloperList::modelIcon() const{return m_modelIcon;}
void CodeDeveloperList::setModelIcon(const QString &newModelIcon){
    if (m_modelIcon == newModelIcon)
        return;
    m_modelIcon = newModelIcon;
    emit modelIconChanged();
}

int CodeDeveloperList::modelId() const{return m_modelId;}
void CodeDeveloperList::setModelId(int newModelId){
    if (m_modelId == newModelId)
        return;
    m_modelId = newModelId;
    emit modelIdChanged();
}

Provider *CodeDeveloperList::provider() const { return m_provider; }
void CodeDeveloperList::setProvider(Provider *newProvider) {
    if (m_provider == newProvider)
        return;
    m_provider = newProvider;
    emit providerChanged();
    qCInfo(logDeveloper) << "Provider changed.";
}

bool CodeDeveloperList::isRuning() const { return m_isRuning; }
void CodeDeveloperList::setIsRuning(bool newIsRuning) {
    if (m_isRuning == newIsRuning)
        return;
    m_isRuning = newIsRuning;
    emit isRuningChanged();
    qCInfo(logDeveloper) << "isRuning set to" << newIsRuning;
}

int CodeDeveloperList::port() const { return m_port; }
void CodeDeveloperList::setPort(int newPort) {
    if (m_port == newPort)
        return;
    m_port = newPort;
    emit portChanged();
    qCInfo(logDeveloper) << "Port changed to" << m_port;
}

void CodeDeveloperList::setCurrentLanguage(int newId) {
    for (int number = 0; number < m_programLanguags.size(); number++) {
        ProgramLanguage* programLanguage = m_programLanguags[number];
        if (programLanguage->id() == newId) {
            setCurrentProgramLanguage(programLanguage);
            break;
        }
    }
}

void CodeDeveloperList::start() {
    if (m_isRuning) {
        qCWarning(logDeveloper) << "Server already running.";
        return;
    }

    m_httpServer = new QHttpServer(this);

    auto createResponse = [](const QJsonObject &jsonObj) {
        QByteArray body = QJsonDocument(jsonObj).toJson();
        return QHttpServerResponse(body, "application/json", QHttpServerResponse::StatusCode::Ok);
    };

    m_httpServer->route("/models/", QHttpServerRequest::Method::Get, [this, createResponse]() {
        QJsonArray modelsArray;
        for (const auto& lang : m_programLanguags) {
            QJsonObject obj;
            obj["id"] = lang->id();
            obj["name"] = lang->name();
            modelsArray.append(obj);
        }
        qCDebug(logDeveloper) << "GET /models/ called.";
        return createResponse(QJsonObject{{"models", modelsArray}});
    });

    m_httpServer->route("/models/", QHttpServerRequest::Method::Post, [createResponse]() {
        qCWarning(logDeveloper) << "POST /models/ not allowed.";
        return createResponse(QJsonObject{
            {"error", QJsonObject{
                          {"message", "POST not allowed on /models/. Use GET."},
                          {"type", "invalid_request_error"}
                      }}
        });
    });

    m_httpServer->route("/chat/", QHttpServerRequest::Method::Post, [this, createResponse](const QHttpServerRequest &request) {
        QJsonParseError parseError;
        QJsonDocument jsonDoc = QJsonDocument::fromJson(request.body(), &parseError);
        if (parseError.error != QJsonParseError::NoError || !jsonDoc.isObject()) {
            qCWarning(logDeveloper) << "Invalid JSON in /chat/ request:" << parseError.errorString();
            return createResponse(QJsonObject{{"error", "Invalid JSON format."}});
        }

        QJsonObject jsonObj = jsonDoc.object();

        QString model = jsonObj.value("model").toString();
        QJsonArray messages = jsonObj.value("messages").toArray();
        double temperature = jsonObj.value("temperature").toDouble(0.7);
        int maxTokens = jsonObj.value("max_tokens").toInt(-1);
        bool stream = jsonObj.value("stream").toBool(false);

        qCDebug(logDeveloper) << "POST /chat/ model:" << model
                              << "temperature:" << temperature
                              << "stream:" << stream
                              << "max_tokens:" << maxTokens;

        QString finalReply = "Today is Thursday, the sky is blue,\nI answer in rhymes, just for you!";

        QJsonObject responseObj{
            {"model", model},
            {"temperature", temperature},
            {"stream", stream},
            {"max_tokens", maxTokens},
            {"reply", finalReply}
        };

        return createResponse(responseObj);
    });

    m_httpServer->route("/chat/", QHttpServerRequest::Method::Get, [createResponse]() {
        qCWarning(logDeveloper) << "GET on /chat/ is not allowed.";
        return createResponse(QJsonObject{
            {"error", QJsonObject{
                          {"message", "Only POST requests are accepted on /chat/"},
                          {"type", "invalid_request_error"},
                          {"code", "method_not_supported"}
                      }}
        });
    });

    m_httpServer->route("/chat/", [createResponse](const QHttpServerRequest &request) {
        if (request.method() != QHttpServerRequest::Method::Post &&
            request.method() != QHttpServerRequest::Method::Get) {
            qCWarning(logDeveloper) << "Unsupported HTTP method on /chat/: " << request.method();
            return createResponse(QJsonObject{
                {"error", QJsonObject{
                              {"message", "HTTP method not allowed."},
                              {"type", "invalid_request_error"}
                          }}
            });
        }
        return QHttpServerResponse(QHttpServerResponder::StatusCode::MethodNotAllowed);
    });

    auto tcpServer = new QTcpServer(this);
    if (!tcpServer->listen(QHostAddress::Any, m_port) || !m_httpServer->bind(tcpServer)) {
        qCWarning(logDeveloper) << "Failed to bind HTTP server to port" << m_port;
        return;
    }

    setIsRuning(true);
    qCInfo(logDeveloper) << "HTTP server started on port" << m_port;
}

ProgramLanguage *CodeDeveloperList::getCurrentProgramLanguage() const { return m_currentProgramLanguage; }

void CodeDeveloperList::setCurrentProgramLanguage(ProgramLanguage *newCurrentProgramLanguage) {
    if (m_currentProgramLanguage == newCurrentProgramLanguage)
        return;

    if (m_currentProgramLanguage != nullptr)
        m_currentProgramLanguage->setCodeGenerator(nullptr);

    if (newCurrentProgramLanguage) {
        CodeGenerator* generator = nullptr;

        switch (newCurrentProgramLanguage->id()) {
        case 0:
            generator = new CurlCodeGenerator();
            break;
        case 1:
            generator = new PythonRequestsCodeGenerator();
            break;
        case 2:
            generator = new NodeJsAxiosCodeGenerator();
            break;
        case 3:
            generator = new JavascriptFetchCodeGenerator();
            break;
        default:
            qCWarning(logDeveloper) << "Unsupported language ID:" << newCurrentProgramLanguage->id();
            break;
        }

        newCurrentProgramLanguage->setCodeGenerator(generator);
        qCInfo(logDeveloper) << "Code generator set for language:" << newCurrentProgramLanguage->name();
    }

    m_currentProgramLanguage = newCurrentProgramLanguage;
    emit currentProgramLanguageChanged();
    qCInfo(logDeveloper) << "Current language changed to:" << newCurrentProgramLanguage->name();
}

int CodeDeveloperList::count() const { return m_programLanguags.count(); }

int CodeDeveloperList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent);
    return m_programLanguags.count();
}

QVariant CodeDeveloperList::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_programLanguags.count())
        return QVariant();

    ProgramLanguage* programLanguag = m_programLanguags.at(index.row());

    switch (role) {
    case IDRole:
        return programLanguag->id();
    case NameRole:
        return programLanguag->name();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> CodeDeveloperList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IDRole] = "id";
    roles[NameRole] = "name";
    return roles;
}
