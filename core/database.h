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

#include "./model/offline/offlinemodel.h"
#include "./model/online/onlinemodel.h"
#include "./model/BackendType.h"
#include "./model/company.h"

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

    void readConversation();
    void insertConversation(const QString &title, const QString &description, const QString &fileName, const QString &fileInfo,
                           const QDateTime date, const QString &icon,
                           const bool isPinned, const bool stream, const QString &promptTemplate, const QString &systemPrompt,
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

signals:
    void addOnlineModel(const int id, const QString& modelName, const QString& name, const QString& key,
                        QDateTime addModelTime, const bool isLike, Company* company, const QString& type,
                        const BackendType backend,
                        const QString& icon , const QString& information , const QString& promptTemplate ,
                        const QString& systemPrompt, QDateTime expireModelTime, const bool recommended,

                        const double inputPricePer1KTokens, const double outputPricePer1KTokens,
                        const QString& contextWindows, const bool commercial, const bool pricey,
                        const QString& output, const QString& comments, const bool installModel);

    void addOfflineModel(const double fileSize, const int ramRamrequired, const QString& fileName, const QString& url,
                         const QString& parameters, const QString& quant, const double downloadPercent,
                         const bool isDownloading, const bool downloadFinished,

                         const int id, const QString& modelName, const QString& name, const QString& key, QDateTime addModelTime,
                         const bool isLike, Company* company, const QString& type, const BackendType backend,
                         const QString& icon , const QString& information , const QString& promptTemplate ,
                         const QString& systemPrompt, QDateTime expireModelTime, const bool recommended);

    void addConversation(const int id, const QString &title, const QString &description, const QString &fileName, const QString &fileInfo,
                           const QDateTime date, const QString &icon,
                           const bool isPinned, const bool stream, const QString &promptTemplate, const QString &systemPrompt,
                           const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                           const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                           const int &contextLength, const int &numberOfGPULayers, const bool selectConversation);

    void addMessage(const int idConversation, const int id, const QString &text, const QString &fileName, QDateTime date, const QString &icon, bool isPrompt, const int like);


private:
    static Database* m_instance;

    explicit Database(QObject* parent = nullptr);
    virtual ~Database();

    QSqlDatabase m_db;
    QThread m_dbThread;

    static const QString MODEL_SQL;
    static const QString FOREIGN_KEYS_SQL;
    static const QString INSERT_MODEL_SQL;
    static const QString READALL_MODEL_SQL;
    static const QString READ_MODEL_SQL;
    static const QString READ_MODEL_ID_SQL;
    static const QString UPDATE_KEYMODEL_SQL;
    static const QString UPDATE_ISLIKE_SQL;
    static const QString DELETE_MODEL_SQL;

    static const QString CONVERSATION_SQL;
    static const QString INSERT_CONVERSATION_SQL;
    static const QString READ_CONVERSATION_SQL;
    static const QString UPDATE_DATE_CONVERSATION_SQL;
    static const QString UPDATE_TITLE_CONVERSATION_SQL;
    static const QString UPDATE_ISPINNED_CONVERSATION_SQL;
    static const QString UPDATE_MODEL_SETTINGS_CONVERSATION_SQL;
    static const QString DELETE_CONVERSATION_SQL;

    static const QString MESSAGE_SQL;
    static const QString INSERT_MESSAGE_SQL;
    static const QString READ_MESSAGE_ID_SQL;
    static const QString DELETE_MESSAGE_SQL;
    static const QString UPDATE_LIKE_MESSAGE_SQL;
    static const QString UPDATE_TEXT_MESSAGE_SQL;
    static const QString READ_ICON_MESSAGE_SQL;

    int insertModel(const QString &name, const QString &key);
};

#endif // DATABASE_H
