#ifndef DOWNLOAD_H
#define DOWNLOAD_H

#include <QObject>
#include <QtQml>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QFile>
#include <QUrl>

class Download : public QObject
{
    Q_OBJECT

public:
    explicit Download(const int id, const QString &url, const QString &modelPath, QObject *parent = nullptr);
    void downloadModel();
    void cancelDownload();
    void removeModel();

    int id() const;

    virtual ~Download();

private slots:
    void onDownloadFinished();
    void handleDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);

signals:
    void downloadProgress(const int id, qint64 bytesReceived, qint64 bytesTotal);
    void downloadFinished(const int id);

private:
    int m_id;
    QThread downloadThread;
    QNetworkAccessManager m_manager;
    QNetworkReply *reply;
    QString url;
    QString modelPath;
};

#endif // DOWNLOAD_H
