#include "downloadmodel.h"

DownloadModel::DownloadModel(const QString &url, const QString &modelPath, QObject *parent)
    : QObject{parent}, m_url(url), m_modelPath(modelPath)
{
    qInfo()<<" ----------------------------SLDP";
    moveToThread(&m_downloadThread);
    // m_downloadThread.setObjectName("m_downloadThread");
    m_downloadThread.start();
    qInfo()<<"SDLF<D-----------------------";

    QNetworkRequest request(m_url);
    m_reply = m_manager.get(request);
    // Save the file path for when the download is complete
    m_reply->setProperty("modelPath", m_modelPath);
    connect(m_reply, &QNetworkReply::downloadProgress, this, &DownloadModel::handleDownloadProgress, Qt::QueuedConnection);
    connect(m_reply, &QNetworkReply::finished, this, &DownloadModel::handleDownloadFinished, Qt::QueuedConnection);
}

DownloadModel::~DownloadModel(){
    delete m_reply;
    m_downloadThread.quit();
    m_downloadThread.wait();
}

void DownloadModel::handleDownloadCancel(){
    // Disconnect the signals
    disconnect(m_reply, &QNetworkReply::downloadProgress, this, &DownloadModel::handleDownloadProgress);
    disconnect(m_reply, &QNetworkReply::finished, this, &DownloadModel::handleDownloadFinished);
    m_reply->deleteLater(); // Schedule the reply for deletion
}

void DownloadModel::handleDownloadFinished() {
    m_reply = qobject_cast<QNetworkReply *>(sender());
    if (m_reply->error() == QNetworkReply::NoError) {
        QFile file(m_modelPath);
        if (file.open(QIODevice::WriteOnly)) {
            file.write(m_reply->readAll());
            file.close();
        }
    }
    m_reply->deleteLater();
    setDownloadFinished(true);
}

void DownloadModel::handleDownloadProgress(qint64 bytesReceived, qint64 bytesTotal){
    setBytesReceived(bytesReceived);
    setBytesTotal(bytesTotal);
}

QString DownloadModel::modelPath() const{return m_modelPath;}

const qint64 DownloadModel::bytesReceived() const{return m_bytesReceived;}
void DownloadModel::setBytesReceived(const qint64 newBytesReceived){
    if (m_bytesReceived == newBytesReceived)
        return;
    m_bytesReceived = newBytesReceived;
    emit bytesReceivedChanged(m_bytesReceived);
}

const qint64 DownloadModel::bytesTotal() const{return m_bytesTotal;}
void DownloadModel::setBytesTotal(const qint64 newBytesTotal){
    if (m_bytesTotal == newBytesTotal)
        return;
    m_bytesTotal = newBytesTotal;
    emit bytesTotalChanged(m_bytesTotal);
}

const bool DownloadModel::downloadFinished() const{return m_downloadFinished;}
void DownloadModel::setDownloadFinished(const bool newDownloadFinished){
    if (m_downloadFinished == newDownloadFinished)
        return;
    m_downloadFinished = newDownloadFinished;
    emit downloadFinishedChanged();
}
