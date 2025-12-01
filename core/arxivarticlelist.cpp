#include "ArxivArticleList.h"

ArxivArticleList::ArxivArticleList(QObject *parent)
    : QAbstractListModel(parent)
{
}

int ArxivArticleList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_articles.size();
}

QVariant ArxivArticleList::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_articles.size())
        return QVariant();

    const QVariantMap &article = m_articles[index.row()];

    switch (role) {
    case TitleRole:
        return article.value("title");
    case AuthorsRole:
        return article.value("authors");
    case SummaryRole:
        return article.value("summary");
    case LinkRole:
        return article.value("link");
    case PdfRole:
        return article.value("pdf");
    case PublishedRole:
        return article.value("published");
    case HasEmbeddingRole:
        return article.value("hasEmbedding", false);

    }
    return QVariant();
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
}

void ArxivArticleList::processEmbeddings() {

    QtConcurrent::run([this]() {

        QNetworkAccessManager manager;
        QJsonObject rootObj;
        QJsonObject settingsObj;
        QJsonArray filesArray;

        settingsObj.insert("chunk_words", 1000);
        settingsObj.insert("chunk_overlap", 200);
        settingsObj.insert("min_chunk_length", 100);
        settingsObj.insert("model_path",
                           "E:/llama.cpp/build/bin/Release/multi-qa-mpnet-base-cos-v1");
        settingsObj.insert("use_gpu", true);
        settingsObj.insert("language", "en");
        settingsObj.insert("lowercase", true);
        settingsObj.insert("remove_newlines", true);
        settingsObj.insert("save_embeddings_only", false);
        settingsObj.insert("pdf_password", QJsonValue::Null);

        rootObj.insert("settings", settingsObj);

        QString tempDir = QDir::tempPath() + "/arxiv_embeddings/";
        QDir().mkpath(tempDir);

        for (int i = 0; i < m_articles.size(); i++) {

            QVariantMap &article = m_articles[i];
            if (article.value("hasEmbedding", false).toBool())
                continue;

            QString pdfUrl = article.value("pdf").toString();
            QString tempPdfPath = tempDir + QString("file_%1.pdf").arg(i);
            QString tempJsonPath = tempDir + QString("file_%1.json").arg(i);

            QNetworkReply *reply = manager.get(QNetworkRequest(QUrl(pdfUrl)));

            QEventLoop loop;
            connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
            loop.exec();

            QFile file(tempPdfPath);
            file.open(QIODevice::WriteOnly);
            file.write(reply->readAll());
            file.close();
            reply->deleteLater();

            QJsonObject fileObj;
            fileObj.insert("pdf", tempPdfPath);
            fileObj.insert("output", tempJsonPath);
            filesArray.append(fileObj);
        }

        rootObj.insert("files", filesArray);

        QString configPath = tempDir + "config.json";
        QFile configFile(configPath);
        configFile.open(QIODevice::WriteOnly);
        configFile.write(QJsonDocument(rootObj).toJson(QJsonDocument::Indented));
        configFile.close();

        QProcess process;
        process.start("pdf_to_embedding.exe", QStringList() << configPath);
        process.waitForFinished(-1);

        for (int i = 0; i < m_articles.size(); i++) {
            QVariantMap &a = m_articles[i];
            if (!a.value("hasEmbedding", false).toBool()) {
                a["hasEmbedding"] = true;
                emit dataChanged(index(i), index(i), {HasEmbeddingRole});
            }
        }

        emit embeddingsDone();
    });
}
