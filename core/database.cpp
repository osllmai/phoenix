#include "database.h"

#include <QCoreApplication>

Database::Database(QObject* parent)
    : QObject{nullptr}
{
    moveToThread(&m_dbThread);
    m_dbThread.setObjectName("database");
    m_dbThread.start();

    QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    QDir().mkpath(appDataPath);

    QString sourceDb = QCoreApplication::applicationDirPath() + "/db_phoenix.db";
    QString targetDb = appDataPath + "/db_phoenix.db";

    if (!QFile::exists(targetDb)) {
        QFile::copy(sourceDb, targetDb);
    }

    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName(targetDb);

    if (m_db.open()) {
        QSqlQuery query(m_db);

        if (!query.exec("PRAGMA key = 'Phoenix1234';")) {
            qDebug() << "Failed to set encryption key:" << query.lastError().text();
        }

        query.exec(FOREIGN_KEYS_SQL);

        QStringList tables = m_db.tables();
        if (!tables.contains("model", Qt::CaseInsensitive)) {
            query.exec(MODEL_SQL);
        }
        if (!tables.contains("conversation", Qt::CaseInsensitive)) {
            query.exec(CONVERSATION_SQL);
        }
        if (!tables.contains("message", Qt::CaseInsensitive)) {
            query.exec(MESSAGE_SQL);
        }
    } else {
        qDebug() << "Failed to open database:" << m_db.lastError().text();
    }
}

Database::~Database(){
    m_db.close();
    m_dbThread.quit();
    m_dbThread.wait();
}

Database* Database::m_instance = nullptr;

Database* Database::instance(QObject* parent){
    if (!m_instance) {
        m_instance = new Database(parent);
    }
    return m_instance;
}

int Database::insertModel(const QString &name, const QString &key){
    QSqlQuery query(m_db);

    query.prepare(INSERT_MODEL_SQL);
    query.addBindValue(name);
    query.addBindValue(key);
    query.addBindValue(QDateTime::currentDateTime());
    query.addBindValue(false);
    if (!query.exec())
        return -1;

    return query.lastInsertId().toInt();
}

void Database::addModel(const QString &name, const QString &key){
    int id = insertModel(name, key);
    if(id == -1)
        return;

    QSqlQuery query(m_db);
    query.prepare(READ_MODEL_ID_SQL);
    query.addBindValue(id);

    if (!query.exec())
        return;

    if (query.next()) {

        id = query.value(0).toInt();
        QString name = query.value(1).toString();
        QString key = query.value(2).toString();
        QDateTime addDate = query.value(3).toDateTime();
        bool isLike = query.value(4).toBool();

        QFileInfo fileInfo(key);
        double fileSize = (fileInfo.size()/10000000)*0.01;
        QString icon = "Phoenix.svg";
        QString information = "This model has been successfully added to the application by you.";
        int ramRequ;
        if(fileSize<0.6)
            ramRequ = 1;
        else if(fileSize <1.5)
            ramRequ = 2;
        else if(fileSize <3.0)
            ramRequ = 4;
        else if(fileSize <6.0)
            ramRequ = 8;
        else if(fileSize <10.0)
            ramRequ = 16;
        else
            ramRequ = 32;

        emit addOfflineModel(nullptr, fileSize, ramRequ, "", "", "- bilion", "q4_0",0.0, false, true,
                             id, name, name, key, addDate, isLike, "Text Generation", BackendType::OfflineModel,
                             icon, information, "","", QDateTime::currentDateTime(), false);

    }
}

void Database::deleteModel(const int id){
    QSqlQuery query(m_db);

    if (!query.prepare(DELETE_MODEL_SQL))
        return;
    query.addBindValue(id);
    if (!query.exec())
        return;
}

void Database::updateKeyModel(const int id, const QString &key){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_KEYMODEL_SQL))
        return ;
    query.addBindValue(key);
    query.addBindValue(QDateTime::currentDateTime());
    query.addBindValue(id);
    if (!query.exec())
        return;
}

void Database::updateIsLikeModel(const int id, const bool isLike){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_ISLIKE_SQL))
        return ;
    query.addBindValue(isLike);
    query.addBindValue(id);
    if (!query.exec())
        return;
}

