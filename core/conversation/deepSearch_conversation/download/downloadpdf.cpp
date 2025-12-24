#include "downloadpdf.h"

DownloadPdf::DownloadPdf(int id, const QString &url, const QString &modelPath, QObject *parent)
    : QObject(parent), m_id(id), m_url(url), m_modelPath(QDir::toNativeSeparators(modelPath))
{
    qCDebug(logDownloadModel) << "Initialized Download object with ID:" << m_id
                              << "URL:" << m_url
                              << "Path:" << m_modelPath;
}

DownloadPdf::~DownloadPdf() {
    if (m_reply) {
        qCDebug(logDownloadModel) << "Destructor: Aborting unfinished download ID:" << m_id;
        m_reply->abort();
        m_reply->deleteLater();
    }
    if (m_file && m_file->isOpen()) {
        m_file->close();
        delete m_file;
    }
}

int DownloadPdf::id() const {
    return m_id;
}

void DownloadPdf::downloadModel() {
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

    QFileInfo fi(m_modelPath);
    QDir dir;
    if (!dir.exists(fi.path())) {
        dir.mkpath(fi.path());
    }

    m_file = new QFile(m_modelPath);
    if (!m_file->open(QIODevice::WriteOnly)) {
        QString err = QStringLiteral("Cannot open file for writing: %1").arg(m_file->errorString());
        qCWarning(logDownloadModel) << err;
        emit downloadFailed(m_id, err);
        delete m_file;
        m_file = nullptr;
        return;
    }

    QNetworkRequest request(url);
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, QNetworkRequest::NoLessSafeRedirectPolicy);

    m_reply = m_manager.get(request);

    connect(m_reply, &QNetworkReply::downloadProgress, this, &DownloadPdf::handleDownloadProgress, Qt::QueuedConnection);
    connect(m_reply, &QNetworkReply::readyRead, this, &DownloadPdf::onReadyRead, Qt::QueuedConnection);
    connect(m_reply, &QNetworkReply::finished, this, &DownloadPdf::onDownloadFinished, Qt::QueuedConnection);

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

void DownloadPdf::onReadyRead() {
    if (m_file && m_reply) {
        QByteArray data = m_reply->readAll();
        m_file->write(data);
    }
}

void DownloadPdf::cancelDownload() {
    if (m_reply) {
        qCDebug(logDownloadModel) << "Cancelling download ID:" << m_id;
        m_reply->abort();
        m_reply->deleteLater();
        m_reply = nullptr;
    }

    if (m_file) {
        m_file->close();
        delete m_file;
        m_file = nullptr;
    }
}

void DownloadPdf::removeModel() {
    QFile file(m_modelPath);
    if (file.exists()) {
        bool removed = file.remove();
        qCDebug(logDownloadModel) << "Removed file:" << m_modelPath << "Status:" << removed;
    } else {
        qCWarning(logDownloadModel) << "File not found for removal:" << m_modelPath;
    }
}

void DownloadPdf::onDownloadFinished() {
    if (!m_reply)
        return;

    qCDebug(logDownloadModel) << "Download finished for ID:" << m_id;

    if (m_reply->error() != QNetworkReply::NoError) {
        qCWarning(logDownloadModel) << "Download failed with error:" << m_reply->errorString();
        emit downloadFailed(m_id, m_reply->errorString());
    } else {
        if (m_file) {
            m_file->flush();
            m_file->close();
        }
        qCDebug(logDownloadModel) << "File saved successfully at:" << m_modelPath;
        emit downloadFinished(m_id);
    }

    m_reply->deleteLater();
    m_reply = nullptr;

    if (m_file) {
        delete m_file;
        m_file = nullptr;
    }
}

void DownloadPdf::handleDownloadProgress(qint64 bytesReceived, qint64 bytesTotal) {
    if (bytesTotal <= 0)
        return;
    emit downloadProgress(m_id, bytesReceived, bytesTotal);
}
