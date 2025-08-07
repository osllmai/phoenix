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
    // connect(manager, &QNetworkAccessManager::finished, this, &UpdateChecker::onUpdatesXmlFinished);
}

// void UpdateChecker::checkForUpdatesAsync() {
//     QNetworkRequest request(m_updateUrl);
//     manager->get(request);
// }

// void UpdateChecker::onReplyFinished(QNetworkReply *reply) {

//     qInfo() <<"         m_currentVersion: "<<m_currentVersion;

//     // setIsUpdateAvailable(true);

//     if (reply->error() != QNetworkReply::NoError) {
//         qWarning() << "Failed to check updates:" << reply->errorString();
//         reply->deleteLater();
//         return;
//     }

//     const QByteArray data = reply->readAll();
//     QJsonDocument doc = QJsonDocument::fromJson(data);
//     if (!doc.isArray()) {
//         qWarning() << "Invalid JSON format";
//         reply->deleteLater();
//         return;
//     }

//     QJsonArray releases = doc.array();
//     if (releases.isEmpty()) {
//         qWarning() << "No releases found";
//         reply->deleteLater();
//         return;
//     }

//     QJsonObject latest = releases.last().toObject();
//     setLatestVersion(latest.value("version").toString());
//     setNotes(latest.value("notes").toString());

//     if (isNewerVersion(getLatestVersion())) {
//         setIsUpdateAvailable(true);
//     } else {
//         setIsUpdateAvailable(false);
//     }

//     reply->deleteLater();
// }

bool UpdateChecker::isNewerVersion(const QString &newVersion) {
    qInfo()<<"newVersion: "<<newVersion<<"         m_currentVersion: "<<m_currentVersion;
    return QVersionNumber::fromString(newVersion) > QVersionNumber::fromString(m_currentVersion);
}

void UpdateChecker::checkForUpdatesAsync() {
    const QString updatesXmlUrl = "https://osllm-phoenix.s3.us-east-2.amazonaws.com/phoenix_windows/windows_64x/update/Updates.xml";

    QNetworkRequest request(updatesXmlUrl);
    QNetworkReply *reply = manager->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onUpdatesXmlFinished(reply);
    });
}

void UpdateChecker::onUpdatesXmlFinished(QNetworkReply *reply) {
    if (reply->error() != QNetworkReply::NoError) {
        qWarning() << "Failed to download Updates.xml:" << reply->errorString();
        reply->deleteLater();
        return;
    }

    const QByteArray data = reply->readAll();
    QDomDocument doc;
    qInfo() << "Received data:" << data;
    if (!doc.setContent(data)) {
        qWarning() << "Invalid XML format in Updates.xml";
        reply->deleteLater();
        return;
    }

    QDomNodeList versionNodes = doc.elementsByTagName("Version");
    if (versionNodes.isEmpty()) {
        qWarning() << "No <Version> tag found in Updates.xml";
        reply->deleteLater();
        return;
    }

    QString latestVersion = versionNodes.at(0).toElement().text();
    setLatestVersion(latestVersion);

    if (isNewerVersion(latestVersion)) {
        qInfo() << "Newer version found:" << latestVersion;
        fetchReleaseJson(latestVersion);
    } else {
        setIsUpdateAvailable(false);
    }

    reply->deleteLater();
}

void UpdateChecker::fetchReleaseJson(const QString &version) {
    const QString releaseJsonUrl = "https://raw.githubusercontent.com/osllmai/phoenix/master/release.json";

    QNetworkRequest request(releaseJsonUrl);
    QNetworkReply *reply = manager->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply, version]() {
        if (reply->error() != QNetworkReply::NoError) {
            qWarning() << "Failed to download release.json:" << reply->errorString();
            setIsUpdateAvailable(true);
            reply->deleteLater();
            return;
        }

        const QByteArray data = reply->readAll();
        qInfo() << "Received data:" << data;
        QJsonDocument jsonDoc = QJsonDocument::fromJson(data);
        if (!jsonDoc.isArray()) {
            qWarning() << "Invalid JSON format in release.json";
            setIsUpdateAvailable(true);
            reply->deleteLater();
            return;
        }

        QJsonArray releases = jsonDoc.array();
        bool found = false;
        for (const QJsonValue &val : releases) {
            QJsonObject obj = val.toObject();
            if (obj.value("version").toString() == version) {
                setNotes(obj.value("notes").toString());
                // setCommitHash(obj.value("commit").toString());
                // setCommitDate(obj.value("date").toString());
                found = true;
                break;
            }
        }

        setIsUpdateAvailable(true);
        if (!found) {
            qWarning() << "Version" << version << "not found in release.json details";
        }

        reply->deleteLater();
    });
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

QString UpdateChecker::currentVersion() const{return m_currentVersion;}

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
