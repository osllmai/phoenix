#ifndef DOWNLOAD_H
#define DOWNLOAD_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QFile>
#include <QUrl>
#include <QFileInfo>
#include <QDir>
#include <QDebug>
#include <QLoggingCategory>
#include "logcategories.h"

class Download : public QObject
{
    Q_OBJECT

public:
    explicit Download(int id, const QString &url, const QString &modelPath, QObject *parent = nullptr);
    ~Download() override;

    void downloadModel();
    void onReadyRead();
    void cancelDownload();
    void removeModel();

    int id() const;

signals:
    void downloadProgress(int id, qint64 bytesReceived, qint64 bytesTotal);
    void downloadFinished(int id);
    void downloadFailed(int id, const QString &error);

private slots:
    void onDownloadFinished();
    void handleDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);

private:
    int m_id;
    QNetworkAccessManager m_manager;
    QNetworkReply *m_reply = nullptr;
    QFile *m_file = nullptr;
    QString m_url;
    QString m_modelPath;
};

#endif // DOWNLOAD_H
