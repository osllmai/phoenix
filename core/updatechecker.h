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
#include <QDomDocument>
#include <QNetworkReply>

#include "config.h"

class UpdateChecker : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentVersion READ currentVersion CONSTANT FINAL)
    Q_PROPERTY(QString notesCurrentVersion READ notesCurrentVersion NOTIFY notesCurrentVersionChanged FINAL)
    Q_PROPERTY(bool isUpdateAvailable READ isUpdateAvailable NOTIFY isUpdateAvailableChanged FINAL)
    Q_PROPERTY(QString latestVersion READ getLatestVersion NOTIFY latestVersionChanged FINAL)
    Q_PROPERTY(QString notesLatestVersion READ getNotesLatestVersion NOTIFY notesLatestVersionChanged FINAL)

public:
    static UpdateChecker* instance(QObject* parent);
    Q_INVOKABLE void checkForUpdatesAsync();
    Q_INVOKABLE bool checkForUpdates() const;

    QString currentVersion() const;

    QString notesCurrentVersion() const;
    void setNotesCurrentVersion(const QString &newNotesCurrentVersion);

    bool isUpdateAvailable() const;
    void setIsUpdateAvailable(bool newIsUpdateAvailable);

    QString getLatestVersion() const;
    void setLatestVersion(const QString &newLatestVersion);

    QString getNotesLatestVersion() const;
    void setNotesLatestVersion(const QString &newNotesLatestVersion);

signals:
    void isUpdateAvailableChanged();
    void latestVersionChanged();
    void notesLatestVersionChanged();
    void notesCurrentVersionChanged();

private slots:
    void onUpdatesXmlFinished(QNetworkReply *reply);

private:
    explicit UpdateChecker(QObject* parent = nullptr);
    static UpdateChecker* m_instance;

    QNetworkAccessManager *manager;
    const QString m_currentVersion = APP_VERSION;
    QString m_notesCurrentVersion = "";
    const QString m_updateUrl = "https://raw.githubusercontent.com/osllmai/phoenix/master/release.json";
    QString m_latestVersion = APP_VERSION;
    QString m_notesLatestVersion = "";

    bool m_isUpdateAvailable;

    bool isNewerVersion(const QString &newVersion);
    void fetchReleaseJson(const QString &version);
};
