#include "download.h"

Download::Download(int id, const QString &url, const QString &modelPath, QObject *parent)
    : QObject(parent), m_id(id), m_url(url), m_modelPath(modelPath)
{
}

Download::~Download() {
    if (m_reply) {
        m_reply->abort();
        m_reply->deleteLater();
    }
}

int Download::id() const {
    return m_id;
}

void Download::downloadModel() {
    if (m_reply) {
        m_reply->abort();
        m_reply->deleteLater();
        m_reply = nullptr;
    }

    QNetworkRequest request(m_url);
    m_reply = m_manager.get(request);
    m_reply->setProperty("modelPath", m_modelPath);

    connect(m_reply, &QNetworkReply::downloadProgress, this, &Download::handleDownloadProgress, Qt::QueuedConnection);
    connect(m_reply, &QNetworkReply::finished, this, &Download::onDownloadFinished, Qt::QueuedConnection);

    connect(m_reply, &QNetworkReply::errorOccurred, this, [=](QNetworkReply::NetworkError){
        emit downloadFailed(m_id, m_reply->errorString());
    });
}

void Download::cancelDownload() {
    if (m_reply) {
        m_reply->abort();
        m_reply->deleteLater();
        m_reply = nullptr;
    }
}

void Download::removeModel() {
    QFile file(m_modelPath);
    if (file.exists()) {
        file.remove();
    }
}

void Download::onDownloadFinished() {
    if (!m_reply)
        return;

    QString path = m_reply->property("modelPath").toString();
    QFile file(path);

    QFileInfo fi(file);
    QDir().mkpath(fi.path());

    if (m_reply->error() == QNetworkReply::NoError) {
        if (file.open(QIODevice::WriteOnly)) {
            qint64 written = file.write(m_reply->readAll());
            file.close();

            if (written > 0)
                emit downloadFinished(m_id);
            else
                emit downloadFailed(m_id, "Failed to write data to file");
        } else {
            emit downloadFailed(m_id, QStringLiteral("Cannot write to file: %1").arg(path));
        }
    } else {
        emit downloadFailed(m_id, m_reply->errorString());
    }

    m_reply->deleteLater();
    m_reply = nullptr;
}

void Download::handleDownloadProgress(qint64 bytesReceived, qint64 bytesTotal) {
    emit downloadProgress(m_id, bytesReceived, bytesTotal);
}
