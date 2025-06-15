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
    m_port(8080),
    m_isRunning(false)
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

void CodeDeveloperList::addCrudRoutes(const QString &apiPath, std::optional<std::unique_ptr<CrudAPI>> &apiOpt)
{
    if (!m_httpServer || !apiOpt.has_value()) {
        qCWarning(logDeveloper) << "Failed to add routes for" << apiPath << ": Server or API not available.";
        return;
    }

    qCInfo(logDeveloper) << "Adding CRUD routes for path:" << apiPath;

    auto &api = apiOpt.value();

    m_httpServer->route(QString("%1").arg(apiPath), QHttpServerRequest::Method::Get,
                        [&api]() {
                            return api->getFullList();
                        });


    m_httpServer->route(QString("%1/<arg>").arg(apiPath), QHttpServerRequest::Method::Get,
                        [&api](qint64 itemId) {
                            return api->getItem(itemId);
                        });

    m_httpServer->route(QString("%1").arg(apiPath), QHttpServerRequest::Method::Post,
                        [&api](const QHttpServerRequest &request, QHttpServerResponder &responder) {
                            QSharedPointer<QHttpServerResponder> responderPtr = QSharedPointer<QHttpServerResponder>::create(std::move(responder));
                            api->postItem(request, responderPtr);
                        });

    m_httpServer->route(QString("%1/<arg>").arg(apiPath), QHttpServerRequest::Method::Put,
                        [&api](qint64 itemId, const QHttpServerRequest &request) {
                            return api->updateItem(itemId, request);
                        });

    m_httpServer->route(QString("%1/<arg>").arg(apiPath), QHttpServerRequest::Method::Patch,
                        [&api](qint64 itemId, const QHttpServerRequest &request) {
                            return api->updateItemFields(itemId, request);
                        });

    m_httpServer->route(QString("%1/<arg>").arg(apiPath), QHttpServerRequest::Method::Delete,
                        [&api](qint64 itemId, const QHttpServerRequest &request) {
                            return api->deleteItem(itemId);
                        });

    qCDebug(logDeveloper) << "CRUD routes added for" << apiPath;
}


