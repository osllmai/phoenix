#include "ArxivFetcher.h"
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrlQuery>
#include <QDomElement>

ArxivFetcher::ArxivFetcher(QObject *parent)
    : QObject(parent)
{
    m_manager = new QNetworkAccessManager(this);
}

void ArxivFetcher::fetch(const QString &query, int maxResults)
{
    QString url = QString("https://export.arxiv.org/api/query?search_query=all:%1&start=0&max_results=%2")
    .arg(query, QString::number(maxResults));
    QNetworkRequest request(url);
    QNetworkReply* reply = m_manager->get(request);
    connect(reply, &QNetworkReply::finished, [this, reply]() { onReplyFinished(reply); });
}

void ArxivFetcher::onReplyFinished(QNetworkReply* reply)
{
    if(reply->error() != QNetworkReply::NoError) {
        emit errorOccurred(reply->errorString());
        reply->deleteLater();
        return;
    }

    QByteArray data = reply->readAll();
    QDomDocument doc;
    if(!doc.setContent(data)) {
        emit errorOccurred("Failed to parse XML");
        reply->deleteLater();
        return;
    }

    m_entries.clear();
    QDomNodeList entries = doc.elementsByTagName("entry");
    for(int i=0; i<entries.count(); ++i) {
        QDomElement entry = entries.at(i).toElement();
        QVariantMap map;
        map["id"] = entry.firstChildElement("id").text();
        map["title"] = entry.firstChildElement("title").text();
        map["summary"] = entry.firstChildElement("summary").text();

        QDomNodeList links = entry.elementsByTagName("link");
        for(int j=0; j<links.count(); ++j) {
            QDomElement l = links.at(j).toElement();
            if(l.attribute("title") == "pdf") map["pdf"] = l.attribute("href");
            else if(l.attribute("rel") == "alternate") map["link"] = l.attribute("href");
        }

        QDomNodeList authors = entry.elementsByTagName("author");
        QStringList authorList;
        for(int j=0; j<authors.count(); ++j) {
            QDomElement a = authors.at(j).toElement();
            authorList.append(a.firstChildElement("name").text());
        }
        map["authors"] = authorList.join(", ");

        m_entries.append(map);
    }

    emit finished();
    reply->deleteLater();
}
