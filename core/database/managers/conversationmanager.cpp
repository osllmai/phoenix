#include "conversationmanager.h"

ConversationManager::ConversationManager(QSqlDatabase db, QObject* parent)
    : QObject{nullptr}, m_db(db)
{
    if (m_db.isOpen()) {
        QSqlQuery query(m_db);

        QStringList tables = m_db.tables();
        if (!tables.contains("conversation", Qt::CaseInsensitive)) {
            query.exec(CONVERSATION_SQL);
        }
    } else {
        qDebug() << "Failed to open ModelManager:" << m_db.lastError().text();
    }
}

ConversationManager::~ConversationManager(){}

const QString ConversationManager::CONVERSATION_SQL = QLatin1String(R"(
    CREATE TABLE conversation(
        id INTEGER NOT NULL UNIQUE,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date DATE NOT NULL,
        icon TEXT NOT NULL,
        isPinned BOOL NOT NULL,
        type TEXT NOT NULL,
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

const QString ConversationManager::INSERT_CONVERSATION_SQL = QLatin1String(R"(
    INSERT INTO conversation(title, description, date, icon, isPinned, type, stream, promptTemplate,systemPrompt,
            temperature, topK, topP, minP, repeatPenalty,
            promptBatchSize, maxTokens, repeatPenaltyTokens,
            contextLength, numberOfGPULayers)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
)");

const QString ConversationManager::READ_CONVERSATION_SQL = QLatin1String(R"(
    SELECT id, title, description, date, icon, isPinned, type, stream, promptTemplate,systemPrompt,
                    temperature, topK, topP, minP, repeatPenalty,
                    promptBatchSize, maxTokens, repeatPenaltyTokens,
                    contextLength, numberOfGPULayers
    FROM conversation
    ORDER BY date ASC
)");

const QString ConversationManager::UPDATE_DATE_CONVERSATION_SQL = QLatin1String(R"(
    UPDATE conversation SET description=?, icon=?, date=? WHERE id=?
)");

const QString ConversationManager::UPDATE_TITLE_CONVERSATION_SQL = QLatin1String(R"(
    UPDATE conversation SET title=? Where id=?
)");

const QString ConversationManager::UPDATE_ISPINNED_CONVERSATION_SQL = QLatin1String(R"(
    UPDATE conversation SET isPinned=? Where id=?
)");

const QString ConversationManager::UPDATE_MODEL_SETTINGS_CONVERSATION_SQL = QLatin1String(R"(
    UPDATE conversation
    SET stream=?, promptTemplate=?, systemPrompt=?,
            temperature=?, topK=?, topP=?, minP=?, repeatPenalty=?,
            promptBatchSize=?, maxTokens=?, repeatPenaltyTokens=?,
            contextLength=?, numberOfGPULayers=?
    Where id=?
)");

const QString ConversationManager::DELETE_CONVERSATION_SQL = QLatin1String(R"(
    DELETE FROM conversation where id = ?
)");

void ConversationManager::insertConversation(const QString &title, const QString &description, const QString &fileName, const QString &fileInfo,
                                  const QDateTime date, const QString &icon, const bool isPinned, const QString &type, const bool stream,
                                  const QString &promptTemplate, const QString &systemPrompt,
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
    query.addBindValue(type);
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

    emit addConversation(id, title, description, fileName, fileInfo, date, icon, isPinned, type, stream, promptTemplate, systemPrompt, temperature, topK, topP, minP,
                         repeatPenalty, promptBatchSize, maxTokens, repeatPenaltyTokens, contextLength, numberOfGPULayers, selectConversation);
}

void ConversationManager::deleteConversation(const int id){
    QSqlQuery query(m_db);

    if (!query.prepare(DELETE_CONVERSATION_SQL))
        return;
    query.addBindValue(id);
    if (!query.exec())
        return;

    // if (!query.prepare(DELETE_MESSAGE_SQL))
    //     return;
    // query.addBindValue(id);
    // if (!query.exec())
    //     return;
}

void ConversationManager::updateDateConversation(const int id, const QString &description, const QString &icon){
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

void ConversationManager::updateTitleConversation(const int id, const QString &title){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_TITLE_CONVERSATION_SQL))
        return;
    query.addBindValue(title);
    query.addBindValue(id);
    if (!query.exec())
        return;
}

void ConversationManager::updateIsPinnedConversation(const int id, const bool isPinned){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_ISPINNED_CONVERSATION_SQL))
        return;
    query.addBindValue(isPinned);
    query.addBindValue(id);
    if (!query.exec())
        return;
}

void ConversationManager::updateModelSettingsConversation(const int id, const bool stream,
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

void ConversationManager::readConversation(){
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
                query.value(6).toString(),
                query.value(7).toBool(),
                query.value(8).toString(),
                query.value(9).toString(),
                query.value(10).toDouble(),
                query.value(11).toInt(),
                query.value(12).toDouble(),
                query.value(13).toDouble(),
                query.value(14).toDouble(),
                query.value(15).toInt(),
                query.value(16).toInt(),
                query.value(17).toInt(),
                query.value(18).toInt(),
                query.value(19).toInt(),
                false
                );
        }
    }
    emit finishedReadConversation();
}
