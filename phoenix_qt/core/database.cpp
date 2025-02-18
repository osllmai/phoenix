#include "database.h"

Database::Database(QObject* parent): QObject{nullptr}{
    moveToThread(&m_dbThread);
    m_dbThread.setObjectName("database");
    m_dbThread.start();

    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName("./db_phoenix.db");
    if(m_db.open()){
        QSqlQuery query(m_db);
        query.exec(FOREIGN_KEYS_SQL);

        QStringList tables = m_db.tables();
        if (!tables.contains("model", Qt::CaseInsensitive)){
            query.exec(MODEL_SQL);
        }
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
    query.exec();

    return query.lastInsertId().toInt();
}

QSqlError Database::deleteModel(const int id){
    QSqlQuery query(m_db);

    if (!query.prepare(DELETE_MODEL_SQL))
        return query.lastError();
    query.addBindValue(id);
    query.exec();
    return QSqlError();
}

QSqlError Database::updateKeyModel(const int id, const QString &key){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_ISLIKE_SQL))
        return query.lastError();
    query.addBindValue(key);
    query.addBindValue(QDateTime::currentDateTime());
    query.addBindValue(id);
    query.exec();
    return QSqlError();
}

QSqlError Database::updateIsLikeModel(const int id, const bool isLike){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_ISLIKE_SQL))
        return query.lastError();
    query.addBindValue(isLike);
    query.addBindValue(id);
    query.exec();
    return QSqlError();
}

int Database::insertConversation(const QString &title, const QDateTime date, const bool &stream,
                                         const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                                         const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                         const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                         const int &contextLength, const int &numberOfGPULayers){
    QSqlQuery query(db);

    if (!query.prepare(INSERT_CONVERSATION_SQL))
        return -1;
    query.addBindValue(title);
    query.addBindValue(date);
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
    query.exec();

    int id = query.lastInsertId().toInt();

    db.close();
    return id;
}

int Database::insertMessage(const QString &text, const bool isPrompt, const int numberOfTokens,
                                    const int executionTime, const Message *parent, const int &conversation_id,const QDateTime date){
    QSqlQuery query(db);

    if (!query.prepare(INSERT_MESSAGE_SQL))
        return -1;
    query.addBindValue(text);

    query.addBindValue(isPrompt);
    query.addBindValue(numberOfTokens);
    query.addBindValue(executionTime);

    if(parent->id() == -1)
        query.addBindValue(0);
    else
        query.addBindValue(parent->id());
    query.addBindValue(conversation_id);
    query.addBindValue(date);
    query.exec();

    int id = query.lastInsertId().toInt();
    qInfo()<<"insert message"<<id<<"  "<<conversation_id;

    db.close();
    return id;
}

QSqlError Database::deleteModel(const int &id){
    QSqlQuery query(db);

    if (!query.prepare(DELETE_MODEL_SQL))
        return query.lastError();
    query.addBindValue(id);
    query.exec();

    db.close();
    return QSqlError();
}

QSqlError Database::deleteConversation(const int &id){
    QSqlQuery query(db);

    if (!query.prepare(DELETE_CONVERSATION_SQL))
        return query.lastError();
    query.addBindValue(id);
    query.exec();

    if (!query.prepare(DELETE_MESSAGE_SQL))
        return query.lastError();
    query.addBindValue(id);
    query.exec();

    db.close();
    return QSqlError();
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
        date DATE NOT NULL,
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
    INSERT INTO conversation(title, date, stream, promptTemplate,systemPrompt,
            temperature, topK, topP, minP, repeatPenalty,
            promptBatchSize, maxTokens, repeatPenaltyTokens,
            contextLength, numberOfGPULayers)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
)");

const QString Database::READ_CONVERSATION_SQL = QLatin1String(R"(
    SELECT id, title, date, stream, promptTemplate,systemPrompt,
                    temperature, topK, topP, minP, repeatPenalty,
                    promptBatchSize, maxTokens, repeatPenaltyTokens,
                    contextLength, numberOfGPULayers
    FROM conversation
    ORDER BY date ASC
)");

const QString Database::UPDATE_DATE_CONVERSATION_SQL = QLatin1String(R"(
    UPDATE conversation SET date=? Where id=?
)");

const QString Database::UPDATE_TITLE_CONVERSATION_SQL = QLatin1String(R"(
    UPDATE conversation SET title=? Where id=?
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


void Database::readModel(const QList<Company*> companys){

    int i=0;
    QList<int> allID;

    for (Company* company : companys){

        QFile file("./bin/" + company->filePath());
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
                if(obj["type"].toString() != company->name()) continue;

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

                if (!query.next()) {

                    id = insertModel(obj["name"].toString(),"");

                    qDebug() << "ID:" << id << "Name:" << name << "Key:" << key
                             << "Time:" << addDate << "IsLike:" << isLike;
                }else{

                    id = query.value(0).toInt();
                    name = query.value(1).toString();
                    key = query.value(2).toString();
                    addDate = query.value(3).toDateTime();
                    isLike = query.value(4).toBool();
                }

                emit addOfflineModel(obj["filesize"].toDouble(), obj["ramrequired"].toInt(),
                                   obj["filename"].toString(), obj["url"].toString(), obj["parameters"].toString(),
                                   obj["quant"].toString(),0.0, false, false,

                                   id, name, key, addDate, isLike, company,
                                   BackendType::OfflineModel,
                                   company->icon(), obj["description"].toString(), obj["promptTemplate"].toString(),
                                   obj["systemPrompt"].toString(), QDateTime::currentDateTime()/*, nullptr*/);

                allID.append(id);
            }
        }else{
            for (const QJsonValue &value : jsonArray) {
                if (!value.isObject()) continue;

                QJsonObject obj = value.toObject();

                emit addOnlineModel(i++, obj["name"].toString(), "", QDateTime::currentDateTime(),
                                    true, company, BackendType::OnlineModel, company->icon(),
                                    obj["description"].toString(), obj["promptTemplate"].toString(),
                                    obj["systemPrompt"].toString(), QDateTime::currentDateTime(), /*nullptr,*/

                                     obj["type"].toString(), obj["inputPricePer1KTokens"].toDouble(),
                                     obj["outputPricePer1KTokens"].toDouble(), obj["contextWindows"].toString(),
                                     obj["recommended"].toBool(), obj["commercial"].toBool(),
                                     obj["pricey"].toBool(), obj["output"].toString(), obj["comments"].toString(),false);

            }
        }
    }

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
                }else
                    emit addOfflineModel(0.0, 0, "", "", "", "",0.0, false, false,
                             id, name, key, addDate, isLike, nullptr, BackendType::OfflineModel,
                             "", "", "","", QDateTime::currentDateTime());
            }
        }
    }
}
