#include "download.h"

Download::Download(
    int index, Model *model, const QString &url, const QString &modelPath, QObject *parent)
    : QObject{parent}
    , m_index{index}
    , m_model{model}
    , url{url}
    , modelPath{modelPath}
{
    moveToThread(&downloadThread);
    downloadThread.start();
    qInfo() << "new thread for download Model"<< m_index << " ::" << QThread::currentThread();
}

Download::~Download(){
    qInfo() << "delete thread for download Model" << m_index << " ::" << QThread::currentThread() ;
    delete reply;
    downloadThread.quit();
    downloadThread.wait();
}

void Download::downloadModel(){
    QNetworkRequest request(url);
    reply = m_manager.get(request);
    // Save the file path for when the download is complete
    reply->setProperty("modelPath", modelPath);
    connect(reply, &QNetworkReply::downloadProgress, this, &Download::handleDownloadProgress, Qt::QueuedConnection);
    connect(reply, &QNetworkReply::finished, this, &Download::onDownloadFinished, Qt::QueuedConnection);
}

void Download::cancelDownload(){
    // Disconnect the signals
    disconnect(reply, &QNetworkReply::downloadProgress, this, &Download::handleDownloadProgress);
    disconnect(reply, &QNetworkReply::finished, this, &Download::onDownloadFinished);
    reply->deleteLater(); // Schedule the reply for deletion
}

void Download::removeModel(){
    QFile file(modelPath);
    if (file.exists()){
        file.remove();
    }
}

void Download::onDownloadFinished() {
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (reply->error() == QNetworkReply::NoError) {
        QString modelPath = reply->property("modelPath").toString();
        QFile file(modelPath);
        if (file.open(QIODevice::WriteOnly)) {
            file.write(reply->readAll());
            file.close();
            qInfo()<<"download: "<<modelPath;
            emit downloadFinished(m_index, m_model);
        } else {
            qInfo() << "download: " << "Failed to save the file." << modelPath;
            // emit downloadFailed("Failed to save the file.");
        }
    } else {
        qInfo()<<"download: "<<reply->errorString();
        // emit downloadFailed(reply->errorString());
    }
    reply->deleteLater();
}

void Download::handleDownloadProgress(qint64 bytesReceived, qint64 bytesTotal){
    emit downloadProgress(m_index, m_model, bytesReceived, bytesTotal);
}

Model *Download::model() const
{
    return m_model;
}
