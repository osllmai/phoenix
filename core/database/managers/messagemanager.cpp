#include "messagemanager.h"

MessageManager::MessageManager(QSqlDatabase db, QObject* parent)
    : QObject{nullptr}, m_db(db)
{

    if (m_db.isOpen()) {
        QSqlQuery query(m_db);

        QStringList tables = m_db.tables();
        if (!tables.contains("message", Qt::CaseInsensitive)) {
            query.exec(MESSAGE_SQL);
        }
    } else {
        qDebug() << "Failed to open ModelManager:" << m_db.lastError().text();
    }
}

MessageManager::~MessageManager(){}

const QString MessageManager::MESSAGE_SQL = QLatin1String(R"(
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

const QString MessageManager::READ_MESSAGE_ID_SQL = QLatin1String(R"(
    SELECT id, text, fileName, date, icon, isPrompt, like FROM message WHERE conversation_id=?
)");

const QString MessageManager::INSERT_MESSAGE_SQL = QLatin1String(R"(
    INSERT INTO message(conversation_id, text, fileName, date, icon, isPrompt, like) VALUES (?, ?, ?, ?, ?, ?, ?)
)");

const QString MessageManager::UPDATE_LIKE_MESSAGE_SQL = QLatin1String(R"(
    UPDATE message SET like=? Where conversation_id=? AND id=?
)");

const QString MessageManager::UPDATE_TEXT_MESSAGE_SQL = QLatin1String(R"(
    UPDATE message SET text=? Where conversation_id=? AND id=?
)");

const QString MessageManager::READ_ICON_MESSAGE_SQL = QLatin1String(R"(
    SELECT icon FROM message WHERE conversation_id=? AND id=?
)");

const QString MessageManager::UPDATE_DATE_CONVERSATION_SQL = QLatin1String(R"(
    UPDATE conversation SET description=?, icon=?, date=? WHERE id=?
)");

const QString MessageManager::DELETE_MESSAGE_SQL = QLatin1String(R"(
    DELETE FROM message WHERE conversation_id=?
)");

void MessageManager::insertMessage(const int idConversation, const QString &text, const QString &fileName, const QString &icon, bool isPrompt, const int like){
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

void MessageManager::updateLikeMessage(const int conversationId, const int messageId, const int like){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_LIKE_MESSAGE_SQL))
        return;
    query.addBindValue(like);
    query.addBindValue(conversationId);
    query.addBindValue(messageId);
    if (!query.exec())
        return;
}

void MessageManager::updateTextMessage(const int conversationId, const int messageId, const QString &text){
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

void MessageManager::readMessages(const int idConversation){
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

void MessageManager::updateDateConversation(const int id, const QString &description, const QString &icon){
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
