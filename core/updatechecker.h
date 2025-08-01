#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QVersionNumber>
#include <QTimer>

class UpdateChecker : public QObject
{
    Q_OBJECT

public:
    explicit UpdateChecker(QObject *parent = nullptr);
    void checkForUpdatesAsync();

signals:
    void updateAvailable(const QString &latestVersion, const QString &notes);
    void noUpdateAvailable();

private slots:
    void onReplyFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *manager;
    const QString m_currentVersion = "0.1.2";
    const QString m_updateUrl = "https://raw.githubusercontent.com/osllmai/phoenix/master/release.json";

    bool isNewerVersion(const QString &newVersion);
};
