#pragma once
#include <QAbstractListModel>
#include <QVector>
#include <QVariantMap>

#include <QtConcurrent>
#include <QProcess>
#include <QFile>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QEventLoop>

class ArxivArticleList : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        AuthorsRole,
        SummaryRole,
        LinkRole,
        PdfRole,
        PublishedRole,
        HasEmbeddingRole
    };

    explicit ArxivArticleList(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;

    QHash<int, QByteArray> roleNames() const override;

    // Public function to add scraped articles
    void appendArticle(const QVariantMap &article);

    // Optional: clear all results if starting new search
    Q_INVOKABLE void clearList();
    Q_INVOKABLE void processEmbeddings();

signals:
    void embeddingsDone();


private:
    QVector<QVariantMap> m_articles;
};

