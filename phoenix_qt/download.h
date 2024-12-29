#ifndef DOWNLOAD_H
#define DOWNLOAD_H

#include <QObject>
#include <QtQml>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QFile>
#include <QUrl>

class Model;
class Download : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    Download(int index, Model *model, const QString &url, const QString &modelPath, QObject *parent = nullptr);

    void downloadModel();
    void cancelDownload();
    void removeModel();

    virtual ~Download();

    Model *model() const;

private slots:
    void onDownloadFinished();
    void handleDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);

signals:
    void downloadProgress(int index, Model *model, qint64 bytesReceived, qint64 bytesTotal);
    void downloadFinished(int index, Model *model);

private:
    int m_index;
    Model *m_model;
    QThread downloadThread;
    QNetworkAccessManager m_manager;
    QNetworkReply *reply;
    QString url;
    QString modelPath;
};

#endif // DOWNLOAD_H
