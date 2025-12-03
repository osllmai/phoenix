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

/* ------------------- DOWNLOAD PDFs ONLY ------------------- */
void ArxivArticleList::downloadPdfs() {

    QtConcurrent::run([this]() {

        QNetworkAccessManager manager;

        for (int i = 0; i < m_articles.size(); i++) {

            QVariantMap &article = m_articles[i];

            QString pdfUrl = article.value("pdf").toString();
            QString localPath = m_tempFolder + QString("file_%1.pdf").arg(i);

            QNetworkReply *reply = manager.get(QNetworkRequest(QUrl(pdfUrl)));

            QEventLoop loop;
            QObject::connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
            loop.exec();

            if (reply->error() != QNetworkReply::NoError) {
                reply->deleteLater();
                continue;
            }

            QFile file(localPath);
            if (file.open(QIODevice::WriteOnly)) {
                file.write(reply->readAll());
                file.close();
                article["localPdf"] = localPath;
            }

            reply->deleteLater();
            emit dataChanged(index(i), index(i), {PdfRole});
        }

        emit downloadsDone();
    });
}

/* ------------------- GENERATE EMBEDDINGS ONLY ------------------- */
void ArxivArticleList::generateEmbeddings() {

    QtConcurrent::run([this]() {

        QJsonObject rootObj, settingsObj;
        QJsonArray filesArray;

        settingsObj.insert("chunk_words", 1000);
        settingsObj.insert("chunk_overlap", 200);
        settingsObj.insert("model_path", "E:/llama.cpp/build/bin/Release/multi-qa-mpnet-base-cos-v1");
        rootObj.insert("settings", settingsObj);

        for (int i = 0; i < m_articles.size(); ++i) {
            QVariantMap &a = m_articles[i];

            QString localPdf = a.value("localPdf").toString();
            if (localPdf.isEmpty()) continue;

            QString outJson = m_tempFolder + QString("file_%1.json").arg(i);

            QJsonObject fObj;
            fObj.insert("pdf", localPdf);
            fObj.insert("output", outJson);

            filesArray.append(fObj);
        }

        rootObj.insert("files", filesArray);

        QString configPath = m_tempFolder + "config.json";
        QFile configFile(configPath);
        configFile.open(QIODevice::WriteOnly);
        configFile.write(QJsonDocument(rootObj).toJson());
        configFile.close();

        QProcess process;
        process.setProgram("tokenizer/tokenizer.exe");
        process.setArguments({configPath});
        process.start();
        process.waitForFinished(-1);

        for (int i = 0; i < m_articles.size(); ++i) {
            m_articles[i]["hasEmbedding"] = true;
            emit dataChanged(index(i), index(i), {HasEmbeddingRole});
        }

        emit embeddingsDone();
    });
}

/* --------- Folder Cleanup --------*/
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