void Database::insertConversation(const QString &title, const QString &description, const QString &fileName, const QString &fileInfo,
                                 const QDateTime date, const QString &icon,
                                 const bool isPinned, const bool stream, const QString &promptTemplate, const QString &systemPrompt,
                                 const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                 const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                 const int &contextLength, const int &numberOfGPULayers, const bool selectConversation){
    QSqlQuery query(m_db);

    if (!query.prepare(INSERT_CONVERSATION_SQL))
        return;
    query.addBindValue(title);
    query.addBindValue(description);
    query.addBindValue(date);
    query.addBindValue(icon);
    query.addBindValue(isPinned);
    query.addBindValue(stream);
    query.addBindValue(promptTemplate);
    query.addBindValue(systemPrompt);
    query.addBindValue(temperature);
    query.addBindValue(topK);
    query.addBindValue(topP);
    query.addBindValue(minP);
    query.addBindValue(repeatPenalty);
    query.addBindValue(promptBatchSize);
    query.addBindValue(maxTokens);
    query.addBindValue(repeatPenaltyTokens);
    query.addBindValue(contextLength);
    query.addBindValue(numberOfGPULayers);
    if (!query.exec())
        return;

    int id = query.lastInsertId().toInt();

    emit addConversation(id, title, description, fileName, fileInfo, date, icon, isPinned, stream, promptTemplate, systemPrompt, temperature, topK, topP, minP,
                         repeatPenalty, promptBatchSize, maxTokens, repeatPenaltyTokens, contextLength, numberOfGPULayers, selectConversation);
}

void Database::deleteConversation(const int id){
    QSqlQuery query(m_db);

    if (!query.prepare(DELETE_CONVERSATION_SQL))
        return;
    query.addBindValue(id);
    if (!query.exec())
        return;

    if (!query.prepare(DELETE_MESSAGE_SQL))
        return;
    query.addBindValue(id);
    if (!query.exec())
        return;
}

void Database::updateDateConversation(const int id, const QString &description, const QString &icon){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_DATE_CONVERSATION_SQL))
        return;

    query.addBindValue(description);
    query.addBindValue(icon);
    query.addBindValue(QDateTime::currentDateTime());
    query.addBindValue(id);
    if (!query.exec())
        return;
}

void Database::updateTitleConversation(const int id, const QString &title){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_TITLE_CONVERSATION_SQL))
        return;
    query.addBindValue(title);
    query.addBindValue(id);
    if (!query.exec())
        return;
}

void Database::updateIsPinnedConversation(const int id, const bool isPinned){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_ISPINNED_CONVERSATION_SQL))
        return;
    query.addBindValue(isPinned);
    query.addBindValue(id);
    if (!query.exec())
        return;
}

void Database::updateModelSettingsConversation(const int id, const bool stream,
                                                    const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                                                    const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                                    const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                                    const int &contextLength, const int &numberOfGPULayers){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_MODEL_SETTINGS_CONVERSATION_SQL)){
        qInfo()<<query.lastError().text();
        return;
    }
    query.addBindValue(stream);
    query.addBindValue(promptTemplate);
    query.addBindValue(systemPrompt);
    query.addBindValue(temperature);
    query.addBindValue(topK);
    query.addBindValue(topP);
    query.addBindValue(minP);
    query.addBindValue(repeatPenalty);
    query.addBindValue(promptBatchSize);
    query.addBindValue(maxTokens);
    query.addBindValue(repeatPenaltyTokens);
    query.addBindValue(contextLength);
    query.addBindValue(numberOfGPULayers);
    query.addBindValue(id);
    if (!query.exec()){
        qInfo()<<query.lastError().text();
        return;
    }
}

void Database::insertMessage(const int idConversation, const QString &text, const QString &fileName, const QString &icon, bool isPrompt, const int like){
    QDateTime date = QDateTime::currentDateTime();

    QSqlQuery query(m_db);

    if (!query.prepare(INSERT_MESSAGE_SQL))
        return;
    query.addBindValue(idConversation);
    query.addBindValue(text);
    query.addBindValue(fileName);
    query.addBindValue(date);
    query.addBindValue(icon);
    query.addBindValue(isPrompt);
    query.addBindValue(like);
    if (!query.exec())
        return;

    int id = query.lastInsertId().toInt();

    emit addMessage(idConversation, id, text, fileName, date, icon, isPrompt, like);

    updateDateConversation(idConversation, text, icon);
}

void Database::updateLikeMessage(const int conversationId, const int messageId, const int like){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_LIKE_MESSAGE_SQL))
        return;
    query.addBindValue(like);
    query.addBindValue(conversationId);
    query.addBindValue(messageId);
    if (!query.exec())
        return;
}

