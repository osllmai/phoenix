#include "ArxivArticleList.h"
#include <QDebug>

ArxivArticleList::ArxivArticleList(QObject *parent)
    : QAbstractListModel(parent)
{
    QString timestamp = QString::number(QDateTime::currentSecsSinceEpoch());
    m_tempFolder = QDir::tempPath() + "/arxiv_embeddings/" + timestamp + "/";

    QDir().mkpath(m_tempFolder);
    qDebug() << "[Init] Temp folder created:" << m_tempFolder;
}

ArxivArticleList::~ArxivArticleList()
{
    cleanupTempFolder();
}

int ArxivArticleList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_articles.size();
}

QVariant ArxivArticleList::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_articles.size())
        return {};

    const QVariantMap &article = m_articles[index.row()];

    switch (role) {
    case TitleRole: return article.value("title");
    case AuthorsRole: return article.value("authors");
    case SummaryRole: return article.value("summary");
    case LinkRole: return article.value("link");
    case PdfRole: return article.value("pdf");
    case PublishedRole: return article.value("published");
    case HasEmbeddingRole: return article.value("hasEmbedding", false);
    }
    return {};
}

QHash<int, QByteArray> ArxivArticleList::roleNames() const {
    return {
        {TitleRole, "title"},
        {AuthorsRole, "authors"},
        {SummaryRole, "summary"},
        {LinkRole, "link"},
        {PdfRole, "pdf"},
        {PublishedRole, "published"},
        {HasEmbeddingRole, "hasEmbedding"}
    };
}

void ArxivArticleList::appendArticle(const QVariantMap &article) {
    beginInsertRows(QModelIndex(), m_articles.size(), m_articles.size());
    m_articles.append(article);
    endInsertRows();
}

void ArxivArticleList::clearList() {
    beginResetModel();
    m_articles.clear();
    endResetModel();
    cleanupTempFolder();
}

void ArxivArticleList::cleanupTempFolder()
{
    if (!m_tempFolder.isEmpty()) {
        QDir dir(m_tempFolder);
        if (dir.exists()) {
            dir.removeRecursively();
            qDebug() << "[Cleanup] Deleted temp folder:" << m_tempFolder;
        }
    }
}
