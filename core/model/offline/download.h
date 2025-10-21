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

class Download : public QObject
{
    Q_OBJECT

public:
    explicit Download(int id, const QString &url, const QString &modelPath, QObject *parent = nullptr);
    void downloadModel();
    void cancelDownload();
    void removeModel();

    int id() const;
    ~Download() override;

private slots:
    void onDownloadFinished();
    void handleDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);

signals:
    void downloadProgress(int id, qint64 bytesReceived, qint64 bytesTotal);
    void downloadFinished(int id);
    void downloadFailed(int id, const QString &error);

private:
    int m_id;
    QNetworkAccessManager m_manager;
    QNetworkReply *m_reply = nullptr;
    QString m_url;
    QString m_modelPath;
};

#endif // DOWNLOAD_H