void Database::updateTextMessage(const int conversationId, const int messageId, const QString &text){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_TEXT_MESSAGE_SQL))
        return;

    query.addBindValue(text);
    query.addBindValue(conversationId);
    query.addBindValue(messageId);
    if (!query.exec())
        return;

    //Find icon for update Conversation in DB
    if (!query.prepare(READ_ICON_MESSAGE_SQL))
        return ;

    query.addBindValue(conversationId);
    query.addBindValue(messageId);

    if (!query.exec())
        return ;

    if (query.next())
        updateDateConversation(conversationId, text, query.value(0).toString());
}

const QString Database::MODEL_SQL = QLatin1String(R"(
    CREATE TABLE model(
        id INTEGER NOT NULL UNIQUE,
        name TEXT NOT NULL,
        key TEXT,
        add_model_time DATE,
        isLike BOOL NOT NULL,
        PRIMARY KEY(id AUTOINCREMENT)
    )
)");

const QString Database::FOREIGN_KEYS_SQL = QLatin1String(R"(
    PRAGMA foreign_keys = ON;
)");

const QString Database::INSERT_MODEL_SQL = QLatin1String(R"(
    INSERT INTO model(name, key, add_model_time, isLike) VALUES (?, ?, ?, ?)
)");

const QString Database::READALL_MODEL_SQL = QLatin1String(R"(
    SELECT id, name, key, add_model_time, isLike FROM model
)");

const QString Database::READ_MODEL_SQL = QLatin1String(R"(
    SELECT id, name, key, add_model_time, isLike FROM model WHERE name=?
)");

const QString Database::READ_MODEL_ID_SQL = QLatin1String(R"(
    SELECT id, name, key, add_model_time, isLike FROM model WHERE id=?
)");

const QString Database::UPDATE_KEYMODEL_SQL = QLatin1String(R"(
    UPDATE model SET key=?, add_model_time=? WHERE id=?
)");

const QString Database::UPDATE_ISLIKE_SQL = QLatin1String(R"(
    UPDATE model SET isLike=? WHERE id=?
)");

const QString Database::DELETE_MODEL_SQL = QLatin1String(R"(
    DELETE FROM model WHERE id=?
)");


const QString Database::CONVERSATION_SQL = QLatin1String(R"(
    CREATE TABLE conversation(
        id INTEGER NOT NULL UNIQUE,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date DATE NOT NULL,
        icon TEXT NOT NULL,
        isPinned BOOL NOT NULL,
        stream BOOL NOT NULL,
        promptTemplate TEXT NOT NULL,
        systemPrompt TEXT NOT NULL,
        temperature REAL NOT NULL,
        topK INTEGER NOT NULL,
        topP REAL NOT NULL,
        minP REAL NOT NULL,
        repeatPenalty REAL NOT NULL,
        promptBatchSize INTEGER NOT NULL,
        maxTokens INTEGER NOT NULL,
        repeatPenaltyTokens INTEGER NOT NULL,
        contextLength INTEGER NOT NULL,
        numberOfGPULayers INTEGER NOT NULL,
        PRIMARY KEY(id AUTOINCREMENT)
    )
)");

const QString Database::INSERT_CONVERSATION_SQL = QLatin1String(R"(
    INSERT INTO conversation(title, description, date, icon, isPinned, stream, promptTemplate,systemPrompt,
            temperature, topK, topP, minP, repeatPenalty,
            promptBatchSize, maxTokens, repeatPenaltyTokens,
            contextLength, numberOfGPULayers)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
)");

const QString Database::READ_CONVERSATION_SQL = QLatin1String(R"(
    SELECT id, title, description, date, icon, isPinned, stream, promptTemplate,systemPrompt,
                    temperature, topK, topP, minP, repeatPenalty,
                    promptBatchSize, maxTokens, repeatPenaltyTokens,
                    contextLength, numberOfGPULayers
    FROM conversation
    ORDER BY date ASC
)");

const QString Database::UPDATE_DATE_CONVERSATION_SQL = QLatin1String(R"(
    UPDATE conversation SET description=?, icon=?, date=? WHERE id=?
)");

const QString Database::UPDATE_TITLE_CONVERSATION_SQL = QLatin1String(R"(
    UPDATE conversation SET title=? Where id=?
)");

const QString Database::UPDATE_ISPINNED_CONVERSATION_SQL = QLatin1String(R"(
    UPDATE conversation SET isPinned=? Where id=?
)");

const QString Database::UPDATE_MODEL_SETTINGS_CONVERSATION_SQL = QLatin1String(R"(
    UPDATE conversation
    SET stream=?, promptTemplate=?, systemPrompt=?,
            temperature=?, topK=?, topP=?, minP=?, repeatPenalty=?,
            promptBatchSize=?, maxTokens=?, repeatPenaltyTokens=?,
            contextLength=?, numberOfGPULayers=?
    Where id=?
)");

