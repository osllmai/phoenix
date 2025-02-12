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

void Database::insertModel(const QString &name, const QString &key, const BackendType backend){
    QSqlQuery query(m_db);

    if (!query.prepare(INSERT_MODEL_SQL))
        return;
    query.addBindValue(name);
    query.addBindValue(key);
    query.addBindValue(QDateTime::currentDateTime());
    query.addBindValue(false);
    query.exec();

    // parent = new Model(query.lastInsertId().toInt(), name, apikey, nullptr, false, BackendType::OnlineProvider,onlineModelList);

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
    INSERT INTO model(name, key, isLike) VALUES (?, ?, ?, ?)
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

void Database::readModel(const QList<Company*> companys){

    QList<OfflineModel*> tempOfflineModel;
    QList<OnlineModel*> tempOnlineModel;
    int i=0;

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

                OfflineModel *model = new OfflineModel(obj["filesize"].toDouble(), obj["ramrequired"].toInt(),
                                                       obj["filename"].toString(), obj["url"].toString(), obj["parameters"].toString(),
                                                       obj["quant"].toString(),0.0, false, false,

                                                       i++, obj["name"].toString(), "", QDateTime::currentDateTime(), true, company,
                                                       BackendType::OfflineModel,
                                                       company->icon(), obj["description"].toString(), obj["promptTemplate"].toString(),
                                                       obj["systemPrompt"].toString(), QDateTime::currentDateTime(), nullptr);

                tempOfflineModel.append(model);
            }
        }else{
            for (const QJsonValue &value : jsonArray) {
                if (!value.isObject()) continue;

                QJsonObject obj = value.toObject();

                OnlineModel *model = new OnlineModel(i++, obj["name"].toString(), "", QDateTime::currentDateTime(),
                                                    true, company, BackendType::OnlineModel, company->icon(),
                                                    obj["description"].toString(), obj["promptTemplate"].toString(),
                                                    obj["systemPrompt"].toString(), QDateTime::currentDateTime(), nullptr,

                                                     obj["type"].toString(), obj["inputPricePer1KTokens"].toDouble(),
                                                     obj["outputPricePer1KTokens"].toDouble(), obj["contextWindows"].toString(),
                                                     obj["recommended"].toBool(), obj["commercial"].toBool(),
                                                     obj["pricey"].toBool(), obj["output"].toString(), obj["comments"].toString(),
                                                     false);

                tempOnlineModel.append(model);
            }
        }
    }
    emit setOnlineModelList(tempOnlineModel);
    emit setOfflineModelList(tempOfflineModel);
}
