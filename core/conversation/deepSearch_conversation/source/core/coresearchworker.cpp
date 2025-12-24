#include "CORESearchWorker.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QDebug>

CORESearchWorker::CORESearchWorker(QString keywordsJson, QObject *parent)
    : QObject(parent),
    m_keywordsJson(keywordsJson)
{
    m_network = new QNetworkAccessManager(this);
}

void CORESearchWorker::process()
{
    qInfo() << "[CORE] Search worker started...";

    auto jsonDoc = QJsonDocument::fromJson(m_keywordsJson.toUtf8());
    auto root = jsonDoc.object();
    m_keywords = root["keywords"].toArray();

    if (m_keywords.isEmpty()) {
        qWarning() << "[CORE] No keywords in JSON!";
        emit searchFinished({});
        return;
    }

    qInfo() << "[CORE] Keyword count:" << m_keywords.size();

    m_totalRequests = m_keywords.size();
    m_completedRequests = 0;

    for (auto kw : m_keywords) {
        auto obj = kw.toObject();
        QString term = obj["term"].toString();

        QString encoded = QUrl::toPercentEncoding(term);

        QString url = QString(
                          "https://api.core.ac.uk/v3/search/works"
                          "?q=%1&limit=50")
                          .arg(encoded);

        qInfo() << "[CORE] Sending request:" << url;

        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader,
                          "application/json");

        QNetworkReply *reply = m_network->get(request);

        connect(reply, &QNetworkReply::finished, this,
                [this, reply, term]() {

                    if (reply->error() != QNetworkReply::NoError) {
                        qWarning() << "[CORE] Network error for"
                                   << term << ":" << reply->errorString();

                        m_completedRequests++;
                        reply->deleteLater();
                        return;
                    }

                    qInfo() << "[CORE] Reply received for:" << term;

                    QByteArray data = reply->readAll();
                    reply->deleteLater();

                    auto parsed = parseCoreJson(data);
                    m_collectedResults.append(parsed);

                    m_completedRequests++;
                    qInfo() << QString("[CORE] %1/%2 completed")
                                   .arg(m_completedRequests)
                                   .arg(m_totalRequests);

                    if (m_completedRequests == m_totalRequests) {
                        qInfo() << "[CORE] All CORE search requests completed.";
                        emit searchFinished(m_collectedResults);
                    }
                });
    }
}

QList<QVariantMap> CORESearchWorker::parseCoreJson(const QByteArray &data)
{
    QList<QVariantMap> results;

    auto doc = QJsonDocument::fromJson(data);
    if (!doc.isObject())
        return results;

    auto root = doc.object();
    auto items = root["results"].toArray();

    for (auto it : items) {
        auto obj = it.toObject();
        QVariantMap entry;

        entry["title"] = obj["title"].toString();
        entry["summary"] = obj["abstract"].toString();
        entry["published"] =
            obj["publishedDate"].toString().left(10);

        // Authors
        QStringList authors;
        for (auto a : obj["authors"].toArray()) {
            authors << a.toObject()["name"].toString();
        }
        entry["authors"] = authors.join(", ");

        // PDF
        entry["pdf"] = obj["downloadUrl"].toString();

        // Link
        auto urls = obj["sourceFulltextUrls"].toArray();
        if (!urls.isEmpty())
            entry["link"] = urls.first().toString();
        else
            entry["link"] = "";

        // Phoenix-compatible fields
        entry["localPdf"] = "";
        entry["hasEmbedding"] = false;
        entry["source"] = "CORE";

        results.append(entry);
    }

    return results;
}
