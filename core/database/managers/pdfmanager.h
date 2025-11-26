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

    void readPdf(const int idConversation);
    void insertPdf(const int conversation_id, const QString &file_Path);

signals:
    void addPdf(const int conversation_id, const int id, const QString &file_Path);
    void finishedReadPdf();

private:
    QSqlDatabase m_db;

    static const QString PDF_SQL;
    static const QString INSERT_PDF_SQL;
    static const QString READ_PDF_SQL;
};

#endif // PDFMANAGER_H
