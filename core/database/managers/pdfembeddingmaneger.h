#ifndef PDFEMBEDDINGMANEGER_H
#define PDFEMBEDDINGMANEGER_H

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

class PdfEmbeddingManeger : public QObject
{
    Q_OBJECT
    QML_SINGLETON
public:
    explicit PdfEmbeddingManeger(QSqlDatabase db, QObject* parent = nullptr);
    virtual ~PdfEmbeddingManeger();

    void readMessages(const int idConversation);
    void insertMessage(const int idConversation, const QString &text, const QString &fileName, const QString &icon, bool isPrompt, const int like);
    void updateTextMessage(const int idConversation, const int messageId, const QString &text);
    void updateLikeMessage(const int conversationId, const int messageId, const int like);

signals:
    void addMessage(const int idConversation, const int id, const QString &text, const QString &fileName, QDateTime date, const QString &icon, bool isPrompt, const int like);

private:
    QSqlDatabase m_db;

    static const QString MESSAGE_SQL;
    static const QString INSERT_MESSAGE_SQL;
    static const QString READ_MESSAGE_ID_SQL;
    static const QString UPDATE_LIKE_MESSAGE_SQL;
    static const QString UPDATE_TEXT_MESSAGE_SQL;
    static const QString READ_ICON_MESSAGE_SQL;
    static const QString UPDATE_DATE_CONVERSATION_SQL;
    static const QString DELETE_MESSAGE_SQL;

    void updateDateConversation(const int id, const QString &description, const QString &icon);
};

#endif // PDFEMBEDDINGMANEGER_H
