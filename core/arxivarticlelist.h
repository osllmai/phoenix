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
    Q_INVOKABLE void downloadPdfs();
    Q_INVOKABLE void generateEmbeddings();

signals:
    void downloadsDone();
    void embeddingsDone();

private:
    QVector<QVariantMap> m_articles;
    QString m_tempFolder;

    void cleanupTempFolder();
};
