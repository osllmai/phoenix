#include "database.h"

#include <QCoreApplication>

#include "database.h"
#include <QCoreApplication>
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QDebug>
#include <QSqlError>

Database::Database(QObject* parent)
    : QObject(parent)
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

    if (!m_db.open()) {
        qDebug() << "Failed to open database:" << m_db.lastError().text();
        return;
    }

    QSqlQuery query(m_db);

    // enable foreign keys BEFORE creating any tables
    if (!query.exec("PRAGMA foreign_keys = ON;")) {
        qDebug() << "Failed to enable FK:" << query.lastError().text();
    }

    // managers
    modelManager = new ModelManager(m_db, this);
    connect(modelManager, &ModelManager::addOnlineProvider, this, &Database::addOnlineProvider);
    connect(modelManager, &ModelManager::addOfflineModel, this, &Database::addOfflineModel);
    connect(modelManager, &ModelManager::finishedReadOnlineModel, this, &Database::finishedReadOnlineModel);
    connect(modelManager, &ModelManager::finishedReadOfflineModel, this, &Database::finishedReadOfflineModel);
    connect(modelManager, &ModelManager::finishedAddModel, this, &Database::finishedAddModel);

    conversationManager = new ConversationManager(m_db, this);
    connect(conversationManager, &ConversationManager::addConversation, this, &Database::addConversation);
    connect(conversationManager, &ConversationManager::finishedReadConversation, this, &Database::finishedReadConversation);

    messageManager = new MessageManager(m_db, this);
    connect(messageManager, &MessageManager::addMessage, this, &Database::addMessage);

    pdfManager = new PdfManager(m_db, this);
    connect(pdfManager, &PdfManager::addPdf, this, &Database::addPdf);
    connect(pdfManager, &PdfManager::finishedReadPdf, this, &Database::finishedReadPdf);

    pdfEmbeddingManeger = new PdfEmbeddingManeger(m_db, this);
    connect(pdfEmbeddingManeger, &PdfEmbeddingManeger::addPdfEmbedding, this, &Database::addPdfEmbedding);
    connect(pdfEmbeddingManeger, &PdfEmbeddingManeger::finishedReadPdfEmbedding, this, &Database::finishedReadPdfEmbedding);
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
                                  const QDateTime date, const QString &icon, const bool isPinned, const QString &type, const bool stream,
                                  const QString &promptTemplate, const QString &systemPrompt,
                                  const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                  const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                  const int &contextLength, const int &numberOfGPULayers, const bool selectConversation){

    conversationManager->insertConversation(
        title, description, fileName, fileInfo,
        date, icon,
        isPinned, type, stream, promptTemplate, systemPrompt,
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

void Database::readPdf(const int idConversation){
    pdfManager->readPdf(idConversation);
}

void Database::insertPdf(const int conversation_id, const QString &file_Path){
    pdfManager->insertPdf(conversation_id, file_Path);
}

void Database::readPdfEmbedding(const int idConversation){
    pdfEmbeddingManeger->readPdfEmbedding(idConversation);
}

void Database::insertPdfEmbedding(const int pdf_id, const QString &text, const QString &text_embedding){
    pdfEmbeddingManeger->insertPdfEmbedding(pdf_id, text, text_embedding);
}

const QString Database::FOREIGN_KEYS_SQL = QLatin1String(R"(
    PRAGMA foreign_keys = ON;
)");
