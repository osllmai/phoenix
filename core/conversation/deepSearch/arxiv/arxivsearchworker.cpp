#include "ArxivSearchWorker.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QXmlStreamReader>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QDebug>

ArxivSearchWorker::ArxivSearchWorker(QString keywordsJson, QObject *parent)
    : QObject(parent), m_keywordsJson(keywordsJson)
{
    m_network = new QNetworkAccessManager(this);
}

void ArxivSearchWorker::process() {

    qInfo() << " ArxivSearchWorker started...";

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
            QString("https://export.arxiv.org/api/query?search_query=all:%1&start=0&max_results=5")
                .arg(encoded);


        qInfo() << " Sending request to:" << url;

        QNetworkRequest request(url);
        QNetworkReply *reply = m_network->get(request);

        connect(reply, &QNetworkReply::finished, this, [this, reply, term]() {

            if (reply->error() != QNetworkReply::NoError) {
                qWarning() << " network error:" << reply->errorString();
                m_completedRequests++;
                reply->deleteLater();
                return;
            }

            qInfo() << " Reply received for:" << term;

            QByteArray data = reply->readAll();
            reply->deleteLater();

            auto parsed = parseArxivXml(data);
            m_collectedResults.append(parsed);

            m_completedRequests++;
            qInfo() << QString(" %1/%2 completed")
                           .arg(m_completedRequests)
                           .arg(m_totalRequests);

            if (m_completedRequests == m_totalRequests) {
                qInfo() << " All ArXiv search requests completed.";
                emit searchFinished(m_collectedResults);
            }
        });
    }
}

QList<QVariantMap> ArxivSearchWorker::parseArxivXml(const QByteArray &data)
{
    QList<QVariantMap> results;
    QXmlStreamReader xml(data);

    QVariantMap entry;
    QStringList authors;

    while (!xml.atEnd()) {
        xml.readNext();

        if (xml.isStartElement()) {
            auto tag = xml.name().toString();

            if (tag == "entry") {
                entry.clear();
                authors.clear();
            }
            else if (tag == "title") {
                entry["title"] = xml.readElementText().trimmed();
            }
            else if (tag == "summary") {
                entry["summary"] = xml.readElementText().trimmed();
            }
            else if (tag == "id") {
                entry["link"] = xml.readElementText().trimmed();
            }
            else if (tag == "published") {
                QString pub = xml.readElementText().trimmed();
                entry["published"] = pub.left(10);
            }
            else if (tag == "name") {
                authors << xml.readElementText().trimmed();
            }
            else if (tag == "link") {
                auto attr = xml.attributes();
                if (attr.value("type") == "application/pdf")
                    entry["pdf"] = attr.value("href").toString();
            }
        }
        else if (xml.isEndElement() && xml.name() == "entry") {
            entry["authors"] = authors.join(", ");
            results.append(entry);
        }
    }

    if (xml.hasError()) {
        qWarning() << " XML Parse Error:" << xml.errorString();
    }

    return results;
}
