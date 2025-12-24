#pragma once
#include <QObject>
#include <QJsonArray>
#include <QNetworkAccessManager>

class SemanticScholarSearchWorker : public QObject {
    Q_OBJECT

public:
    explicit SemanticScholarSearchWorker(QString keywordsJson, QObject *parent = nullptr);

signals:
    void searchFinished(QList<QVariantMap> results);

public slots:
    void process();

private:
    QList<QVariantMap> parseSemanticScholarJson(const QByteArray &data);

private:
    QString m_keywordsJson;
    QJsonArray m_keywords;
    QNetworkAccessManager *m_network;

    QList<QVariantMap> m_collectedResults;
    int m_totalRequests = 0;
    int m_completedRequests = 0;
};
