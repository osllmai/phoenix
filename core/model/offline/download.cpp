#include "download.h"

Download::Download(const int id, const QString &url, const QString &modelPath, QObject *parent)
    : QObject{parent}
{
    m_id =id;
    this->url = url;
    this->modelPath = modelPath;
}

Download::~Download(){
    delete reply;
}

int Download::id() const{
    return m_id;
}

void Download::downloadModel(){
    QNetworkRequest request(url);
    reply = m_manager.get(request);
    // Save the file path for when the download is complete
    reply->setProperty("modelPath", modelPath);
    connect(reply, &QNetworkReply::downloadProgress, this, &Download::handleDownloadProgress, Qt::QueuedConnection);
    connect(reply, &QNetworkReply::finished, this, &Download::onDownloadFinished, Qt::QueuedConnection);

    connect(reply, &QNetworkReply::errorOccurred, this, [=](QNetworkReply::NetworkError code){
        Q_UNUSED(code);
        emit downloadFailed(m_id, reply->errorString());
    });
}

void Download::cancelDownload(){
    // Disconnect the signals
    disconnect(reply, &QNetworkReply::downloadProgress, this, &Download::handleDownloadProgress);
    disconnect(reply, &QNetworkReply::finished, this, &Download::onDownloadFinished);

    reply->deleteLater();
}

void Download::removeModel(){
    QFile file(modelPath);
    if (file.exists()){
        file.remove();
    }
}

void Download::onDownloadFinished() {
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (!reply) return;

    if (reply->error() == QNetworkReply::NoError) {
        QString modelPath = reply->property("modelPath").toString();
        QFile file(modelPath);
        if (file.open(QIODevice::WriteOnly)) {
            qint64 written = file.write(reply->readAll());
            file.close();

            if (written <= 0)
                emit downloadFailed(m_id, "Failed to write data to file");
            else
                emit downloadFinished(m_id);

        } else {
            emit downloadFailed(m_id, QStringLiteral("Cannot write to file: %1").arg(modelPath));
        }
    } else {
        emit downloadFailed(m_id, reply->errorString());
    }
    reply->deleteLater();
    this->reply = nullptr;
}

void Download::handleDownloadProgress(qint64 bytesReceived, qint64 bytesTotal){
    emit downloadProgress(m_id, bytesReceived, bytesTotal);
}
