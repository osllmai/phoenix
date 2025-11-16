#pragma once
#include <QObject>
#include <QList>
#include <QVariantMap>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QDomDocument>

class ArxivFetcher : public QObject
{
    Q_OBJECT
public:
    explicit ArxivFetcher(QObject *parent = nullptr);

    Q_INVOKABLE void fetch(const QString &query, int maxResults = 100);
    const QList<QVariantMap>& entries() const { return m_entries; }

signals:
    void finished();
    void errorOccurred(const QString &err);

private slots:
    void onReplyFinished(QNetworkReply* reply);

private:
    QNetworkAccessManager *m_manager;
    QList<QVariantMap> m_entries;
};
