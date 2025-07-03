#include "codedeveloperlist.h"

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
    m_portSocket(49425),
    m_isRunningSocket(false),
    m_portAPI(8080),
    m_isRunningAPI(false),
    m_modelSelect(false)
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

    //info api connection
    m_parserModel.setApplicationDescription("Qt Developer Server");
    m_parserModel.addHelpOption();
    m_parserModel.addOptions({
        { "portAPI", QCoreApplication::translate("main", "The portAPIt the server listens on."), "portAPI" }
    });

    m_parserModel.process(*appAPI);

    Q_ASSERT(!m_tcpServer);
    m_httpServer = new QHttpServer(this);

    m_tcpServer = std::make_unique<QTcpServer>();
    //end info api connection

    setIsRunningAPI(true);

    //create API
    appAPI = QCoreApplication::instance();
    if (!appAPI) {
        qCWarning(logDeveloper) << "QCoreApplication instance is null!";
        return;
    }

    //create socket
   appSocket = QCoreApplication::instance();
}

void CodeDeveloperList::setModelRequest(const int id, const QString &text,  const QString &icon, const QString &promptTemplate, const QString &systemPrompt){
    setModelId(id);
    setModelText(text);
    setModelIcon(icon);
    setModelPromptTemplate(promptTemplate);
    setModelSystemPrompt(systemPrompt);
    if(id == -1)
        setModelSelect(false);
    else{
        setModelSelect(true);

        OfflineModel* offlineModel = OfflineModelList::instance(nullptr)->findModelById(id);
        if(offlineModel != nullptr){
            getCurrentProgramLanguage()->getCodeGenerator()->setModelName("localModel/"+offlineModel->modelName());
        }
        OnlineModel* onlineModel = OnlineModelList::instance(nullptr)->findModelById(id);
        if(onlineModel != nullptr){
            getCurrentProgramLanguage()->getCodeGenerator()->setModelName(onlineModel->company()->name() + "/" + onlineModel->modelName());
        }
    }
}

void CodeDeveloperList::addCrudRoutes(const QString &apiPath, std::optional<std::unique_ptr<CrudAPI>> &apiOpt)
{
    if (!m_httpServer || !apiOpt.has_value()) {
        qCWarning(logDeveloper) << "Failed to add routes for" << apiPath << ": Server or API not available.";
        return;
    }

    qCInfo(logDeveloper) << "Adding CRUD routes for path:" << apiPath;

    auto &api = apiOpt.value();

    // GET /apiPath
    m_httpServer->route(QString("%1").arg(apiPath), QHttpServerRequest::Method::Get,
                        [this, &api]() {
                            if (!isRunningAPI())
                                return QHttpServerResponse(QHttpServerResponder::StatusCode::ServiceUnavailable);
                            return api->getFullList();
                        });

    // GET /apiPath/<id>
    m_httpServer->route(QString("%1/<arg>").arg(apiPath), QHttpServerRequest::Method::Get,
                        [this, &api](qint64 itemId) {
                            if (!isRunningAPI())
                                return QHttpServerResponse(QHttpServerResponder::StatusCode::ServiceUnavailable);
                            return api->getItem(itemId);
                        });

    // POST /apiPath
    m_httpServer->route(QString("%1").arg(apiPath), QHttpServerRequest::Method::Post,
                        [this, &api](const QHttpServerRequest &request, QHttpServerResponder &responder) {
                            if (!isRunningAPI()) {
                                responder.write(QByteArray("Service unavailable"), "text/plain", QHttpServerResponder::StatusCode::ServiceUnavailable);
                                return;
                            }
                            QSharedPointer<QHttpServerResponder> responderPtr = QSharedPointer<QHttpServerResponder>::create(std::move(responder));
                            api->postItem(request, responderPtr);
                        });

    // PUT /apiPath/<id>
    m_httpServer->route(QString("%1/<arg>").arg(apiPath), QHttpServerRequest::Method::Put,
                        [this, &api](qint64 itemId, const QHttpServerRequest &request) {
                            if (!isRunningAPI())
                                return QHttpServerResponse(QHttpServerResponder::StatusCode::ServiceUnavailable);
                            return api->updateItem(itemId, request);
                        });

    // PATCH /apiPath/<id>
    m_httpServer->route(QString("%1/<arg>").arg(apiPath), QHttpServerRequest::Method::Patch,
                        [this, &api](qint64 itemId, const QHttpServerRequest &request) {
                            if (!isRunningAPI())
                                return QHttpServerResponse(QHttpServerResponder::StatusCode::ServiceUnavailable);
                            return api->updateItemFields(itemId, request);
                        });

    // DELETE /apiPath/<id>
    m_httpServer->route(QString("%1/<arg>").arg(apiPath), QHttpServerRequest::Method::Delete,
                        [this, &api](qint64 itemId, const QHttpServerRequest &request) {
                            if (!isRunningAPI())
                                return QHttpServerResponse(QHttpServerResponder::StatusCode::ServiceUnavailable);
                            return api->deleteItem(itemId);
                        });


    qCDebug(logDeveloper) << "CRUD routes added for" << apiPath;
}

