#include "updatechecker.h"

UpdateChecker* UpdateChecker::m_instance = nullptr;

UpdateChecker* UpdateChecker::instance(QObject* parent){
    if (!m_instance) {
        m_instance = new UpdateChecker(parent);
    }
    return m_instance;
}

UpdateChecker::UpdateChecker(QObject *parent)
    : QObject(parent), m_isUpdateAvailable(false), manager(new QNetworkAccessManager(this)) {
}

bool UpdateChecker::isNewerVersion(const QString &newVersion) {
    return QVersionNumber::fromString(newVersion) > QVersionNumber::fromString(m_currentVersion);
}

void UpdateChecker::checkForUpdatesAsync() {

    QString updatesXmlUrl;
#if defined(Q_OS_LINUX)
    updatesXmlUrl = "https://osllm-phoenix.s3.us-east-2.amazonaws.com/phoenix_linux/update/Updates.xml";
#elif defined(Q_OS_WINDOWS)
    updatesXmlUrl = "https://osllm-phoenix.s3.us-east-2.amazonaws.com/phoenix_windows/windows_64x/update/Updates.xml";
#elif defined(Q_OS_MAC)
    updatesXmlUrl = "https://osllm-phoenix.s3.us-east-2.amazonaws.com/phoenix_mac/update/Updates.xml";
#endif

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
    if (!doc.setContent(data)) {
        qWarning() << "Invalid XML format in Updates.xml";
        reply->deleteLater();
        return;
    }

    // qDebug().noquote() << "Updates.xml content:\n" << data;

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
        setIsUpdateAvailable(true);
    } else {
        fetchReleaseJson(m_currentVersion);
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
            reply->deleteLater();
            return;
        }

        const QByteArray data = reply->readAll();
        QJsonDocument jsonDoc = QJsonDocument::fromJson(data);
        if (!jsonDoc.isArray()) {
            qWarning() << "Invalid JSON format in release.json";
            reply->deleteLater();
            return;
        }

        QJsonArray releases = jsonDoc.array();
        bool found = false;
        for (const QJsonValue &val : releases) {
            QJsonObject obj = val.toObject();
            if (obj.value("version").toString() == version) {
                QString title = obj.value("title").toString();
                QString date = obj.value("date").toString();
                QString notesLatestVersion = obj.value("notesLatestVersion").toString();

                QString featuresText;
                if (obj.contains("features") && obj.value("features").isArray()) {
                    QJsonArray features = obj.value("features").toArray();
                    if (!features.isEmpty()) {
                        featuresText = "Features:\n";
                        for (const QJsonValue &f : features) {
                            featuresText += "- " + f.toString() + "\n";
                        }
                    }
                }

                QString finalNotesLatestVersion = QString("%1 (v%2)\nRelease Date: %3\n%4%5")
                                         .arg(title, version, date, notesLatestVersion, featuresText);

                if (isNewerVersion(version)) {
                    setNotesLatestVersion(finalNotesLatestVersion.trimmed());
                } else {
                    setCurrentDate(date);
                    setNotesCurrentVersion(finalNotesLatestVersion.trimmed());
                }
                found = true;
                break;
            }
        }

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

    QString fileName = QString::fromUtf8(APP_PATH) + "/" + tool;
    if (!QFileInfo::exists(fileName)) {
        qDebug() << "Couldn't find tool at" << fileName << "so cannot check for updates!";
        return false;
    }

    return QProcess::startDetached(fileName);
}

QString UpdateChecker::currentVersion() const{return m_currentVersion;}

QString UpdateChecker::notesCurrentVersion() const{return m_notesCurrentVersion;}
void UpdateChecker::setNotesCurrentVersion(const QString &newNotesCurrentVersion){
    if (m_notesCurrentVersion == newNotesCurrentVersion)
        return;
    m_notesCurrentVersion = newNotesCurrentVersion;
    emit notesCurrentVersionChanged();
}

bool UpdateChecker::isUpdateAvailable() const{return m_isUpdateAvailable;}
void UpdateChecker::setIsUpdateAvailable(bool newIsUpdateAvailable){
    if (m_isUpdateAvailable == newIsUpdateAvailable)
        return;
    m_isUpdateAvailable = newIsUpdateAvailable;
    emit isUpdateAvailableChanged();
}

QString UpdateChecker::getNotesLatestVersion() const{return m_notesLatestVersion;}
void UpdateChecker::setNotesLatestVersion(const QString &newNotesLatestVersion){
    if (m_notesLatestVersion == newNotesLatestVersion)
        return;
    m_notesLatestVersion = newNotesLatestVersion;
    emit notesLatestVersionChanged();
}

QString UpdateChecker::getLatestVersion() const{return m_latestVersion;}
void UpdateChecker::setLatestVersion(const QString &newLatestVersion){
    if (m_latestVersion == newLatestVersion)
        return;
    m_latestVersion = newLatestVersion;
    emit latestVersionChanged();
}

QString UpdateChecker::currentDate() const{return m_currentDate;}
void UpdateChecker::setCurrentDate(const QString &newCurrentDate){
    if (m_currentDate == newCurrentDate)
        return;
    m_currentDate = newCurrentDate;
    emit currentDateChanged();
}
