#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QQmlEngine>
#include <QDateTime>
#include <QSqlError>
#include <QSqlQuery>
#include <QThread>
#include <QStandardPaths>
#include <QFile>
#include <QJsonParseError>
#include <QFileInfo>
#include <QDir>
#include <QJsonArray>
#include <QJsonObject>

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>

#include "./model/offline/offlinemodel.h"
#include "./model/online/onlinemodel.h"
#include "./model/BackendType.h"
#include "./model/company.h"
#include "config.h"

#include "modelmanager.h"
#include "conversationmanager.h"
#include "messagemanager.h"
#include "pdfmanager.h"
#include "pdfembeddingmaneger.h"

class Database: public QObject
{
    Q_OBJECT
    QML_SINGLETON
public:
    static Database* instance(QObject* parent);

public slots:
    void readModel(const QList<Company*> companys);
    void deleteModel(const int id);
    void updateKeyModel(const int id, const QString &key);
    void updateIsLikeModel(const int id, const bool isLike);
    void addModel(const QString &name, const QString &key);
    void addHuggingfaceModel(const QString &name, const QString &url, const QString& type,
                             const QString &companyName, const QString &companyIcon, const QString &currentFolder);

    void readConversation();
    void insertConversation(const QString &title, const QString &description, const QString &fileName, const QString &fileInfo,
                            const QDateTime date, const QString &icon, const bool isPinned, const QString &type, const bool stream,
                            const QString &promptTemplate, const QString &systemPrompt,
                            const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                            const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                            const int &contextLength, const int &numberOfGPULayers, const bool selectConversation);
    void deleteConversation(const int id);
    void updateDateConversation(const int id, const QString &description, const QString &icon);
    void updateTitleConversation(const int id, const QString &title);
    void updateIsPinnedConversation(const int id, const bool isPinned);
    void updateModelSettingsConversation(const int id, const bool stream,
                                         const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                                         const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                         const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                         const int &contextLength, const int &numberOfGPULayers);

    void readMessages(const int idConversation);
    void insertMessage(const int idConversation, const QString &text, const QString &fileName, const QString &icon, bool isPrompt, const int like);
    void updateTextMessage(const int idConversation, const int messageId, const QString &text);
    void updateLikeMessage(const int conversationId, const int messageId, const int like);

    void readPdf(const int idConversation);
    void insertPdf(const int conversation_id, const QString &file_Path);

    void readPdfEmbedding(const int idConversation);
    void insertPdfEmbedding(const int pdf_id, const QString &text, const QString &text_embedding);

signals:
    void addOnlineProvider(const int id, const QString& name, const QString& icon, const bool isLike,
                           const BackendType backend, const QString& filePath, QString key);

    void addOfflineModel(Company* company, const double fileSize, const int ramRamrequired, const QString& fileName, const QString& url,
                         const QString& parameters, const QString& quant, const double downloadPercent,
                         const bool isDownloading, const bool downloadFinished,

                         const int id, const QString& modelName, const QString& name, const QString& key, QDateTime addModelTime,
                         const bool isLike, const QString& type, const BackendType backend,
                         const QString& icon , const QString& information , const QString& promptTemplate ,
                         const QString& systemPrompt, QDateTime expireModelTime, const bool recommended, const QString &currentFolder);

    void addConversation(const int id, const QString &title, const QString &description, const QString &fileName, const QString &fileInfo,
                         const QDateTime date, const QString &icon, const bool isPinned, const QString &type, const bool stream,
                         const QString &promptTemplate, const QString &systemPrompt,
                         const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                         const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                         const int &contextLength, const int &numberOfGPULayers, const bool selectConversation);

    void addMessage(const int idConversation, const int id, const QString &text, const QString &fileName, QDateTime date, const QString &icon, bool isPrompt, const int like);

    void finishedReadOnlineModel();
    void finishedReadOfflineModel();
    void finishedReadConversation();
    void finishedAddModel(const QString &fileName);

    void addPdf(const int conversation_id, const int id, const QString &file_Path);
    void finishedReadPdf();

    void addPdfEmbedding(const int pdf_id, const int id, const QString &text, const QString &text_embedding);
    void finishedReadPdfEmbedding();

private:
    static Database* m_instance;

    explicit Database(QObject* parent = nullptr);
    virtual ~Database();

    QSqlDatabase m_db;
    QThread m_dbThread;

    static const QString FOREIGN_KEYS_SQL;

    static const QString MODELSETTINGS_SQL;
    static const QString INSERT_MODELSETTINGS_SQL;
    static const QString READ_MODELSETTINGS_SQL;
    static const QString UPDATE_TITLE_MODELSETTINGS_SQL;
    static const QString UPDATE_ISPINNED_MODELSETTINGS_SQL;
    static const QString DELETE_MODELSETTINGS_SQL;

    ModelManager *modelManager;
    ConversationManager *conversationManager;
    MessageManager *messageManager;
    PdfManager *pdfManager;
    PdfEmbeddingManeger *pdfEmbeddingManeger;
};

#endif // DATABASE_H
