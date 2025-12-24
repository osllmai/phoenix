#include "ArxivArticleList.h"
#include <QDebug>

ArxivArticleList::ArxivArticleList(const int conversationId, QObject *parent)
    : QAbstractListModel(parent), m_conversationId(conversationId)
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

/* -------------------  Process PDFs + ARXIV Summaries ------------------- */
void ArxivArticleList::processSelectedPdfs(const QString &query, const int idMessage)
{
    QtConcurrent::run([this, query, idMessage]() {

        qInfo() << "[Arxiv] Starting processSelectedPdfs with query:" << query;

        QJsonObject rootObj, settingsObj;
        QJsonArray arxivArray;
        QJsonArray filesArray;

        /* ---------------- SETTINGS SECTION ---------------- */
        settingsObj.insert("mode", "summary");
        settingsObj.insert("chunk_words", 400);
        settingsObj.insert("chunk_overlap", 0);
        settingsObj.insert("min_chunk_length", 80);
        settingsObj.insert("semantic_threshold", 0.70);
        settingsObj.insert("embedding_model", QString::fromUtf8(APP_PATH) + "/all_mpnet_base_v2");
        settingsObj.insert("use_gpu", false);
        settingsObj.insert("language", "en");
        settingsObj.insert("lowercase", true);
        settingsObj.insert("remove_newlines", true);
        settingsObj.insert("save_embeddings_only", false);
        settingsObj.insert("pdf_password", QJsonValue::Null);
        settingsObj.insert("chunking_mode", "semantic");
        settingsObj.insert("chroma_db_path",
                           QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/chroma_db");
        settingsObj.insert("conversation_id", m_conversationId);
        settingsObj.insert("min_paragraph_similarity", 0.70);
        settingsObj.insert("query_text", query);
        settingsObj.insert("output_dir_auto_create", true);
        settingsObj.insert("top_k_results", 5);

        QJsonArray sections {
            "abstract","introduction","methods","materials and methods","methodology",
            "results","findings","evaluation","discussion",
            "results and discussion","conclusion","conclusions","summary"
        };
        settingsObj.insert("filter_sections", sections);

        rootObj.insert("settings", settingsObj);

        /* ---------------- ARXIV SUMMARIES ---------------- */
        for (const QVariantMap &article : std::as_const(m_articles)) {
            QJsonObject obj;
            obj.insert("title", article.value("title").toString());
            obj.insert("pdf", article.value("link").toString());
            obj.insert("summary", article.value("summary").toString());
            arxivArray.append(obj);
        }
        rootObj.insert("arxiv_files", arxivArray);

        /* ---------------- SELECTED PDF FILES ---------------- */
        rootObj.insert("files", filesArray);

        /* ---------------- OUTPUT FILE ---------------- */
        QString outputPath = m_tempFolder + "summary_output.json";
        rootObj.insert("output", outputPath);

        /* ---------------- SAVE CONFIG ---------------- */
        QString configPath = m_tempFolder + "config_summary.json";
        QFile configFile(configPath);
        if (!configFile.open(QIODevice::WriteOnly)) {
            qWarning() << "[Arxiv] Cannot write config file";
            emit arxivDone();
            return;
        }
        configFile.write(QJsonDocument(rootObj).toJson(QJsonDocument::Indented));
        configFile.close();

        /* ---------------- RUN TOKENIZER ---------------- */
        QProcess proc;
        proc.setProgram("tokenizer/tokenizer.exe");
        proc.setArguments({ configPath });

        /* Optional but recommended */
        proc.setProcessChannelMode(QProcess::SeparateChannels);

        qInfo() << "[Arxiv] Starting tokenizer process...";
        proc.start();

        /* Failed to start */
        if (!proc.waitForStarted()) {
            qCritical() << "[Arxiv] Tokenizer failed to start.";
            qCritical() << "[Arxiv] Error:" << proc.errorString();
            emit arxivDone();
            return;
        }

        /* Wait until finished */
        proc.waitForFinished(-1);

        /* Capture outputs */
        QString stdOut = QString::fromUtf8(proc.readAllStandardOutput());
        QString stdErr = QString::fromUtf8(proc.readAllStandardError());

        qInfo() << "---------------- TOKENIZER STDOUT ----------------";
        if (stdOut.isEmpty()) {
            qInfo() << "[Arxiv] No standard output produced.";
        } else {
            qInfo().noquote() << stdOut;
        }

        qWarning() << "---------------- TOKENIZER STDERR ----------------";
        if (stdErr.isEmpty()) {
            qWarning() << "[Arxiv] No error output produced.";
        } else {
            qWarning().noquote() << stdErr;
        }

        /* Final status */
        qInfo() << "[Arxiv] Tokenizer exit code:" << proc.exitCode();
        qInfo() << "[Arxiv] Tokenizer exit status:" << proc.exitStatus();

        /* Crash detection */
        if (proc.exitStatus() != QProcess::NormalExit) {
            qCritical() << "[Arxiv] Tokenizer process crashed unexpectedly.";
        }

        /* ---------------- READ TOKENIZER OUTPUT ---------------- */
        QFile outFile(outputPath);
        if (!outFile.open(QIODevice::ReadOnly)) {
            qWarning() << "[Arxiv] Cannot read tokenizer output";
            emit arxivDone();
            return;
        }

        QJsonObject json = QJsonDocument::fromJson(outFile.readAll()).object();
        outFile.close();

        QJsonArray metadatas = json["metadatas"].toArray().first().toArray();

        /* ---------------- BUILD FILTER LIST ---------------- */
        QVector<QPair<QString, QString>> allowedArticles; // title , pdf_file

        for (const QJsonValue &val : metadatas) {
            QJsonObject meta = val.toObject();
            allowedArticles.append({
                meta["title"].toString(),
                meta["pdf_file"].toString()
            });
        }

        /* ---------------- FILTER m_articles IN-PLACE ---------------- */
        for (int i = m_articles.size() - 1; i >= 0; --i) {

            const QString title = m_articles[i].value("title").toString();
            const QString link  = m_articles[i].value("link").toString();

            bool exist = false;
            for (const auto &allowed : std::as_const(allowedArticles)) {
                if (title == allowed.first && link == allowed.second) {
                    exist = true;
                    break;
                }
            }

            if (!exist) {
                qInfo() << "[Arxiv] Removed:" << title;
                m_articles.removeAt(i);
            }
        }

        /* ---------------- DONE ---------------- */
        emit arxivDone();

        qInfo() << "[Arxiv] Processing completed successfully.";
    });
}

/* ------------------- DOWNLOAD PDFs ------------------- */
void ArxivArticleList::downloadPdfs(const int idMessage)
{
    if (m_articles.isEmpty()) {
        emit downloadsDone();
        return;
    }

    qInfo() << "[Download] Starting controlled PDF downloads...";

    // Start from index 0
    downloadNextPdf(0, idMessage);
}

void ArxivArticleList::downloadNextPdf(int index, const int idMessage)
{
    if (index >= m_articles.size()) {
        qInfo() << "[Download] All PDFs downloaded.";
        emit downloadsDone();
        return;
    }

    QVariantMap &article = m_articles[index];
    QString pdfUrl = article.value("pdf").toString();
    QString localPath = m_tempFolder + QString("file_%1.pdf").arg(index);

    qInfo() << "[Download] Requesting PDF:" << pdfUrl;

    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    QNetworkReply *reply = manager->get(QNetworkRequest(QUrl(pdfUrl)));

    connect(reply, &QNetworkReply::finished, this, [=]() {

        if (reply->error() == QNetworkReply::NoError) {

            qInfo() << "[Download] Success:" << pdfUrl;

            QFile file(localPath);
            if (file.open(QIODevice::WriteOnly)) {
                file.write(reply->readAll());
                file.close();
                m_articles[index]["localPdf"] = localPath;
                emit requestInsertSourse(m_conversationId,
                                         idMessage,
                                         m_articles[index]["title"].toString(),
                                         m_articles[index]["summary"].toString(),
                                         "qrc:/media/image_company/ArXiv.png",
                                         m_articles[index]["link"].toString());

                // Update QML
                emit dataChanged(this->index(index), this->index(index), {PdfRole});
            }

        } else {
            qWarning() << "[Download] Error downloading" << pdfUrl
                       << reply->errorString();
        }

        reply->deleteLater();
        manager->deleteLater();

        //  Delay 1500ms before next request (for arxiv anti-block)
        QTimer::singleShot(1500, this, [=]() {
            downloadNextPdf(index + 1, idMessage);
        });
    });
}

/* ------------------- GENERATE EMBEDDINGS ------------------- */
void ArxivArticleList::topSimilarChunksAsync(const QString &query, const int idMessage, int topK) {

    QtConcurrent::run([this, query, idMessage]() {

        qDebug() << "[Embeddings] Starting embedding generation…";
        qDebug() << "[Embeddings] Query Text =" << query;

        QJsonObject rootObj, settingsObj;
        QJsonArray arxivArray;
        QJsonArray filesArray;

        /* ---------------- SETTINGS SECTION ---------------- */
        settingsObj.insert("mode", "chunk");
        settingsObj.insert("chunk_words", 500);
        settingsObj.insert("chunk_overlap", 0);
        settingsObj.insert("min_chunk_length", 100);
        settingsObj.insert("semantic_threshold", 0.70);
        settingsObj.insert("embedding_model", QString::fromUtf8(APP_PATH) + "/all_mpnet_base_v2");
        settingsObj.insert("use_gpu", false);
        settingsObj.insert("language", "en");
        settingsObj.insert("lowercase", true);
        settingsObj.insert("remove_newlines", true);
        settingsObj.insert("save_embeddings_only", false);
        settingsObj.insert("pdf_password", QJsonValue::Null);
        settingsObj.insert("chunking_mode", "semantic");
        settingsObj.insert("chroma_db_path",
                           QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/chroma_db");
        settingsObj.insert("conversation_id", m_conversationId);
        settingsObj.insert("min_paragraph_similarity", 0.70);
        settingsObj.insert("query_text", query);
        settingsObj.insert("output_dir_auto_create", true);
        settingsObj.insert("top_k_results", 5);

        QJsonArray sections {
            "abstract","introduction","methods","materials and methods","methodology",
            "results","findings","evaluation","discussion",
            "results and discussion","conclusion","conclusions","summary"
        };
        settingsObj.insert("filter_sections", sections);

        rootObj.insert("settings", settingsObj);

        /* ---------------- ARXIV SUMMARIES ---------------- */
        rootObj.insert("arxiv_files", arxivArray);

        /* ---------------- SELECTED PDF FILES ---------------- */
        for (const QVariantMap &article : std::as_const(m_articles)) {
            QJsonObject obj;
            obj.insert("link", article.value("link").toString());
            obj.insert("pdf", article.value("localPdf").toString());
            filesArray.append(obj);
        }
        rootObj.insert("files", filesArray);

        /* ---------------- OUTPUT FILE ---------------- */
        QString outputPath = m_tempFolder + "chunk_output.json";
        rootObj.insert("output", outputPath);

        /* ---------------- SAVE CONFIG ---------------- */
        QString configPath = m_tempFolder + "config_chunck.json";
        QFile configFile(configPath);
        if (!configFile.open(QIODevice::WriteOnly)) {
            qWarning() << "[Arxiv] Cannot write config file";
            emit arxivDone();
            return;
        }
        configFile.write(QJsonDocument(rootObj).toJson(QJsonDocument::Indented));
        configFile.close();

        /* ---------------- RUN TOKENIZER ---------------- */
        QProcess proc;
        proc.setProgram("tokenizer/tokenizer.exe");
        proc.setArguments({ configPath });

        /* Optional but recommended */
        proc.setProcessChannelMode(QProcess::SeparateChannels);

        qInfo() << "[Arxiv] Starting tokenizer process...";
        proc.start();

        /* Failed to start */
        if (!proc.waitForStarted()) {
            qCritical() << "[Arxiv] Tokenizer failed to start.";
            qCritical() << "[Arxiv] Error:" << proc.errorString();
            emit arxivDone();
            return;
        }

        /* Wait until finished */
        proc.waitForFinished(-1);

        /* Capture outputs */
        QString stdOut = QString::fromUtf8(proc.readAllStandardOutput());
        QString stdErr = QString::fromUtf8(proc.readAllStandardError());

        qInfo() << "---------------- CHANK STDOUT ----------------";
        if (stdOut.isEmpty()) {
            qInfo() << "[Arxiv] No standard output produced.";
        } else {
            qInfo().noquote() << stdOut;
        }

        qWarning() << "---------------- CHANK STDERR ----------------";
        if (stdErr.isEmpty()) {
            qWarning() << "[Arxiv] No error output produced.";
        } else {
            qWarning().noquote() << stdErr;
        }

        /* Final status */
        qInfo() << "[Arxiv] Tokenizer exit code:" << proc.exitCode();
        qInfo() << "[Arxiv] Tokenizer exit status:" << proc.exitStatus();

        /* Crash detection */
        if (proc.exitStatus() != QProcess::NormalExit) {
            qCritical() << "[Arxiv] Tokenizer process crashed unexpectedly.";
        }

        /* ---------------- READ TOKENIZER OUTPUT ---------------- */
        QFile outFile(outputPath);
        if (!outFile.open(QIODevice::ReadOnly)) {
            qWarning() << "[Arxiv] Cannot read tokenizer output";
            emit arxivDone();
            return;
        }

        QJsonObject json = QJsonDocument::fromJson(outFile.readAll()).object();
        outFile.close();

        QJsonArray allMetadatas = json["metadatas"].toArray();
        QJsonArray allDocuments = json["documents"].toArray();
        QJsonArray allDistances = json["distances"].toArray();

        QVariantList results;

        /* -------- loop روی batch ها -------- */
        int batchCount = std::min({
            allMetadatas.size(),
            allDocuments.size(),
            allDistances.size()
        });

        for (int b = 0; b < batchCount; ++b) {

            QJsonArray metadatas = allMetadatas[b].toArray();
            QJsonArray documents = allDocuments[b].toArray();
            QJsonArray distances = allDistances[b].toArray();

            int count = std::min({
                metadatas.size(),
                documents.size(),
                distances.size()
            });

            for (int i = 0; i < count; ++i) {

                QJsonObject metaObj = metadatas[i].toObject();
                QString pdfPath     = metaObj["pdf_path"].toString();

                QString text        = documents[i].toString();
                double similarity   = distances[i].toDouble();

                QString title;
                QString link;

                for (const QVariantMap &article : std::as_const(m_articles)) {
                    if (article.value("localPdf").toString() == pdfPath) {
                        title = article.value("title").toString();
                        link  = article.value("link").toString();
                        break;
                    }
                }

                QVariantMap m;
                m["text"]       = text;
                m["similarity"] = similarity;
                m["file"]       = pdfPath;
                m["title"]      = title;
                m["link"]       = link;

                results.append(m);
            }
        }

        emit similarityReady(results);

    });
}

/* --------- FOLDER CLEANUP --------*/
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
