#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QVersionNumber>
#include <QTimer>
#include <QCoreApplication>
#include <QProcess>
#include <QFileInfo>

class UpdateChecker : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isUpdateAvailable READ isUpdateAvailable WRITE setIsUpdateAvailable NOTIFY isUpdateAvailableChanged FINAL)

public:
    static UpdateChecker* instance(QObject* parent);
    Q_INVOKABLE void checkForUpdatesAsync();
    Q_INVOKABLE bool checkForUpdates() const;

    bool isUpdateAvailable() const;
    void setIsUpdateAvailable(bool newIsUpdateAvailable);

signals:
    void isUpdateAvailableChanged();

private slots:
    void onReplyFinished(QNetworkReply *reply);

private:
    explicit UpdateChecker(QObject* parent = nullptr);
    static UpdateChecker* m_instance;

    QNetworkAccessManager *manager;
    const QString m_currentVersion = "0.1.2";
    const QString m_updateUrl = "https://raw.githubusercontent.com/osllmai/phoenix/master/release.json";

    bool m_isUpdateAvailable;

    bool isNewerVersion(const QString &newVersion);
};
