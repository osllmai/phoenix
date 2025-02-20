#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QDateTime>
#include <QSqlError>
#include <QSqlQuery>
#include <QThread>

#include "./model/offline/offlinemodel.h"
#include "./model/online/onlinemodel.h"
#include "./model/BackendType.h"
#include "./model/company.h"

class Database: public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    static Database* instance(QObject* parent);

public slots:
    void readModel(const QList<Company*> companys);
    int insertModel(const QString &name, const QString &key);
    QSqlError deleteModel(const int id);
    QSqlError updateKeyModel(const int id, const QString &key);
    QSqlError updateIsLikeModel(const int id, const bool isLike);

    void readConversation();
    int insertConversation(const QString &title, const QString &description, const QDateTime date, const QString &icon,
                           const bool isPinned, const bool &stream, const QString &promptTemplate, const QString &systemPrompt,
                           const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                           const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                           const int &contextLength, const int &numberOfGPULayers);
    QSqlError deleteConversation(const int &id);
    QSqlError updateDateConversation(const int id, const QString &description, const QString &icon);
    QSqlError updateTitleConversation(const int id, const QString &title);
    QSqlError updateIsPinnedConversation(const int id, const bool &isPinned);
    QSqlError updateModelSettingsConversation(const int id, const bool &stream,
                            const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                            const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                            const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                            const int &contextLength, const int &numberOfGPULayers);

signals:
    void addOnlineModel(const int id, const QString& name, const QString& key, QDateTime addModelTime,
                        const bool isLike, Company* company, const BackendType backend,
                        const QString& icon , const QString& information , const QString& promptTemplate ,
                        const QString& systemPrompt, QDateTime expireModelTime,

                        const QString& type, const double inputPricePer1KTokens, const double outputPricePer1KTokens,
                        const QString& contextWindows, const bool recommended, const bool commercial, const bool pricey,
                        const QString& output, const QString& comments, const bool installModel);

    void addOfflineModel(const double fileSize, const int ramRamrequired, const QString& fileName, const QString& url,
                         const QString& parameters, const QString& quant, const double downloadPercent,
                         const bool isDownloading, const bool downloadFinished,

                         const int id, const QString& name, const QString& key, QDateTime addModelTime,
                         const bool isLike, Company* company, const BackendType backend,
                         const QString& icon , const QString& information , const QString& promptTemplate ,
                         const QString& systemPrompt, QDateTime expireModelTime);

    void addConversation(const int id, const QString &title, const QString &description, const QDateTime date, const QString &icon,
                           const bool isPinned, const bool &stream, const QString &promptTemplate, const QString &systemPrompt,
                           const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                           const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                           const int &contextLength, const int &numberOfGPULayers);

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

};

#endif // DATABASE_H
