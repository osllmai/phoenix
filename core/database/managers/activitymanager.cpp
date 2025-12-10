#include "activitymanager.h"

ActivityManager::ActivityManager(QSqlDatabase db, QObject* parent)
    : QObject{parent}, m_db(db)
{
    if (m_db.isOpen()) {
        QSqlQuery query(m_db);

        QStringList tables = m_db.tables();
        if (!tables.contains("activity", Qt::CaseInsensitive)) {
            if (!query.exec(ACTIVITY_SQL)) {
                qDebug() << "Failed to create activity table:" << query.lastError().text();
            }
        }
    } else {
        qDebug() << "Failed to open ActivityManager:" << m_db.lastError().text();
    }
}

ActivityManager::~ActivityManager(){}

// ---------- SQL DEFINITIONS ----------
const QString ActivityManager::ACTIVITY_SQL = QLatin1String(R"(
    CREATE TABLE IF NOT EXISTS activity(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        conversation_id INTEGER NOT NULL,
        message_id INTEGER NOT NULL,
        text TEXT NOT NULL,
        icon TEXT NOT NULL,
        FOREIGN KEY(conversation_id) REFERENCES conversation(id) ON DELETE CASCADE,
        FOREIGN KEY(message_id) REFERENCES message(id)
    )
)");

const QString ActivityManager::READ_CONVERSATION_MESSAGE_ID_SQL = QLatin1String(R"(
    SELECT id, text, icon
    FROM activity
    WHERE conversation_id=? AND message_id=?
)");

const QString ActivityManager::INSERT_ACTIVITY_SQL = QLatin1String(R"(
    INSERT INTO activity(conversation_id, message_id, text, icon)
    VALUES (?, ?, ?, ?)
)");


// ---------- READ METHOD ----------
void ActivityManager::read(const int idConversation, const int idMessage)
{
    QSqlQuery query(m_db);
    query.prepare(READ_CONVERSATION_MESSAGE_ID_SQL);

    query.addBindValue(idConversation);
    query.addBindValue(idMessage);

    if (query.exec()) {
        while (query.next()) {
            int id = query.value(0).toInt();
            QString text = query.value(1).toString();
            QString icon = query.value(2).toString();

            emit add(id, idConversation, idMessage, text, icon);
        }
    } else {
        qDebug() << "READ activity error:" << query.lastError().text();
    }
}


// ---------- INSERT METHOD ----------
void ActivityManager::insert(const int idConversation,
                             const int idMessage,
                             const QString &text,
                             const QString &icon)
{
    QSqlQuery query(m_db);

    if (!query.prepare(INSERT_ACTIVITY_SQL)) {
        qDebug() << "Prepare INSERT failed:" << query.lastError().text();
        return;
    }

    query.addBindValue(idConversation);
    query.addBindValue(idMessage);
    query.addBindValue(text);
    query.addBindValue(icon);

    if (!query.exec()) {
        qDebug() << "INSERT activity error:" << query.lastError().text();
        return;
    }

    int id = query.lastInsertId().toInt();

    emit add(id, idConversation, idMessage, text, icon);
}
