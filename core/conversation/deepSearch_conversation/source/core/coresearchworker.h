#pragma once
#include <QObject>
#include <QJsonArray>
#include <QNetworkAccessManager>

class CORESearchWorker : public QObject {
    Q_OBJECT

public:
    explicit CORESearchWorker(QString keywordsJson, QObject *parent = nullptr);

signals:
    void searchFinished(QList<QVariantMap> results);

public slots:
    void process();

private:
    QList<QVariantMap> parseCoreJson(const QByteArray &data);

private:
    QString m_keywordsJson;
    QJsonArray m_keywords;

    QNetworkAccessManager *m_network;
    QList<QVariantMap> m_collectedResults;

    int m_totalRequests = 0;
    int m_completedRequests = 0;
};
