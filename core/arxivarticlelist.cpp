#include "arxivarticlelist.h"
#include <QNetworkRequest>
#include <QUrl>
#include <QDebug>

ArxivArticleList::ArxivArticleList(QObject *parent)
    : QAbstractListModel(parent)
{
    m_manager = new QNetworkAccessManager(this);
}

int ArxivArticleList::rowCount(const QModelIndex &parent) const
{
    if(parent.isValid()) return 0;
    return m_articles.count();
}

QVariant ArxivArticleList::data(const QModelIndex &index, int role) const
{
    if(!index.isValid() || index.row() >= m_articles.count())
        return QVariant();

    const QVariantMap &article = m_articles.at(index.row());
    switch(role) {
    case TitleRole: return article.value("title");
    case AuthorsRole: return article.value("authors");
    case SummaryRole: return article.value("summary");
    case LinkRole: return article.value("link");
    case PdfRole: return article.value("pdf");
    default: return QVariant();
    }
}

QHash<int, QByteArray> ArxivArticleList::roleNames() const
{
    return {
        {TitleRole, "title"},
        {AuthorsRole, "authors"},
        {SummaryRole, "summary"},
        {LinkRole, "link"},
        {PdfRole, "pdf"}
    };
}

void ArxivArticleList::setSearchQuery(const QString &query)
{
    if(query == m_searchQuery) return;
    m_searchQuery = query;
    emit searchQueryChanged();
    fetchArticles();
}

void ArxivArticleList::fetchArticles()
{
    if(m_searchQuery.isEmpty()) return;

    QString urlStr = QString("https://export.arxiv.org/api/query?search_query=all:%1&start=0&max_results=5")
                         .arg(m_searchQuery);
    QNetworkRequest request(urlStr);
    QNetworkReply *reply = m_manager->get(request);
    connect(reply, &QNetworkReply::finished, [this, reply](){ onReplyFinished(reply); });
}

void ArxivArticleList::onReplyFinished(QNetworkReply* reply)
{
    if(reply->error() != QNetworkReply::NoError) {
        emit fetchError(reply->errorString());
        reply->deleteLater();
        return;
    }

    QByteArray data = reply->readAll();
    QDomDocument doc;
    if(!doc.setContent(data)) {
        emit fetchError("Failed to parse XML");
        reply->deleteLater();
        return;
    }

    beginResetModel();
    m_articles.clear();

    QDomNodeList entries = doc.elementsByTagName("entry");
    for(int i=0; i<entries.count(); ++i) {
        QDomElement entry = entries.at(i).toElement();
        QVariantMap map;
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

        m_articles.append(map);
    }
    endResetModel();

    emit fetchFinished();
    reply->deleteLater();
}
