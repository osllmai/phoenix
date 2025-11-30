#include "ArxivSearchWorker.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QDomDocument>
#include <QTimer>
#include <QDebug>

ArxivSearchWorker::ArxivSearchWorker(QString keywordsJson, QObject *parent)
    : QObject(parent), m_keywordsJson(keywordsJson)
{
    m_network = new QNetworkAccessManager(this);
}

void ArxivSearchWorker::process() {

    qInfo() << "🔍 ArxivSearchWorker started...";

    auto jsonDoc = QJsonDocument::fromJson(m_keywordsJson.toUtf8());
    auto root = jsonDoc.object();
    m_keywords = root["keywords"].toArray();

    if (m_keywords.isEmpty()) {
        qWarning() << "⚠ No keywords in JSON!";
        emit searchFinished({});
        return;
    }

    qInfo() << "📌 Keyword count:" << m_keywords.size();

    m_totalRequests = m_keywords.size();
    m_completedRequests = 0;

    // Process each keyword request async
    for (auto kw : m_keywords) {
        auto obj = kw.toObject();
        QString term = obj["term"].toString();
        QString category = obj["category"].toString();

        QString url = QString("http://export.arxiv.org/api/query?search_query=all:\"%1\"&max_results=5")
                          .arg(term);

        qInfo() << "🌐 Sending request to:" << url;

        QNetworkRequest request(url);
        QNetworkReply *reply = m_network->get(request);

        connect(reply, &QNetworkReply::finished, this, [this, reply, term, category]() {

            qInfo() << "📩 Reply received for:" << term;

            QByteArray data = reply->readAll();
            reply->deleteLater();

            QList<QVariantMap> parsedResults = parseArxivXml(data, term, category);
            m_collectedResults.append(parsedResults);

            m_completedRequests++;

            qInfo() << QString("⏳ %1/%2 completed")
                           .arg(m_completedRequests)
                           .arg(m_totalRequests);

            if (m_completedRequests >= m_totalRequests) {
                qInfo() << "🏁 All ArXiv search requests completed.";
                emit searchFinished(m_collectedResults);
            }
        });
    }
}

QList<QVariantMap> ArxivSearchWorker::parseArxivXml(
    const QByteArray &xmlData,
    const QString &fallbackTerm,
    const QString &category) {

    QList<QVariantMap> resultList;

    QDomDocument doc;
    if (!doc.setContent(xmlData)) {
        qWarning() << "⚠ Failed to parse Atom XML";
        return resultList;
    }

    QDomNodeList entries = doc.elementsByTagName("entry");

    for (int i = 0; i < entries.size(); i++) {
        QDomNode n = entries.at(i);
        QDomElement e = n.toElement();

        QVariantMap result;
        result["title"] = e.firstChildElement("title").text();
        result["summary"] = e.firstChildElement("summary").text();

        QString authors;
        auto aNodes = e.elementsByTagName("author");
        for (int j = 0; j < aNodes.count(); j++) {
            authors += aNodes.at(j).firstChildElement("name").text();
            if (j < aNodes.count() - 1) authors += ", ";
        }
        result["authors"] = authors;

        result["category"] = category;

        result["link"] = e.firstChildElement("id").text();
        result["pdf"] = e.firstChildElement("link")
                            .attribute("href")
                            .replace("abs", "pdf"); // Quick PDF fix

        resultList.append(result);
    }

    if (resultList.isEmpty()) {
        QVariantMap fallback;
        fallback["title"] = fallbackTerm;
        fallback["summary"] = "No summary";
        fallback["authors"] = "Unknown";
        fallback["link"] = "";
        fallback["pdf"] = "";
        resultList.append(fallback);
    }

    return resultList;
}
