#include "pdfmanager.h"



PdfManager::PdfManager(QSqlDatabase db, QObject* parent)
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

PdfManager::~PdfManager(){}

const QString PdfManager::CONVERSATION_SQL = QLatin1String(R"(
    CREATE TABLE pdf(
        conversation_id INTEGER NOT NULL,
        id INTEGER NOT NULL UNIQUE,
        file_Path TEXT NOT NULL,
        PRIMARY KEY(id AUTOINCREMENT)
    )
)");

const QString PdfManager::INSERT_CONVERSATION_SQL = QLatin1String(R"(
    INSERT INTO pdf(title, description, file_Path)
    VALUES (?, ?, ?)
)");

const QString PdfManager::READ_CONVERSATION_SQL = QLatin1String(R"(
    SELECT id, title, file_Path
    FROM pdf
    ORDER BY date ASC
)");

const QString PdfManager::DELETE_PDF_SQL = QLatin1String(R"(
    DELETE FROM message WHERE conversation_id=?
)");

void PdfManager::insertConversation(const QString &title, const QString &description, const QString &fileName, const QString &fileInfo,
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

void PdfManager::deleteConversation(const int id){
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

void PdfManager::updateDateConversation(const int id, const QString &description, const QString &icon){
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

void PdfManager::updateTitleConversation(const int id, const QString &title){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_TITLE_CONVERSATION_SQL))
        return;
    query.addBindValue(title);
    query.addBindValue(id);
    if (!query.exec())
        return;
}

void PdfManager::updateIsPinnedConversation(const int id, const bool isPinned){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_ISPINNED_CONVERSATION_SQL))
        return;
    query.addBindValue(isPinned);
    query.addBindValue(id);
    if (!query.exec())
        return;
}

void PdfManager::updateModelSettingsConversation(const int id, const bool stream,
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

void PdfManager::readConversation(){
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
