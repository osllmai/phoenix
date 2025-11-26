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

    void readPdfEmbedding(const int idConversation);
    void insertPdfEmbedding(const int pdf_id, const QString &text, const QString &text_embedding);

signals:
    void addPdfEmbedding(const int pdf_id, const int id, const QString &text, const QString &text_embedding);
    void finishedReadPdfEmbedding();

private:
    QSqlDatabase m_db;

    static const QString PdfEmbedding_SQL;
    static const QString INSERT_PdfEmbedding_SQL;
    static const QString READ_PdfEmbedding_SQL;
};

#endif // PDFEMBEDDINGMANEGER_H
