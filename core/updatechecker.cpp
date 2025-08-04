#include "UpdateChecker.h"

UpdateChecker* UpdateChecker::m_instance = nullptr;

UpdateChecker* UpdateChecker::instance(QObject* parent){
    if (!m_instance) {
        m_instance = new UpdateChecker(parent);
    }
    return m_instance;
}

UpdateChecker::UpdateChecker(QObject *parent)
    : QObject(parent), m_isUpdateAvailable(false), manager(new QNetworkAccessManager(this)) {
    connect(manager, &QNetworkAccessManager::finished, this, &UpdateChecker::onReplyFinished);
}

void UpdateChecker::checkForUpdatesAsync() {
    QNetworkRequest request(m_updateUrl);
    manager->get(request);
}

void UpdateChecker::onReplyFinished(QNetworkReply *reply) {

    // setIsUpdateAvailable(true);

    if (reply->error() != QNetworkReply::NoError) {
        qWarning() << "Failed to check updates:" << reply->errorString();
        reply->deleteLater();
        return;
    }

    const QByteArray data = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (!doc.isArray()) {
        qWarning() << "Invalid JSON format";
        reply->deleteLater();
        return;
    }

    QJsonArray releases = doc.array();
    if (releases.isEmpty()) {
        qWarning() << "No releases found";
        reply->deleteLater();
        return;
    }

    QJsonObject latest = releases.last().toObject();
    setLatestVersion(latest.value("version").toString());
    setNotes(latest.value("notes").toString());

    if (isNewerVersion(getLatestVersion())) {
        setIsUpdateAvailable(true);
    } else {
        setIsUpdateAvailable(false);
    }

    reply->deleteLater();
}

bool UpdateChecker::isNewerVersion(const QString &newVersion) {
    return QVersionNumber::fromString(newVersion) > QVersionNumber::fromString(m_currentVersion);
}

bool UpdateChecker::checkForUpdates() const {
    QString tool;

#if defined(Q_OS_LINUX)
    tool = QStringLiteral("maintenancetool");
#elif defined(Q_OS_WINDOWS)
    tool = QStringLiteral("maintenancetool.exe");
#elif defined(Q_OS_DARWIN)
    tool = QStringLiteral("../../../maintenancetool.app/Contents/MacOS/maintenancetool");
#endif

    QString fileName = QCoreApplication::applicationDirPath() + "/" + tool;
    if (!QFileInfo::exists(fileName)) {
        qDebug() << "Couldn't find tool at" << fileName << "so cannot check for updates!";
        return false;
    }

    return QProcess::startDetached(fileName);
}

bool UpdateChecker::isUpdateAvailable() const{return m_isUpdateAvailable;}
void UpdateChecker::setIsUpdateAvailable(bool newIsUpdateAvailable){
    if (m_isUpdateAvailable == newIsUpdateAvailable)
        return;
    m_isUpdateAvailable = newIsUpdateAvailable;
    emit isUpdateAvailableChanged();
}

QString UpdateChecker::getNotes() const{return m_notes;}
void UpdateChecker::setNotes(const QString &newNotes){
    if (m_notes == newNotes)
        return;
    m_notes = newNotes;
    emit notesChanged();
}

QString UpdateChecker::getLatestVersion() const{return m_latestVersion;}
void UpdateChecker::setLatestVersion(const QString &newLatestVersion){
    if (m_latestVersion == newLatestVersion)
        return;
    m_latestVersion = newLatestVersion;
    emit latestVersionChanged();
}
