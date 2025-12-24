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

    explicit ArxivArticleList(const int conversationId, QObject *parent = nullptr);
    ~ArxivArticleList();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void appendArticle(const QVariantMap &article);

    Q_INVOKABLE void clearList();
    Q_INVOKABLE void processSelectedPdfs(const QString &query, const int idMessage);
    Q_INVOKABLE void downloadPdfs(const int idMessage);
    Q_INVOKABLE void topSimilarChunksAsync(const QString &query, const int idMessage, int topK = 5);

signals:
    void arxivDone();
    void downloadsDone();
    void similarityReady(const QVariantList &results);
    void requestInsertActivity(const int idConversation,
                               const int idMessage,
                               const QString &text,
                               const QString &icon);
    void requestInsertSourse(const int idConversation,
                             const int idMessage,
                             const QString &titel,
                             const QString &text,
                             const QString &icon,
                             const QString &link);

private:
    const int m_conversationId;
    QVector<QVariantMap> m_articles;
    QString m_tempFolder;

    void cleanupTempFolder();
    void downloadNextPdf(int index, const int idMessage);
};
