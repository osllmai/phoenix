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

    QString sourceDb = QString::fromUtf8(APP_PATH) + "/db_phoenix.db";
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

        modelManager = new ModelManager(m_db, this);
        connect(modelManager, &ModelManager::addOnlineProvider, this, &Database::addOnlineProvider, Qt::QueuedConnection);
        connect(modelManager, &ModelManager::addOnlineProvider, this, &Database::addOnlineProvider, Qt::QueuedConnection);
        connect(modelManager, &ModelManager::addOfflineModel, this, &Database::addOfflineModel, Qt::QueuedConnection);
        connect(modelManager, &ModelManager::finishedReadOnlineModel, this, &Database::finishedReadOnlineModel, Qt::QueuedConnection);
        connect(modelManager, &ModelManager::finishedReadOfflineModel, this, &Database::finishedReadOfflineModel, Qt::QueuedConnection);
        connect(modelManager, &ModelManager::finishedAddModel, this, &Database::finishedAddModel, Qt::QueuedConnection);

        conversationManager = new ConversationManager(m_db, this);
        connect(conversationManager, &ConversationManager::addConversation, this, &Database::addConversation, Qt::QueuedConnection);
        connect(conversationManager, &ConversationManager::finishedReadConversation, this, &Database::finishedReadConversation, Qt::QueuedConnection);

        messageManager = new MessageManager(m_db, this);
        connect(messageManager, &MessageManager::addMessage, this, &Database::addMessage, Qt::QueuedConnection);

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

void Database::addModel(const QString &name, const QString &key){
    modelManager->addModel(name, key);
}

void Database::addHuggingfaceModel(const QString &name, const QString &url, const QString& type,
                                       const QString &companyName, const QString &companyIconPath, const QString &currentFolder) {
    modelManager->addHuggingfaceModel(name, url, type, companyName, companyIconPath, currentFolder);
}

void Database::deleteModel(const int id){
    modelManager->deleteModel(id);
}

void Database::updateKeyModel(const int id, const QString &key){
    modelManager->updateKeyModel(id, key);
}

void Database::updateIsLikeModel(const int id, const bool isLike){
    modelManager->updateIsLikeModel(id, isLike);
}

void Database::readModel(const QList<Company*> companys){
    modelManager->readModel(companys);
}

void Database::insertConversation(const QString &title, const QString &description, const QString &fileName, const QString &fileInfo,
                                  const QDateTime date, const QString &icon,
                                  const bool isPinned, const bool stream, const QString &promptTemplate, const QString &systemPrompt,
                                  const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                  const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                  const int &contextLength, const int &numberOfGPULayers, const bool selectConversation){

    conversationManager->insertConversation(
        title, description, fileName, fileInfo,
        date, icon,
        isPinned, stream, promptTemplate, systemPrompt,
        temperature, topK, topP, minP, repeatPenalty,
        promptBatchSize, maxTokens, repeatPenaltyTokens,
        contextLength, numberOfGPULayers, selectConversation
        );
}

void Database::deleteConversation(const int id){
    conversationManager->deleteConversation(id);
}

void Database::updateDateConversation(const int id, const QString &description, const QString &icon){
    conversationManager->updateDateConversation(id, description, icon);
}

void Database::updateTitleConversation(const int id, const QString &title){
    conversationManager->updateTitleConversation(id, title);
}

void Database::updateIsPinnedConversation(const int id, const bool isPinned){
    conversationManager->updateIsPinnedConversation(id, isPinned);
}

void Database::updateModelSettingsConversation(const int id, const bool stream,
                                               const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                                               const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                               const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                               const int &contextLength, const int &numberOfGPULayers){

    conversationManager->updateModelSettingsConversation(
        id, stream, promptTemplate, systemPrompt, temperature,
        topK, topP, minP, repeatPenalty,
        promptBatchSize, maxTokens, repeatPenaltyTokens,
        contextLength, numberOfGPULayers
        );
}

void Database::readConversation(){
    conversationManager->readConversation();
}

void Database::insertMessage(const int idConversation, const QString &text, const QString &fileName,
                             const QString &icon, bool isPrompt, const int like){
    messageManager->insertMessage(idConversation, text, fileName, icon, isPrompt, like);
}

void Database::updateLikeMessage(const int conversationId, const int messageId, const int like){
    messageManager->updateLikeMessage(conversationId, messageId, like);
}

void Database::updateTextMessage(const int conversationId, const int messageId, const QString &text){
    messageManager->updateTextMessage(conversationId, messageId, text);
}

void Database::readMessages(const int idConversation){
    messageManager->readMessages(idConversation);
}


const QString Database::FOREIGN_KEYS_SQL = QLatin1String(R"(
    PRAGMA foreign_keys = ON;
)");
