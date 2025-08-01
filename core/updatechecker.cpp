#include "UpdateChecker.h"

UpdateChecker::UpdateChecker(QObject *parent)
    : QObject(parent), manager(new QNetworkAccessManager(this)) {
    connect(manager, &QNetworkAccessManager::finished, this, &UpdateChecker::onReplyFinished);
}

void UpdateChecker::checkForUpdatesAsync() {
    QNetworkRequest request(m_updateUrl);
    manager->get(request);
}

void UpdateChecker::onReplyFinished(QNetworkReply *reply) {
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
    QString latestVersion = latest.value("version").toString();
    QString notes = latest.value("notes").toString();

    if (isNewerVersion(latestVersion)) {
        emit updateAvailable(latestVersion, notes);
    } else {
        emit noUpdateAvailable();
    }

    reply->deleteLater();
}

bool UpdateChecker::isNewerVersion(const QString &newVersion) {
    return QVersionNumber::fromString(newVersion) > QVersionNumber::fromString(m_currentVersion);
}
