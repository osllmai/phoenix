#include "PMCSearchWorker.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QXmlStreamReader>
#include <QUrl>
#include <QDebug>

PMCSearchWorker::PMCSearchWorker(QString keywordsJson, QObject *parent)
    : QObject(parent), m_keywordsJson(keywordsJson)
{
    m_network = new QNetworkAccessManager(this);
}

void PMCSearchWorker::process()
{
    qInfo() << "PMCSearchWorker started...";

    auto jsonDoc = QJsonDocument::fromJson(m_keywordsJson.toUtf8());
    auto root = jsonDoc.object();
    m_keywords = root["keywords"].toArray();

    if (m_keywords.isEmpty()) {
        qWarning() << "No keywords in JSON!";
        emit searchFinished({});
        return;
    }

    m_totalRequests = m_keywords.size();
    m_completedRequests = 0;

    for (auto kw : m_keywords) {
        QString term = kw.toObject()["term"].toString();
        QString encoded = QUrl::toPercentEncoding(term);

        QString url = QString(
                          "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"
                          "?db=pmc&term=%1&retmax=20"
                          ).arg(encoded);

        qInfo() << "Sending PMC search request:" << url;

        QNetworkRequest req(url);
        QNetworkReply *reply = m_network->get(req);

        connect(reply, &QNetworkReply::finished, this, [=]() {
            if (reply->error() != QNetworkReply::NoError) {
                qWarning() << "PMC search error:" << reply->errorString();
                reply->deleteLater();
                m_completedRequests++;
                return;
            }

            QByteArray data = reply->readAll();
            reply->deleteLater();

            // --- parse ID list ---
            QXmlStreamReader xml(data);
            QStringList ids;

            while (!xml.atEnd()) {
                xml.readNext();
                if (xml.isStartElement() && xml.name() == "Id") {
                    ids << xml.readElementText();
                }
            }

            if (!ids.isEmpty()) {
                fetchDetails(ids.join(","));
            } else {
                m_completedRequests++;
            }

            if (m_completedRequests == m_totalRequests) {
                emit searchFinished(m_collectedResults);
            }
        });
    }
}

void PMCSearchWorker::fetchDetails(const QString &idList)
{
    QString url = QString(
                      "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi"
                      "?db=pmc&id=%1&retmode=xml"
                      ).arg(idList);

    qInfo() << "Fetching PMC details:" << url;

    QNetworkRequest req(url);
    QNetworkReply *reply = m_network->get(req);

    connect(reply, &QNetworkReply::finished, this, [=]() {
        if (reply->error() != QNetworkReply::NoError) {
            qWarning() << "PMC fetch error:" << reply->errorString();
            reply->deleteLater();
            m_completedRequests++;
            return;
        }

        QByteArray data = reply->readAll();
        reply->deleteLater();

        auto parsed = parsePmcXml(data);
        m_collectedResults.append(parsed);

        m_completedRequests++;
        qInfo() << "PMC completed" << m_completedRequests << "/" << m_totalRequests;

        if (m_completedRequests == m_totalRequests) {
            emit searchFinished(m_collectedResults);
        }
    });
}

QList<QVariantMap> PMCSearchWorker::parsePmcXml(const QByteArray &data)
{
    QList<QVariantMap> results;
    QXmlStreamReader xml(data);

    QVariantMap entry;
    QStringList authors;

    while (!xml.atEnd()) {
        xml.readNext();

        if (xml.isStartElement()) {
            QString tag = xml.name().toString();

            if (tag == "article") {
                entry.clear();
                authors.clear();
            }
            else if (tag == "article-title") {
                entry["title"] = xml.readElementText().trimmed();
            }
            else if (tag == "abstract") {
                entry["summary"] = xml.readElementText().trimmed();
            }
            else if (tag == "pub-date") {
                entry["published"] = xml.readElementText().trimmed();
            }
            else if (tag == "surname") {
                authors << xml.readElementText().trimmed();
            }
            else if (tag == "article-id") {
                auto type = xml.attributes().value("pub-id-type").toString();
                if (type == "pmc") {
                    entry["link"] =
                        "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC"
                        + xml.readElementText().trimmed();
                }
            }
        }
        else if (xml.isEndElement() && xml.name() == "article") {
            entry["authors"] = authors.join(", ");
            entry["pdf"] = entry["link"].toString() + "/pdf";
            entry["localPdf"] = "";
            entry["hasEmbedding"] = false;

            results.append(entry);
        }
    }

    if (xml.hasError()) {
        qWarning() << "PMC XML parse error:" << xml.errorString();
    }

    return results;
}