const QString Database::DELETE_CONVERSATION_SQL = QLatin1String(R"(
    DELETE FROM conversation where id = ?
)");


const QString Database::MESSAGE_SQL = QLatin1String(R"(
    CREATE TABLE message(
            conversation_id INTEGER NOT NULL,
            id INTEGER NOT NULL UNIQUE,
            text TEXT,
            fileName TEXT,
            date DATE NOT NULL,
            icon TEXT NOT NULL,
            isPrompt BOOL NOT NULL,
            like INTEGER NOT NULL,
            PRIMARY KEY(id AUTOINCREMENT),
            foreign key(conversation_id) REFERENCES conversation(id) ON DELETE CASCADE
    )
)");

const QString Database::READ_MESSAGE_ID_SQL = QLatin1String(R"(
    SELECT id, text, fileName, date, icon, isPrompt, like FROM message WHERE conversation_id=?
)");

const QString Database::INSERT_MESSAGE_SQL = QLatin1String(R"(
    INSERT INTO message(conversation_id, text, fileName, date, icon, isPrompt, like) VALUES (?, ?, ?, ?, ?, ?, ?)
)");

const QString Database::DELETE_MESSAGE_SQL = QLatin1String(R"(
    DELETE FROM message WHERE conversation_id=?
)");

const QString Database::UPDATE_LIKE_MESSAGE_SQL = QLatin1String(R"(
    UPDATE message SET like=? Where conversation_id=? AND id=?
)");

const QString Database::UPDATE_TEXT_MESSAGE_SQL = QLatin1String(R"(
    UPDATE message SET text=? Where conversation_id=? AND id=?
)");

const QString Database::READ_ICON_MESSAGE_SQL = QLatin1String(R"(
    SELECT icon FROM message WHERE conversation_id=? AND id=?
)");

void Database::readModel(const QList<Company*> companys){

    QList<int> allID;

    for (Company* company : companys){

        QFile file(QCoreApplication::applicationDirPath() + "/models/" + company->filePath());

        if (!file.open(QIODevice::ReadOnly)) {
            qWarning() << "Cannot open JSON file!";
            continue;
        }

        QByteArray jsonData = file.readAll();
        file.close();

        QJsonParseError err;
        QJsonDocument document = QJsonDocument::fromJson(jsonData, &err);
        if (err.error != QJsonParseError::NoError) {
            qWarning() << "ERROR: Couldn't parse: " << jsonData << err.errorString();
            continue;
        }

        QJsonArray jsonArray = document.array();

        if(company->backend() == BackendType::OfflineModel){

            for (const QJsonValue &value : jsonArray) {

                if (!value.isObject()) continue;

                QJsonObject obj = value.toObject();

                int id;
                QString name = obj["name"].toString();
                QString key = "";
                QDateTime addDate = QDateTime::currentDateTime();
                bool isLike = false;

                QSqlQuery query(m_db);
                query.prepare(READ_MODEL_SQL);
                query.addBindValue(obj["name"].toString());

                if (!query.exec())
                    continue;

                bool downloadFinished = false;
                if (!query.next()) {
                    id = insertModel(obj["name"].toString(),"");
                }else{

                    id = query.value(0).toInt();
                    name = query.value(1).toString();
                    key = query.value(2).toString();
                    addDate = query.value(3).toDateTime();
                    isLike = query.value(4).toBool();
                    if(key != "")
                        downloadFinished = true;
                }

                if(id == -1)
                    continue;

                emit addOfflineModel(company, obj["filesize"].toDouble(), obj["ramrequired"].toInt(),
                                   obj["filename"].toString(), obj["url"].toString(), obj["parameters"].toString(),
                                   obj["quant"].toString(),0.0, false, downloadFinished,

                                   id, obj["modelName"].toString(), name, key, addDate, isLike,
                                   obj["type"].toString(), BackendType::OfflineModel,
                                   company->icon(), obj["description"].toString(), obj["promptTemplate"].toString(),
                                   obj["systemPrompt"].toString(), QDateTime::currentDateTime(), obj["recommended"].toBool() /*, nullptr*/);

                allID.append(id);
            }
        }
    }

    QList<int> existId = readOnlineCompany();
    allID.append(existId);

    emit finishedReadOnlineModel();

    QSqlQuery query(m_db);
    query.prepare(READALL_MODEL_SQL);

    if (query.exec()){
        while(query.next()) {
            bool findIndex = false;
            for(int id : allID){
                if(id == query.value(0).toInt()){
                    findIndex = true;
                    break;
                }
            }
            if(findIndex == false){

                int id = query.value(0).toInt();
                QString name = query.value(1).toString();
                QString key = query.value(2).toString();
                QDateTime addDate = query.value(3).toDateTime();
                bool isLike = query.value(4).toBool();

                QFile file(key);
                if (!file.exists()){
                    deleteModel(id);
                }else{
                    QFileInfo fileInfo(key);
                    QString icon = "Phoenix.svg";
                    QString information = "This model has been successfully added to the application by you.";
                    double fileSize = (fileInfo.size()/10000000)*0.01;
                    int ramRequ;
                    if(fileSize<0.6)
                        ramRequ = 1;
                    else if(fileSize <1.5)
                        ramRequ = 2;
                    else if(fileSize <3.0)
                        ramRequ = 4;
                    else if(fileSize <6.0)
                        ramRequ = 8;
                    else if(fileSize <10.0)
                        ramRequ = 16;
                    else
                        ramRequ = 32;

                    emit addOfflineModel(nullptr, fileSize, ramRequ, "", "", "- billion", "q4_0",0.0, false, true,
                                         id, name,  name, key, addDate, isLike, "Text Generation", BackendType::OfflineModel,
                                         icon, information, "","", QDateTime::currentDateTime(), false);
                }
            }
        }
    }

    emit finishedReadOfflineModel();
}

