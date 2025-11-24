#ifndef PDFMANAGER_H
#define PDFMANAGER_H

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

class PdfManager : public QObject
{
    Q_OBJECT
    QML_SINGLETON
public:
    explicit PdfManager(QSqlDatabase db, QObject* parent = nullptr);
    virtual ~PdfManager();

    void readConversation();
    void insertConversation(const QString &title, const QString &description, const QString &fileName, const QString &fileInfo,
                            const QDateTime date, const QString &icon,
                            const bool isPinned, const bool stream, const QString &promptTemplate, const QString &systemPrompt,
                            const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                            const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                            const int &contextLength, const int &numberOfGPULayers, const bool selectConversation);
    void deletePDF(const int id);

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

    static const QString PDF_SQL;
    static const QString INSERT_PDF_SQL;
    static const QString READ_PDF_SQL;
    static const QString DELETE_PDF_SQL;
};

#endif // PDFMANAGER_H
