#include "modelmanager.h"

ModelManager::ModelManager(QSqlDatabase db, QObject* parent)
    : QObject{nullptr}, m_db(db)
{

    if (m_db.isOpen()) {
        QSqlQuery query(m_db);

        QStringList tables = m_db.tables();
        if (!tables.contains("model", Qt::CaseInsensitive)) {
            query.exec(MODEL_SQL);
        }
    } else {
        qDebug() << "Failed to open ModelManager:" << m_db.lastError().text();
    }
}

ModelManager::~ModelManager(){}

const QString ModelManager::MODEL_SQL = QLatin1String(R"(
    CREATE TABLE model(
        id INTEGER NOT NULL UNIQUE,
        name TEXT NOT NULL,
        key TEXT,
        add_model_time DATE,
        isLike BOOL NOT NULL,
        PRIMARY KEY(id AUTOINCREMENT)
    )
)");

const QString ModelManager::INSERT_MODEL_SQL = QLatin1String(R"(
    INSERT INTO model(name, key, add_model_time, isLike) VALUES (?, ?, ?, ?)
)");

const QString ModelManager::READALL_MODEL_SQL = QLatin1String(R"(
    SELECT id, name, key, add_model_time, isLike FROM model
)");

const QString ModelManager::READ_MODEL_SQL = QLatin1String(R"(
    SELECT id, name, key, add_model_time, isLike FROM model WHERE name=?
)");

const QString ModelManager::READ_MODEL_ID_SQL = QLatin1String(R"(
    SELECT id, name, key, add_model_time, isLike FROM model WHERE id=?
)");

const QString ModelManager::UPDATE_KEYMODEL_SQL = QLatin1String(R"(
    UPDATE model SET key=?, add_model_time=? WHERE id=?
)");

const QString ModelManager::UPDATE_ISLIKE_SQL = QLatin1String(R"(
    UPDATE model SET isLike=? WHERE id=?
)");

const QString ModelManager::DELETE_MODEL_SQL = QLatin1String(R"(
    DELETE FROM model WHERE id=?
)");

int ModelManager::insertModel(const QString &name, const QString &key){
    QSqlQuery query(m_db);

    query.prepare(INSERT_MODEL_SQL);
    query.addBindValue(name);
    query.addBindValue(key);
    query.addBindValue(QDateTime::currentDateTime());
    query.addBindValue(false);
    if (!query.exec()){
        return -1;
    }

    return query.lastInsertId().toInt();
}

void ModelManager::deleteModel(const int id){
    QSqlQuery query(m_db);

    if (!query.prepare(DELETE_MODEL_SQL))
        return;
    query.addBindValue(id);
    if (!query.exec())
        return;
}

void ModelManager::updateKeyModel(const int id, const QString &key){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_KEYMODEL_SQL))
        return ;
    query.addBindValue(key);
    query.addBindValue(QDateTime::currentDateTime());
    query.addBindValue(id);
    if (!query.exec())
        return;
}

void ModelManager::updateIsLikeModel(const int id, const bool isLike){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_ISLIKE_SQL))
        return ;
    query.addBindValue(isLike);
    query.addBindValue(id);
    if (!query.exec())
        return;
}
