#ifndef CONVERSATIONMANAGER_H
#define CONVERSATIONMANAGER_H

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

#include "messagemanager.h"

class ConversationManager : public QObject
{
    Q_OBJECT
    QML_SINGLETON
public:
    explicit ConversationManager(QSqlDatabase db, QObject* parent = nullptr);
    virtual ~ConversationManager();

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

signals:
    void addConversation(const int id, const QString &title, const QString &description, const QString &fileName, const QString &fileInfo,
                         const QDateTime date, const QString &icon,
                         const bool isPinned, const bool stream, const QString &promptTemplate, const QString &systemPrompt,
                         const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                         const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                         const int &contextLength, const int &numberOfGPULayers, const bool selectConversation);
    void finishedReadConversation();

private:
    QSqlDatabase m_db;

    static const QString CONVERSATION_SQL;
    static const QString INSERT_CONVERSATION_SQL;
    static const QString READ_CONVERSATION_SQL;
    static const QString UPDATE_DATE_CONVERSATION_SQL;
    static const QString UPDATE_TITLE_CONVERSATION_SQL;
    static const QString UPDATE_ISPINNED_CONVERSATION_SQL;
    static const QString UPDATE_MODEL_SETTINGS_CONVERSATION_SQL;
    static const QString DELETE_CONVERSATION_SQL;
    static const QString DELETE_MESSAGE_SQL;
};

#endif // CONVERSATIONMANAGER_H