void CodeDeveloperList::start()
{
    appModel = QCoreApplication::instance();
    if (!appModel) {
        qCWarning(logDeveloper) << "QCoreApplication instance is null!";
        return;
    }

    m_parserModel.setApplicationDescription("Qt Developer Server");
    m_parserModel.addHelpOption();
    m_parserModel.addOptions({
        { "port", QCoreApplication::translate("main", "The port the server listens on."), "port" }
    });

    m_parserModel.process(*appModel);

    m_httpServer = new QHttpServer(this);

    quint16 portArg = PORT;
    if (!m_parserModel.value("port").isEmpty())
        portArg = m_parserModel.value("port").toUShort();

    qCInfo(logDeveloper) << "Developer server starting on port:" << portArg;

    m_httpServer->route("/", []() {
        return "Qt Colorpalette example server. Please see documentation for API description";
    });

    auto modelFactory = std::make_unique<ModelAPI>(SCHEME, HOST, portArg);
    auto chatFactory = std::make_unique<ChatAPI>(SCHEME, HOST, portArg);

    m_modelsApi = std::move(modelFactory);
    m_chatApi = std::move(chatFactory);

    addCrudRoutes("/api/models", m_modelsApi);
    addCrudRoutes("/api/chat", m_chatApi);

    m_tcpServer = std::make_unique<QTcpServer>();
    if (!m_tcpServer->listen(QHostAddress::Any, portArg) || !m_httpServer->bind(m_tcpServer.get())) {
        qCWarning(logDeveloper) << "Server failed to bind to port:" << portArg;
        return;
    }

    quint16 portModel = m_tcpServer->serverPort();
    qCInfo(logDeveloper) << "HTTP Server running at port:" << portModel;


    appChat = QCoreApplication::instance();

    m_parserChat.setApplicationDescription("QtWebSockets example: ChatServer");
    m_parserChat.addHelpOption();

    QCommandLineOption dbgOption(QStringList() << "d" << "debug",
                                 QCoreApplication::translate("main", "Debug output [default: off]."));
    m_parserChat.addOption(dbgOption);

    QCommandLineOption portOption(QStringList() << "p" << "port",
                                  QCoreApplication::translate("main", "Port for ChatServer [default: 8080]."),
                                  QCoreApplication::translate("main", "port"), QLatin1String("8080"));
    m_parserChat.addOption(portOption);
    m_parserChat.process(*appChat);
    bool debug = m_parserChat.isSet(dbgOption);
    int portChat = m_parserChat.value(portOption).toInt();

    m_chatServer = new ChatServer(portChat, debug);
    QObject::connect(m_chatServer, &ChatServer::closed, appChat, &QCoreApplication::quit);

    qCInfo(logDeveloper) << "WebSocket Server running at port:" << portChat;

    emit portChanged();
    emit isRunningChanged();

    qCInfo(logDeveloper) << "Developer server started successfully.";
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
            newGenerator = new CurlCodeGenerator(stream, promptTemplate, systemPrompt, temperature,
                                                 topK, topP, minP, repeatPenalty, promptBatchSize,
                                                 maxTokens, repeatPenaltyTokens, contextLength, numberOfGPULayers,
                                                topKVisible, topPVisible, minPVisible, repeatPenaltyVisible,
                                                promptBatchSizeVisible, maxTokensVisible, repeatPenaltyTokensVisible,
                                                contextLengthVisible, numberOfGPULayersVisible);
            break;
        case 1:
            newGenerator = new PythonRequestsCodeGenerator(stream, promptTemplate, systemPrompt, temperature,
                                                           topK, topP, minP, repeatPenalty, promptBatchSize,
                                                           maxTokens, repeatPenaltyTokens, contextLength, numberOfGPULayers,
                                                           topKVisible, topPVisible, minPVisible, repeatPenaltyVisible,
                                                           promptBatchSizeVisible, maxTokensVisible, repeatPenaltyTokensVisible,
                                                           contextLengthVisible, numberOfGPULayersVisible);
            break;
        case 2:
            newGenerator = new NodeJsAxiosCodeGenerator(stream, promptTemplate, systemPrompt, temperature,
                                                        topK, topP, minP, repeatPenalty, promptBatchSize,
                                                        maxTokens, repeatPenaltyTokens, contextLength, numberOfGPULayers,
                                                        topKVisible, topPVisible, minPVisible, repeatPenaltyVisible,
                                                        promptBatchSizeVisible, maxTokensVisible, repeatPenaltyTokensVisible,
                                                        contextLengthVisible, numberOfGPULayersVisible);
            break;
        case 3:
            newGenerator = new JavascriptFetchCodeGenerator(stream, promptTemplate, systemPrompt, temperature,
                                                            topK, topP, minP, repeatPenalty, promptBatchSize,
                                                            maxTokens, repeatPenaltyTokens, contextLength, numberOfGPULayers,
                                                            topKVisible, topPVisible, minPVisible, repeatPenaltyVisible,
                                                            promptBatchSizeVisible, maxTokensVisible, repeatPenaltyTokensVisible,
                                                            contextLengthVisible, numberOfGPULayersVisible);
            break;
        default:
            qCWarning(logDeveloper) << "Unsupported language ID:" << newCurrentProgramLanguage->id();
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

bool CodeDeveloperList::isRunning() const { return m_isRunning; }
void CodeDeveloperList::setIsRunning(bool newIsRunning) {
    if (m_isRunning == newIsRunning)
        return;
    m_isRunning = newIsRunning;
    emit isRunningChanged();
    qCInfo(logDeveloper) << "isRunning set to" << newIsRunning;
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