void Database::readConversation(){
    QSqlQuery query(m_db);
    query.prepare(READ_CONVERSATION_SQL);

    if (query.exec()){
        while(query.next()) {
            emit addConversation(
                    query.value(0).toInt(),
                    query.value(1).toString(),
                    query.value(2).toString(),
                    "",
                    "",
                    query.value(3).toDateTime(),
                    query.value(4).toString(),
                    query.value(5).toBool(),
                    query.value(6).toBool(),
                    query.value(7).toString(),
                    query.value(8).toString(),
                    query.value(9).toDouble(),
                    query.value(10).toInt(),
                    query.value(11).toDouble(),
                    query.value(12).toDouble(),
                    query.value(13).toDouble(),
                    query.value(14).toInt(),
                    query.value(15).toInt(),
                    query.value(16).toInt(),
                    query.value(17).toInt(),
                    query.value(18).toInt(),
                    false
            );
        }
    }
    emit finishedReadConversation();
}

void Database::readMessages(const int idConversation){
    QSqlQuery query(m_db);
    query.prepare(READ_MESSAGE_ID_SQL);

    query.addBindValue(idConversation);
    if (query.exec()){
         while(query.next()){
            emit addMessage(
                idConversation,
                query.value(0).toInt(),
                query.value(1).toString(),
                query.value(2).toString(),
                query.value(3).toDateTime(),
                query.value(4).toString(),
                query.value(5).toBool(),
                query.value(6).toInt()
                );
         }
    }
}

QList<int> Database::readOnlineCompany() {
    QList<int> allID;

    QFile file(QCoreApplication::applicationDirPath() + "/models/company.json");
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Cannot open JSON file!";
        return allID;
    }

    QByteArray jsonData = file.readAll();
    file.close();
    QJsonDocument doc = QJsonDocument::fromJson(jsonData);
    if (!doc.isArray()) {
        qWarning() << "Invalid JSON format!";
        return allID;
    }

    int i=0;
    QJsonArray jsonArray = doc.array();
    for (const QJsonValue &value : jsonArray){
        if (!value.isObject()) continue;
        QJsonObject obj = value.toObject();

        if (obj["type"].toString() == "OnlineModel"){
            int id;
            QString name = obj["name"].toString();
            QString key = "";
            QDateTime addDate = QDateTime::currentDateTime();
            bool isLike = false;

            QSqlQuery query(m_db);
            query.prepare(READ_MODEL_SQL);
            query.addBindValue(name);

            if (!query.exec())
                continue;

            bool installModel = false;

            if (!query.next()) {
                id = insertModel(name, key);
            }else{
                id = query.value(0).toInt();
                name = query.value(1).toString();
                key = query.value(2).toString();
                addDate = query.value(3).toDateTime();
                isLike = query.value(4).toBool();
                if(key != "")
                    installModel = true;
            }

            if(id == -1)
                continue;

            emit addOnlineProvider(id, name, obj["icon"].toString(), isLike, BackendType::OnlineModel, obj["file"].toString(), key);

            allID.append(id);
        }
    }
    return allID;
}