ProgramLanguage *CodeDeveloperList::getCurrentProgramLanguage() const { return m_currentProgramLanguage; }
void CodeDeveloperList::setCurrentProgramLanguage(ProgramLanguage *newCurrentProgramLanguage) {
    if (m_currentProgramLanguage == newCurrentProgramLanguage)
        return;

    CodeGenerator* previousGenerator = nullptr;
    if (m_currentProgramLanguage != nullptr)
        previousGenerator = m_currentProgramLanguage->getCodeGenerator();

    if (newCurrentProgramLanguage) {
        CodeGenerator* newGenerator = nullptr;

        QString modelName = previousGenerator ? previousGenerator->modelName() : "Openai/gpt-4o";
        quint16 port = previousGenerator ? previousGenerator->port() : 8080;

        bool stream = previousGenerator ? previousGenerator->stream() : true;
        QString promptTemplate = previousGenerator ? previousGenerator->promptTemplate() : "";
        QString systemPrompt = previousGenerator ? previousGenerator->systemPrompt() : "";
        double temperature = previousGenerator ? previousGenerator->temperature() : 0.7;
        int topK = previousGenerator ? previousGenerator->topK() : 40;
        double topP = previousGenerator ? previousGenerator->topP() : 0.95;
        double minP = previousGenerator ? previousGenerator->minP() : 0.05;
        double repeatPenalty = previousGenerator ? previousGenerator->repeatPenalty() : 1.1;
        int promptBatchSize = previousGenerator ? previousGenerator->promptBatchSize() : 1;
        int maxTokens = previousGenerator ? previousGenerator->maxTokens() : 512;
        int repeatPenaltyTokens = previousGenerator ? previousGenerator->repeatPenaltyTokens() : 64;
        int contextLength = previousGenerator ? previousGenerator->contextLength() : 2048;
        int numberOfGPULayers = previousGenerator ? previousGenerator->numberOfGPULayers() : 20;
        bool topKVisible = previousGenerator ? previousGenerator->topKVisible() : false;
        bool topPVisible = previousGenerator ? previousGenerator->topPVisible() : false;
        bool minPVisible = previousGenerator ? previousGenerator->minPVisible() : false;
        bool repeatPenaltyVisible = previousGenerator ? previousGenerator->repeatPenaltyVisible() : false;
        bool promptBatchSizeVisible = previousGenerator ? previousGenerator->promptBatchSizeVisible() : false;
        bool maxTokensVisible = previousGenerator ? previousGenerator->maxTokensVisible() : false;
        bool repeatPenaltyTokensVisible = previousGenerator ? previousGenerator->repeatPenaltyTokensVisible() : false;
        bool contextLengthVisible = previousGenerator ? previousGenerator->contextLengthVisible() : false;
        bool numberOfGPULayersVisible = previousGenerator ? previousGenerator->numberOfGPULayersVisible() : false;

        switch (newCurrentProgramLanguage->id()) {
        case 0:
            newGenerator = new CurlCodeGenerator(modelName, port, stream, promptTemplate, systemPrompt, temperature,
                                                 topK, topP, minP, repeatPenalty, promptBatchSize,
                                                 maxTokens, repeatPenaltyTokens, contextLength, numberOfGPULayers,
                                                topKVisible, topPVisible, minPVisible, repeatPenaltyVisible,
                                                promptBatchSizeVisible, maxTokensVisible, repeatPenaltyTokensVisible,
                                                contextLengthVisible, numberOfGPULayersVisible);
            break;
        case 1:
            newGenerator = new PythonRequestsCodeGenerator(modelName, port, stream, promptTemplate, systemPrompt, temperature,
                                                           topK, topP, minP, repeatPenalty, promptBatchSize,
                                                           maxTokens, repeatPenaltyTokens, contextLength, numberOfGPULayers,
                                                           topKVisible, topPVisible, minPVisible, repeatPenaltyVisible,
                                                           promptBatchSizeVisible, maxTokensVisible, repeatPenaltyTokensVisible,
                                                           contextLengthVisible, numberOfGPULayersVisible);
            break;
        case 2:
            newGenerator = new NodeJsAxiosCodeGenerator(modelName, port, stream, promptTemplate, systemPrompt, temperature,
                                                        topK, topP, minP, repeatPenalty, promptBatchSize,
                                                        maxTokens, repeatPenaltyTokens, contextLength, numberOfGPULayers,
                                                        topKVisible, topPVisible, minPVisible, repeatPenaltyVisible,
                                                        promptBatchSizeVisible, maxTokensVisible, repeatPenaltyTokensVisible,
                                                        contextLengthVisible, numberOfGPULayersVisible);
            break;
        case 3:
            newGenerator = new JavascriptFetchCodeGenerator(modelName, port, stream, promptTemplate, systemPrompt, temperature,
                                                            topK, topP, minP, repeatPenalty, promptBatchSize,
                                                            maxTokens, repeatPenaltyTokens, contextLength, numberOfGPULayers,
                                                            topKVisible, topPVisible, minPVisible, repeatPenaltyVisible,
                                                            promptBatchSizeVisible, maxTokensVisible, repeatPenaltyTokensVisible,
                                                            contextLengthVisible, numberOfGPULayersVisible);
            break;
        default:
            qCWarning(logDeveloper) << "UnsupportSocketed language ID:" << newCurrentProgramLanguage->id();
            break;
        }

        if (newGenerator != nullptr) {
            newCurrentProgramLanguage->setCodeGenerator(newGenerator);

            if (previousGenerator != nullptr) {
                delete previousGenerator;
            }

            qCInfo(logDeveloper) << "Code generator set for language:" << newCurrentProgramLanguage->name();
        }
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

bool CodeDeveloperList::isRunningAPI() const{return m_isRunningAPI;}
void CodeDeveloperList::setIsRunningAPI(bool newIsRunningAPI){
    if (m_isRunningAPI == newIsRunningAPI)
        return;
    m_isRunningAPI = newIsRunningAPI;
    if(m_isRunningAPI){

        quint16 portAPIArg = portAPI();
        if (!m_parserModel.value("portAPI").isEmpty())
            portAPIArg = m_parserModel.value("portAPI").toUShort();

        qCInfo(logDeveloper) << "Developer server starting on portAPI:" << portAPIArg;
        qCInfo(logDeveloperView) << "Server starting on port:" << portAPIArg;

        auto modelFactory = std::make_unique<ModelAPI>(SCHEME, HOST, portAPIArg);
        auto chatFactory = std::make_unique<ChatAPI>(SCHEME, HOST, portAPIArg);

        m_modelsApi = std::move(modelFactory);
        m_chatApi = std::move(chatFactory);

        addCrudRoutes("/api/models", m_modelsApi);
        addCrudRoutes("/api/chat", m_chatApi);

        if (!m_tcpServer->listen(QHostAddress::Any, portAPIArg) || !m_httpServer->bind(m_tcpServer.get())) {
            qCWarning(logDeveloper) << "Server failed to bind to portAPI:" << portAPIArg;
            return;
        }

        quint16 portAPIModel = m_tcpServer->serverPort();
        qCInfo(logDeveloper) << "HTTP Server running at portAPI:" << portAPIModel;

    }else if (m_httpServer) {
            m_tcpServer->close();
            qCInfo(logDeveloper) << "HTTP Server stopped.";
            qCInfo(logDeveloperView) << "HTTP Server stopped.";
    }
    emit isRunningAPIChanged();
}

quint16 CodeDeveloperList::portAPI() const{return m_portAPI;}
void CodeDeveloperList::setPortAPI(quint16 newPortAPI){
    if (m_portAPI == newPortAPI)
        return;
    m_portAPI = newPortAPI;
    getCurrentProgramLanguage()->getCodeGenerator()->setPort(m_portAPI);
    emit portAPIChanged();
}

bool CodeDeveloperList::isRunningSocket() const { return m_isRunningSocket; }
void CodeDeveloperList::setIsRunningSocket(bool newIsRunningSocket) {
    if (m_isRunningSocket == newIsRunningSocket)
        return;
    m_isRunningSocket = newIsRunningSocket;
    if(m_isRunningSocket){

        m_parserChat.setApplicationDescription("Chat with Phoenix");
        m_parserChat.addHelpOption();

        QCommandLineOption dbgOption(QStringList() << "d" << "debug",
                                     QCoreApplication::translate("main", "Debug output [default: off]."));
        m_parserChat.addOption(dbgOption);


        QCommandLineOption portSocketOption(QStringList() << "p" << "portSocket",
                                            QCoreApplication::translate("main", "portSocket for ChatServer [default: 8080]."),
                                            QCoreApplication::translate("main", "portSocket"), QLatin1String(QString::number(static_cast<int>(portSocket())).toLatin1()));
        m_parserChat.addOption(portSocketOption);
        m_parserChat.process(*appSocket);
        bool debug = m_parserChat.isSet(dbgOption);
        quint16 portSocketChat = m_parserChat.value(portSocketOption).toInt();

        m_chatServer = new ChatServer(portSocketChat, debug);

        qCInfo(logDeveloper) << "WebSocket Server running at portSocket:" << portSocketChat;
        qCInfo(logDeveloperView) << "WebSocket Server running at port:" << portSocketChat;

        emit isRunningSocketChanged();

        qCInfo(logDeveloper) << "Developer server started successfully.";
    }else{
        if (m_chatServer) {
            m_chatServer->closeServer();
            delete m_chatServer;
            m_chatServer = nullptr;
        }
        qCInfo(logDeveloper) << "Stopped WebSocket Server.";
        qCInfo(logDeveloperView) << "Stopped WebSocket Server.";
    }
    emit isRunningSocketChanged();
    qCInfo(logDeveloper) << "Socket isRunning set to" << newIsRunningSocket;
}

quint16 CodeDeveloperList::portSocket() const { return m_portSocket; }
void CodeDeveloperList::setPortSocket(quint16 newportSocket) {
    if (m_portSocket == newportSocket)
        return;
    m_portSocket = newportSocket;
    emit portSocketChanged();
    qCInfo(logDeveloper) << "portSocket changed to " << m_portSocket;
}

void CodeDeveloperList::setCurrentLanguage(int newId) {
    qCDebug(logDeveloper) << "setCurrentLanguage called with ID:" << newId;
    for (int number = 0; number < m_programLanguags.size(); number++) {
        ProgramLanguage* programLanguage = m_programLanguags[number];
        if (programLanguage->id() == newId) {
            qCInfo(logDeveloper) << "Matching language found:" << programLanguage->name();
            setCurrentProgramLanguage(programLanguage);
            return;
        }
    }
    qCWarning(logDeveloper) << "Language ID not found:" << newId;
}

int CodeDeveloperList::modelId() const{return m_modelId;}
void CodeDeveloperList::setModelId(int newModelId){
    if (m_modelId == newModelId)
        return;
    m_modelId = newModelId;
    emit modelIdChanged();
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

QString CodeDeveloperList::modelSystemPrompt() const{ return m_modelSystemPrompt; }
void CodeDeveloperList::setModelSystemPrompt(const QString &newModelSystemPrompt){
    if (m_modelSystemPrompt == newModelSystemPrompt)
        return;
    m_modelSystemPrompt = newModelSystemPrompt;
    emit modelSystemPromptChanged();
}

QString CodeDeveloperList::modelPromptTemplate() const{ return m_modelPromptTemplate; }
void CodeDeveloperList::setModelPromptTemplate(const QString &newModelPromptTemplate){
    if (m_modelPromptTemplate == newModelPromptTemplate)
        return;
    m_modelPromptTemplate = newModelPromptTemplate;
    emit modelPromptTemplateChanged();
}

bool CodeDeveloperList::modelSelect() const{return m_modelSelect;}
void CodeDeveloperList::setModelSelect(bool newModelSelect){
    if (m_modelSelect == newModelSelect)
        return;
    m_modelSelect = newModelSelect;
    emit modelSelectChanged();
}
