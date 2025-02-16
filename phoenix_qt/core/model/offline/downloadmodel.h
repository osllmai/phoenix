#ifndef DOWNLOADMODEL_H
#define DOWNLOADMODEL_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QFile>
#include <QUrl>
#include <QThread>

class DownloadModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool downloadFinished READ downloadFinished WRITE setDownloadFinished NOTIFY downloadFinishedChanged FINAL)
    Q_PROPERTY(qint64 bytesTotal READ bytesTotal WRITE setBytesTotal NOTIFY bytesTotalChanged FINAL)
    Q_PROPERTY(qint64 bytesReceived READ bytesReceived WRITE setBytesReceived NOTIFY bytesReceivedChanged FINAL)

public:
    explicit DownloadModel(const QString &url, const QString &modelPath, QObject *parent);
    virtual ~DownloadModel();
    void start();
    void cancel();
    void remove();

    const bool downloadFinished() const;
    void setDownloadFinished(const bool newDownloadFinished);

    const qint64 bytesTotal() const;
    void setBytesTotal(const qint64 newBytesTotal);

    const qint64 bytesReceived() const;
    void setBytesReceived(const qint64 newBytesReceived);

signals:
    void downloadFinishedChanged();
    void bytesTotalChanged();
    void bytesReceivedChanged();

private slots:
    void handleDownloadFinished();
    void handleDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);

private:
    QString m_url;
    QString m_modelPath;
    QThread m_downloadThread;
    QNetworkAccessManager m_manager;
    QNetworkReply *m_reply;
    qint64 m_bytesReceived;
    qint64 m_bytesTotal;
    bool m_downloadFinished;
};

#endif // DOWNLOADMODEL_H
