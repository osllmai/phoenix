#ifndef DOWNLOADMODEL_H
#define DOWNLOADMODEL_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QFile>
#include <QUrl>
#include <QThread>

class DownloadModel : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString modelPath READ modelPath CONSTANT FINAL)
    Q_PROPERTY(bool downloadFinished READ downloadFinished WRITE setDownloadFinished NOTIFY downloadFinishedChanged FINAL)
    Q_PROPERTY(qint64 bytesTotal READ bytesTotal WRITE setBytesTotal NOTIFY bytesTotalChanged FINAL)
    Q_PROPERTY(qint64 bytesReceived READ bytesReceived WRITE setBytesReceived NOTIFY bytesReceivedChanged FINAL)

public:
    explicit DownloadModel(QObject* parent = nullptr) : QObject(parent) {}

    explicit DownloadModel(const QString &url, const QString &modelPath, QObject *parent);
    virtual ~DownloadModel();

    const bool downloadFinished() const;
    void setDownloadFinished(const bool newDownloadFinished);

    const qint64 bytesTotal() const;
    void setBytesTotal(const qint64 newBytesTotal);

    const qint64 bytesReceived() const;
    void setBytesReceived(const qint64 newBytesReceived);

    QString modelPath() const;

signals:
    void downloadFinishedChanged();
    void bytesReceivedChanged(qint64 bytesReceived);
    void bytesTotalChanged(qint64 bytesTotal);

public slots:
    void handleDownloadCancel();
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
