#include "SemanticScholarSearchWorker.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QDebug>

SemanticScholarSearchWorker::SemanticScholarSearchWorker(QString keywordsJson, QObject *parent)
    : QObject(parent), m_keywordsJson(keywordsJson)
{
    m_network = new QNetworkAccessManager(this);
}

void SemanticScholarSearchWorker::process()
{
    qInfo() << " SemanticScholarSearchWorker started...";

    auto jsonDoc = QJsonDocument::fromJson(m_keywordsJson.toUtf8());
    auto root = jsonDoc.object();
    m_keywords = root["keywords"].toArray();

    if (m_keywords.isEmpty()) {
        qWarning() << " No keywords in JSON!";
        emit searchFinished({});
        return;
    }

    qInfo() << " Keyword count:" << m_keywords.size();

    m_totalRequests = m_keywords.size();
    m_completedRequests = 0;

    for (auto kw : m_keywords) {
        auto obj = kw.toObject();
        QString term = obj["term"].toString();

        QString encoded = QUrl::toPercentEncoding(term);

        QString url = QString(
                          "https://api.semanticscholar.org/graph/v1/paper/search"
                          "?q=%1&limit=50&fields=title,abstract,authors,year,url,openAccessPdf"
                          ).arg(encoded);

        qInfo() << " Sending request to:" << url;

        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::UserAgentHeader, "QtSemanticScholarClient");

        QNetworkReply *reply = m_network->get(request);

        connect(reply, &QNetworkReply::finished, this, [this, reply, term]() {

            if (reply->error() != QNetworkReply::NoError) {
                qWarning() << " Network error:" << reply->errorString();
                m_completedRequests++;
                reply->deleteLater();
                return;
            }

            qInfo() << " Reply received for:" << term;

            QByteArray data = reply->readAll();
            reply->deleteLater();

            auto parsed = parseSemanticScholarJson(data);
            m_collectedResults.append(parsed);

            m_completedRequests++;
            qInfo() << QString(" %1/%2 completed")
                           .arg(m_completedRequests)
                           .arg(m_totalRequests);

            if (m_completedRequests == m_totalRequests) {
                qInfo() << " All Semantic Scholar search requests completed.";
                emit searchFinished(m_collectedResults);
            }
        });
    }
}
