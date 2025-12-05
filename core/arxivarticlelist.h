#pragma once
#include <QAbstractListModel>
#include <QVector>
#include <QVariantMap>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QEventLoop>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QDir>
#include <QFile>
#include <QProcess>
#include <QtConcurrent>
#include <QDateTime>
#include "config.h"

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
    ~ArxivArticleList();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void appendArticle(const QVariantMap &article);

    Q_INVOKABLE void clearList();
    Q_INVOKABLE void processSelectedPdfs(const QString &query);
    Q_INVOKABLE void downloadPdfs();
    Q_INVOKABLE void generateEmbeddings(const QString &query);
    Q_INVOKABLE void topSimilarChunksAsync(int topK = 5);

signals:
    void arxivDone();
    void downloadsDone();
    void embeddingsDone();
    void similarityReady(const QVariantList &results);

private:
    QVector<QVariantMap> m_articles;
    QString m_tempFolder;

    void cleanupTempFolder();
    void downloadNextPdf(int index);
};
