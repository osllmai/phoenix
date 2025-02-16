#include "downloadmodel.h"

DownloadModel::DownloadModel(const QString &url, const QString &modelPath, QObject *parent)
    : QObject{parent}, m_url(url), m_modelPath(modelPath)
{
    moveToThread(&m_downloadThread);
    m_downloadThread.setObjectName("m_downloadThread");
    m_downloadThread.start();
}

DownloadModel::~DownloadModel(){
    delete m_reply;
    m_downloadThread.quit();
    m_downloadThread.wait();
}

void DownloadModel::start(){
    QNetworkRequest request(m_url);
    m_reply = m_manager.get(request);
    // Save the file path for when the download is complete
    m_reply->setProperty("modelPath", m_modelPath);
    connect(m_reply, &QNetworkReply::downloadProgress, this, &DownloadModel::handleDownloadProgress, Qt::QueuedConnection);
    connect(m_reply, &QNetworkReply::finished, this, &DownloadModel::handleDownloadFinished, Qt::QueuedConnection);
}

void DownloadModel::cancel(){
    // Disconnect the signals
    disconnect(m_reply, &QNetworkReply::downloadProgress, this, &DownloadModel::handleDownloadProgress);
    disconnect(m_reply, &QNetworkReply::finished, this, &DownloadModel::handleDownloadFinished);
    m_reply->deleteLater(); // Schedule the reply for deletion
}

void DownloadModel::remove(){
    QFile file(m_modelPath);
    if (file.exists())
        file.remove();
}

void DownloadModel::handleDownloadFinished() {
    /*QNetworkReply **/m_reply = qobject_cast<QNetworkReply *>(sender());
    if (m_reply->error() == QNetworkReply::NoError) {
        m_modelPath = m_reply->property("modelPath").toString();
        QFile file(m_modelPath);
        if (file.open(QIODevice::WriteOnly)) {
            file.write(m_reply->readAll());
            file.close();
            qInfo()<<"download: "<<m_modelPath;
        } else {
            qInfo()<<"download: "<<"Failed to save the file.";
        }
    } else {
        qInfo()<<"download: "<<m_reply->errorString();
    }
    m_reply->deleteLater();
}

void DownloadModel::handleDownloadProgress(qint64 bytesReceived, qint64 bytesTotal){
    setBytesReceived(bytesReceived);
    setBytesTotal(bytesTotal);
}

const qint64 DownloadModel::bytesReceived() const{return m_bytesReceived;}
void DownloadModel::setBytesReceived(const qint64 newBytesReceived){
    if (m_bytesReceived == newBytesReceived)
        return;
    m_bytesReceived = newBytesReceived;
    emit bytesReceivedChanged();
}

const qint64 DownloadModel::bytesTotal() const{return m_bytesTotal;}
void DownloadModel::setBytesTotal(const qint64 newBytesTotal){
    if (m_bytesTotal == newBytesTotal)
        return;
    m_bytesTotal = newBytesTotal;
    emit bytesTotalChanged();
}

const bool DownloadModel::downloadFinished() const{return m_downloadFinished;}
void DownloadModel::setDownloadFinished(const bool newDownloadFinished){
    if (m_downloadFinished == newDownloadFinished)
        return;
    m_downloadFinished = newDownloadFinished;
    emit downloadFinishedChanged();
}
