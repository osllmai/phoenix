#include "codedeveloperlist.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

#include <QCoreApplication>

CodeDeveloperList* CodeDeveloperList::m_instance = nullptr;

CodeDeveloperList* CodeDeveloperList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new CodeDeveloperList(parent);
    }
    return m_instance;
}

CodeDeveloperList::CodeDeveloperList(QObject *parent)
    : QAbstractListModel(parent), m_port(8080), m_isRuning(false)
{
    QList<QPair<int, QString>> languages = {
        {0, "Curl"},
        {1, "Python"},
        {2, "NodeJS"},
        {3, "JavaScript"}
    };

    for (const auto& lang : languages) {
        m_programLanguags.append(new ProgramLanguage(lang.first, lang.second, this));
    }
    m_currentProgramLanguage = m_programLanguags.first();
    m_currentProgramLanguage->setCodeGenerator(new CurlCodeGenerator());
}

bool CodeDeveloperList::isRuning() const{return m_isRuning;}
void CodeDeveloperList::setIsRuning(bool newIsRuning){
    if (m_isRuning == newIsRuning)
        return;
    m_isRuning = newIsRuning;
    emit isRuningChanged();
}

int CodeDeveloperList::port() const{return m_port;}
void CodeDeveloperList::setPort(int newPort){
    if (m_port == newPort)
        return;
    m_port = newPort;
    emit portChanged();
}

void CodeDeveloperList::setCurrentLanguage(int newId){
    for(int number=0; number< m_programLanguags.size(); number++){
        ProgramLanguage* programLanguage = m_programLanguags[number];
        if(programLanguage->id() == newId){
            setCurrentProgramLanguage(programLanguage);
        }
    }
}

void CodeDeveloperList::start() {
    if (m_isRuning)
        return;

    m_httpServer = new QHttpServer(this);

    auto createResponse = [](const QJsonObject &jsonObj) {
        QByteArray body = QJsonDocument(jsonObj).toJson();
        return QHttpServerResponse(body, "Hi dear How are you? ", QHttpServerResponse::StatusCode::Ok);
    };


    m_httpServer->route("/models/", QHttpServerRequest::Method::Get, [this, createResponse]() {
        QJsonArray modelsArray;
        for (const auto& lang : m_programLanguags) {
            QJsonObject obj;
            obj["id"] = lang->id();
            obj["name"] = lang->name();
            modelsArray.append(obj);
        }
        return createResponse(QJsonObject{{"models", modelsArray}});
    });

    m_httpServer->route("/models/", QHttpServerRequest::Method::Post, [createResponse]() {
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
            return createResponse(QJsonObject{{"error", "Invalid JSON format."}});
        }

        QJsonObject jsonObj = jsonDoc.object();

        QString model = jsonObj.value("model").toString();
        QJsonArray messages = jsonObj.value("messages").toArray();
        double temperature = jsonObj.value("temperature").toDouble(0.7);
        int maxTokens = jsonObj.value("max_tokens").toInt(-1);
        bool stream = jsonObj.value("stream").toBool(false);

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
        qWarning() << "Failed to bind HTTP server to port" << m_port;
        return;
    }

    setIsRuning(true);
    qInfo() << "HTTP server is running on port" << m_port;
}

ProgramLanguage *CodeDeveloperList::getCurrentProgramLanguage() const{return m_currentProgramLanguage;}
void CodeDeveloperList::setCurrentProgramLanguage(ProgramLanguage *newCurrentProgramLanguage){
    if (m_currentProgramLanguage == newCurrentProgramLanguage)
        return;

    if(m_currentProgramLanguage != nullptr)
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
            qWarning() << "Unsupported language ID:" << newCurrentProgramLanguage->id();
            break;
        }

        newCurrentProgramLanguage->setCodeGenerator(generator);
    }

    m_currentProgramLanguage = newCurrentProgramLanguage;
    emit currentProgramLanguageChanged();
}

int CodeDeveloperList::count() const{return m_programLanguags.count();}
int CodeDeveloperList::rowCount(const QModelIndex &parent) const{
    Q_UNUSED(parent);
    return m_programLanguags.count();
}

QVariant CodeDeveloperList::data(const QModelIndex &index, int role) const{
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

QHash<int, QByteArray> CodeDeveloperList::roleNames() const{
    QHash<int, QByteArray> roles;
    roles[IDRole] = "id";
    roles[NameRole] = "name";
    return roles;
}
