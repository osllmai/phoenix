#include "sourcesmanager.h"

SourcesManager::SourcesManager(QSqlDatabase db, QObject* parent)
    : QObject{parent}, m_db(db)
{
    if (m_db.isOpen()) {
        QSqlQuery query(m_db);

        QStringList tables = m_db.tables();
        if (!tables.contains("source", Qt::CaseInsensitive)) {
            if (!query.exec(SOURCES_SQL)) {
                qDebug() << "Failed to create source table:" << query.lastError().text();
            }
        }
    } else {
        qDebug() << "Failed to open ModelManager:" << m_db.lastError().text();
    }
}

SourcesManager::~SourcesManager(){}

// ---------- SQL DEFINITIONS ----------
const QString SourcesManager::SOURCES_SQL = QLatin1String(R"(
    CREATE TABLE IF NOT EXISTS source(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        conversation_id INTEGER NOT NULL,
        message_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        text TEXT NOT NULL,
        icon TEXT NOT NULL,
        FOREIGN KEY(conversation_id) REFERENCES conversation(id) ON DELETE CASCADE,
        FOREIGN KEY(message_id) REFERENCES message(id)
    )
)");

const QString SourcesManager::READ_CONVERSATION_MESSAGE_ID_SQL = QLatin1String(R"(
    SELECT id, title, text, icon
    FROM source
    WHERE conversation_id=? AND message_id=?
)");

const QString SourcesManager::INSERT_SOURCES_SQL = QLatin1String(R"(
    INSERT INTO source(conversation_id, message_id, title, text, icon)
    VALUES (?, ?, ?, ?, ?)
)");


// ---------- READ METHOD ----------
void SourcesManager::read(const int idConversation, const int idMessage)
{
    QSqlQuery query(m_db);
    query.prepare(READ_CONVERSATION_MESSAGE_ID_SQL);

    query.addBindValue(idConversation);
    query.addBindValue(idMessage);

    if (query.exec()) {
        while (query.next()) {
            int id = query.value(0).toInt();
            QString title = query.value(1).toString();
            QString text = query.value(2).toString();
            QString icon = query.value(3).toString();

            emit add(id, idConversation, idMessage, title, text, icon);
        }
    } else {
        qDebug() << "READ source error:" << query.lastError().text();
    }
}


// ---------- INSERT METHOD ----------
void SourcesManager::insert(const int idConversation,
                            const int idMessage,
                            const QString &title,
                            const QString &text,
                            const QString &icon)
{
    QSqlQuery query(m_db);

    if (!query.prepare(INSERT_SOURCES_SQL)) {
        qDebug() << "Prepare INSERT failed:" << query.lastError().text();
        return;
    }

    query.addBindValue(idConversation);
    query.addBindValue(idMessage);
    query.addBindValue(title);
    query.addBindValue(text);
    query.addBindValue(icon);

    if (!query.exec()) {
        qDebug() << "INSERT source error:" << query.lastError().text();
        return;
    }

    int id = query.lastInsertId().toInt();

    emit add(id, idConversation, idMessage, title, text, icon);
}
