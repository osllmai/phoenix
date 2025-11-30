#pragma once
#include <QObject>
#include <QString>
#include <QNetworkAccessManager>
#include <QJsonArray>
#include <QVariantMap>

class ArxivSearchWorker : public QObject {
    Q_OBJECT

public:
    explicit ArxivSearchWorker(QString keywordsJson, QObject *parent = nullptr);

signals:
    void searchFinished(QList<QVariantMap> results);

public slots:
    void process();

private:
    // Original input JSON
    QString m_keywordsJson;

    // Parsed keyword array (for async processing)
    QJsonArray m_keywords;

    // Network handler for all async API requests
    QNetworkAccessManager *m_network;

    // To accumulate all search results
    QList<QVariantMap> m_collectedResults;

    // To track async completion count
    int m_totalRequests = 0;
    int m_completedRequests = 0;

    // XML parse helper
    QList<QVariantMap> parseArxivXml(
        const QByteArray &xmlData,
        const QString &fallbackTerm,
        const QString &category
        );
};
