#include "OpenAlexSearchWorker.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QDebug>

OpenAlexSearchWorker::OpenAlexSearchWorker(QString keywordsJson, QObject *parent)
    : QObject(parent), m_keywordsJson(keywordsJson)
{
    m_network = new QNetworkAccessManager(this);
}

void OpenAlexSearchWorker::process()
{
    qInfo() << " OpenAlexSearchWorker started...";

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

        QString url =
            QString("https://api.openalex.org/works?search=%1&per-page=25")
                .arg(encoded);

        qInfo() << " Sending OpenAlex request to:" << url;

        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::UserAgentHeader,
                          "QtOpenAlexClient/1.0");

        QNetworkReply *reply = m_network->get(request);

        connect(reply, &QNetworkReply::finished, this,
                [this, reply, term]() {

                    if (reply->error() != QNetworkReply::NoError) {
                        qWarning() << " OpenAlex network error:" << reply->errorString();
                        m_completedRequests++;
                        reply->deleteLater();
                        return;
                    }

                    qInfo() << " OpenAlex reply received for:" << term;

                    QByteArray data = reply->readAll();
                    reply->deleteLater();

                    auto parsed = parseOpenAlexJson(data);
                    m_collectedResults.append(parsed);

                    m_completedRequests++;

                    qInfo() << QString(" %1/%2 completed")
                                   .arg(m_completedRequests)
                                   .arg(m_totalRequests);

                    if (m_completedRequests == m_totalRequests) {
                        qInfo() << " All OpenAlex search requests completed.";
                        emit searchFinished(m_collectedResults);
                    }
                });
    }
}

QList<QVariantMap> OpenAlexSearchWorker::parseOpenAlexJson(const QByteArray &data)
{
    QList<QVariantMap> results;

    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (!doc.isObject()) {
        qWarning() << " Invalid OpenAlex JSON";
        return results;
    }

    QJsonObject root = doc.object();
    QJsonArray works = root["results"].toArray();

    for (auto w : works) {
        QJsonObject obj = w.toObject();
        QVariantMap entry;

        entry["title"] = obj["title"].toString();

        // abstract (OpenAlex stores it inverted)
        if (obj.contains("abstract_inverted_index")) {
            QJsonObject inv = obj["abstract_inverted_index"].toObject();
            QStringList abstractWords;
            for (auto it = inv.begin(); it != inv.end(); ++it)
                abstractWords << it.key();
            entry["summary"] = abstractWords.join(" ");
        } else {
            entry["summary"] = "";
        }

        entry["published"] =
            QString::number(obj["publication_year"].toInt());

        entry["link"] = obj["id"].toString();

        // authors
        QStringList authors;
        for (auto a : obj["authorships"].toArray()) {
            auto aobj = a.toObject();
            authors << aobj["author"].toObject()["display_name"].toString();
        }
        entry["authors"] = authors.join(", ");

        // PDF link (if exists)
        entry["pdf"] = "";
        for (auto loc : obj["locations"].toArray()) {
            auto lobj = loc.toObject();
            QString pdf = lobj["pdf_url"].toString();
            if (!pdf.isEmpty()) {
                entry["pdf"] = pdf;
                break;
            }
        }

        entry["localPdf"] = "";
        entry["hasEmbedding"] = false;
        entry["source"] = "OpenAlex";

        results.append(entry);
    }

    return results;
}
