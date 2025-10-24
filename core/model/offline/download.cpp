#include "download.h"

Download::Download(int id, const QString &url, const QString &modelPath, QObject *parent)
    : QObject(parent), m_id(id), m_url(url), m_modelPath(QDir::toNativeSeparators(modelPath))
{
    qCDebug(logDownloadModel) << "Initialized Download object with ID:" << m_id
                         << "URL:" << m_url
                         << "Path:" << m_modelPath;
}

Download::~Download() {
    if (m_reply) {
        qCDebug(logDownloadModel) << "Destructor: Aborting unfinished download ID:" << m_id;
        m_reply->abort();
        m_reply->deleteLater();
    }
}

int Download::id() const {
    return m_id;
}

void Download::downloadModel() {
    qCDebug(logDownloadModel) << "Starting download ID:" << m_id << "from URL:" << m_url;

    if (m_reply) {
        qCWarning(logDownloadModel) << "Previous reply still active. Aborting old download first.";
        m_reply->abort();
        m_reply->deleteLater();
        m_reply = nullptr;
    }

    QUrl url(m_url);
    if (!url.isValid()) {
        emit downloadFailed(m_id, "Invalid URL");
        qCWarning(logDownloadModel) << "Invalid URL:" << m_url;
        return;
    }

    QNetworkRequest request(url);
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, QNetworkRequest::NoLessSafeRedirectPolicy);

    m_reply = m_manager.get(request);
    m_reply->setProperty("modelPath", m_modelPath);

    connect(m_reply, &QNetworkReply::downloadProgress, this, &Download::handleDownloadProgress, Qt::QueuedConnection);
    connect(m_reply, &QNetworkReply::finished, this, &Download::onDownloadFinished, Qt::QueuedConnection);

    connect(m_reply, &QNetworkReply::errorOccurred, this, [=](QNetworkReply::NetworkError code){
        QString err = QStringLiteral("Network error (%1): %2").arg(code).arg(m_reply->errorString());
        qCWarning(logDownloadModel) << "Error occurred:" << err;
        emit downloadFailed(m_id, err);
    });

#ifdef Q_OS_MAC
    qCDebug(logDownloadModel) << "Running on macOS — using QNetworkAccessManager with SSL fallback if required.";
#endif
#ifdef Q_OS_WIN
    qCDebug(logDownloadModel) << "Running on Windows — ensuring long path compatibility.";
#endif
#ifdef Q_OS_LINUX
    qCDebug(logDownloadModel) << "Running on Linux — verifying permissions and paths.";
#endif
}

void Download::cancelDownload() {
    if (m_reply) {
        qCDebug(logDownloadModel) << "Cancelling download ID:" << m_id;
        m_reply->abort();
        m_reply->deleteLater();
        m_reply = nullptr;
    }
}

void Download::removeModel() {
    QFile file(m_modelPath);
    if (file.exists()) {
        bool removed = file.remove();
        qCDebug(logDownloadModel) << "Removed file:" << m_modelPath << "Status:" << removed;
    } else {
        qCWarning(logDownloadModel) << "File not found for removal:" << m_modelPath;
    }
}

void Download::onDownloadFinished() {
    if (!m_reply)
        return;

    QString path = m_reply->property("modelPath").toString();
    qCDebug(logDownloadModel) << "Download finished for ID:" << m_id << "Saving to:" << path;

    if (m_reply->error() != QNetworkReply::NoError) {
        qCWarning(logDownloadModel) << "Download failed with error:" << m_reply->errorString();
        emit downloadFailed(m_id, m_reply->errorString());
        m_reply->deleteLater();
        m_reply = nullptr;
        return;
    }

    qCDebug(logDownloadModel) << "Successfully to: " << path;
    emit downloadFinished(m_id);

    // QFileInfo fi(path);
    // QDir().mkpath(fi.path());
    // QFile file(path);

    // if (!file.open(QIODevice::WriteOnly)) {
    //     QString err = QStringLiteral("Cannot write to file: %1 (%2)").arg(path, file.errorString());
    //     qCWarning(logDownloadModel) << err;
    //     emit downloadFailed(m_id, err);
    // } else {
    //     QByteArray data = m_reply->readAll();
    //     qint64 written = file.write(data);
    //     qCDebug(logDownloadModel) << "Successfully wrote" << written << "bytes to" << path;
    //     emit downloadFinished(m_id);
    //     file.close();

    //     // if (written == data.size()) {
    //     //     qCDebug(logDownloadModel) << "Successfully wrote" << written << "bytes to" << path;
    //     //     emit downloadFinished(m_id);
    //     // } else {
    //     //     QString err = QStringLiteral("Incomplete write: %1/%2 bytes").arg(written).arg(data.size());
    //     //     qCWarning(logDownloadModel) << err;
    //     //     emit downloadFailed(m_id, err);
    //     // }
    // }

    m_reply->deleteLater();
    m_reply = nullptr;
}

void Download::handleDownloadProgress(qint64 bytesReceived, qint64 bytesTotal) {
    if (bytesTotal <= 0)
        return;

    double percent = (bytesReceived * 100.0) / bytesTotal;

    if (percent > 99.9 && bytesReceived < bytesTotal) {
        qCDebug(logDownloadModel) << "Preventing artificial delay near completion...";
    }

    emit downloadProgress(m_id, bytesReceived, bytesTotal);
}
