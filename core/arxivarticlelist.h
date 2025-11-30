#pragma once
#include <QAbstractListModel>
#include <QVector>
#include <QVariantMap>

class ArxivArticleList : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        AuthorsRole,
        SummaryRole,
        LinkRole,
        PdfRole
    };

    explicit ArxivArticleList(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;

    QHash<int, QByteArray> roleNames() const override;

    // Public function to add scraped articles
    void appendArticle(const QVariantMap &article);

    // Optional: clear all results if starting new search
    Q_INVOKABLE void clearList();

private:
    QVector<QVariantMap> m_articles;
};



// #pragma once
// #include <QAbstractListModel>
// #include <QVariantMap>
// #include <QNetworkAccessManager>
// #include <QNetworkReply>
// #include <QDomDocument>

// class ArxivArticleList : public QAbstractListModel
// {
//     Q_OBJECT
//     Q_PROPERTY(QString searchQuery READ searchQuery WRITE setSearchQuery NOTIFY searchQueryChanged)

// public:
//     explicit ArxivArticleList(QObject *parent = nullptr);

//     enum Roles {
//         TitleRole = Qt::UserRole + 1,
//         AuthorsRole,
//         SummaryRole,
//         LinkRole,
//         PdfRole
//     };

//     int rowCount(const QModelIndex &parent = QModelIndex()) const override;
//     QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
//     QHash<int, QByteArray> roleNames() const override;

//     QString searchQuery() const { return m_searchQuery; }
//     void setSearchQuery(const QString &query);

//     Q_INVOKABLE void fetchArticles();

// signals:
//     void searchQueryChanged();
//     void fetchFinished();
//     void fetchError(const QString &err);

// private slots:
//     void onReplyFinished(QNetworkReply* reply);

// private:
//     QList<QVariantMap> m_articles;
//     QString m_searchQuery;
//     QNetworkAccessManager *m_manager;
// };
