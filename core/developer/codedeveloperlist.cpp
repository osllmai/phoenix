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
    if (!m_httpServer || !apiOpt.has_value())
        return;

    auto &api = apiOpt.value();

    m_httpServer->route(QString("%1").arg(apiPath), QHttpServerRequest::Method::Get,
                        [&api](const QHttpServerRequest &request) {
                            return api->getFullList();
                        });

    m_httpServer->route(QString("%1/<arg>").arg(apiPath), QHttpServerRequest::Method::Get,
                        [&api](qint64 itemId) {
                            return api->getItem(itemId);
                        });

    m_httpServer->route(QString("%1").arg(apiPath), QHttpServerRequest::Method::Post,
                         [&api](const QHttpServerRequest &request) {
                             return api->postItem(request);
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
}

void CodeDeveloperList::start()
{
    app = QCoreApplication::instance();
    if (!app) {
        qWarning() << "QCoreApplication instance is null!";
        return;
    }

    m_parser.setApplicationDescription("Qt Developer Server");
    m_parser.addHelpOption();
    m_parser.addOptions({
        { "port", QCoreApplication::translate("main", "The port the server listens on."), "port" }
    });

    m_parser.process(*app);

    m_httpServer = new QHttpServer(this);

    quint16 portArg = PORT;
    if (!m_parser.value("port").isEmpty())
        portArg = m_parser.value("port").toUShort();

    m_httpServer->route("/", []() {
        return "Qt Colorpalette example server. Please see documentation for API description";
    });

    auto colorFactory = std::make_unique<ModelAPI>(SCHEME, HOST, portArg);
    auto userFactory = std::make_unique<ChatAPI>(SCHEME, HOST, portArg);

    m_modelsApi = std::move(colorFactory);
    m_chatApi = std::move(userFactory);

    addCrudRoutes("/api/models", m_modelsApi);
    addCrudRoutes("/api/chat", m_chatApi);

    m_tcpServer = std::make_unique<QTcpServer>();
    if (!m_tcpServer->listen(QHostAddress::Any, portArg) || !m_httpServer->bind(m_tcpServer.get())) {
        qWarning() << "Server failed to listen on port" << portArg;
        return;
    }

    quint16 port = m_tcpServer->serverPort();
    qDebug() << QString("Running on http://127.0.0.1:%1/ (Press CTRL+C to quit)").arg(port);

    emit portChanged();
    emit isRunningChanged();
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
    for (int number = 0; number < m_programLanguags.size(); number++) {
        ProgramLanguage* programLanguage = m_programLanguags[number];
        if (programLanguage->id() == newId) {
            setCurrentProgramLanguage(programLanguage);
            break;
        }
    }
}
