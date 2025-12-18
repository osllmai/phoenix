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

/* -------------------  Process PDFs + ARXIV Summaries ------------------- */
void ArxivArticleList::processSelectedPdfs(const QString &query, const int conversationId)
{
    QtConcurrent::run([this, query, conversationId]() {

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
        settingsObj.insert("conversation_id", conversationId);
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
        QString outputPath = m_tempFolder + "tokenizer_output.json";
        rootObj.insert("output", outputPath);

        /* ---------------- SAVE CONFIG ---------------- */
        QString configPath = m_tempFolder + "config_arxiv.json";
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
void ArxivArticleList::downloadPdfs()
{
    if (m_articles.isEmpty()) {
        emit downloadsDone();
        return;
    }

    qInfo() << "[Download] Starting controlled PDF downloads...";

    // Start from index 0
    downloadNextPdf(0);
}

void ArxivArticleList::downloadNextPdf(int index)
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
            downloadNextPdf(index + 1);
        });
    });
}

/* ------------------- GENERATE EMBEDDINGS ------------------- */
void ArxivArticleList::generateEmbeddings(const QString &query, const int converstationId) {

    QtConcurrent::run([this, query, converstationId]() {

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
        settingsObj.insert("conversation_id", converstationId);
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
            obj.insert("title", article.value("title").toString());
            obj.insert("pdf", article.value("link").toString());
            obj.insert("summary", article.value("summary").toString());
            filesArray.append(obj);
        }
        rootObj.insert("files", filesArray);










        // ---------------- SETTINGS ----------------
        qDebug() << "[Settings] Building settings JSON…";

        settingsObj.insert("chunk_words", 300);
        settingsObj.insert("chunk_overlap", 0);
        settingsObj.insert("min_chunk_length", 80);
        settingsObj.insert("semantic_threshold", 0.50);
        settingsObj.insert("embedding_model", QString::fromUtf8(APP_PATH) + "/all_mpnet_base_v2");
        settingsObj.insert("use_gpu", true);
        settingsObj.insert("language", "en");
        settingsObj.insert("lowercase", true);
        settingsObj.insert("remove_newlines", true);
        settingsObj.insert("save_embeddings_only", false);
        settingsObj.insert("pdf_password", QJsonValue::Null);
        settingsObj.insert("chunking_mode", "semantic");
        settingsObj.insert("min_paragraph_similarity", 0.50);
        settingsObj.insert("query_text", query);
        settingsObj.insert("output_dir_auto_create", true);

        // filter_sections array
        QJsonArray filters;
        QStringList filterList = {
            "abstract","introduction","methods","materials and methods","methodology",
            "results","findings","evaluation","discussion","results and discussion",
            "conclusion","conclusions","summary"
        };

        for (const QString &f : filterList)
            filters.append(f);

        settingsObj.insert("filter_sections", filters);
        rootObj.insert("settings", settingsObj);

        qDebug() << "[Settings] Settings JSON created.";

        // ------------------- FILES SECTION -------------------
        qDebug() << "[Files] Scanning articles for local PDF files…";

        for (int i = 0; i < m_articles.size(); ++i) {

            QVariantMap &a = m_articles[i];
            QString localPdf = a.value("localPdf").toString();

            if (localPdf.isEmpty()) {
                qWarning() << "[Files] Article index" << i << "does NOT have a PDF. Skipping.";
                continue;
            }

            QString outJson = m_tempFolder + QString("file_%1.json").arg(i);

            qDebug() << "[Files] Added:" << localPdf << "=>" << outJson;

            QJsonObject fObj;
            fObj.insert("pdf", localPdf);
            fObj.insert("output", outJson);

            filesArray.append(fObj);
        }

        rootObj.insert("files", filesArray);

        // ------------------- ARXIV (EMPTY) -------------------
        qDebug() << "[Arxiv] Using empty arxiv_files list.";
        rootObj.insert("arxiv_files", QJsonArray());
        rootObj.insert("arxiv_output", m_tempFolder + "arxiv_summaries.json");

        // ------------------- WRITE CONFIG.JSON -------------------
        QString configPath = m_tempFolder + "config.json";
        qDebug() << "[Config] Writing config to:" << configPath;

        QFile configFile(configPath);
        if (!configFile.open(QIODevice::WriteOnly)) {
            qWarning() << "[Config] ERROR: Unable to write config.json!";
            return;
        }

        configFile.write(QJsonDocument(rootObj).toJson(QJsonDocument::Indented));
        configFile.close();

        qDebug() << "[Config] config.json written successfully.";

        // ------------------- RUN TOKENIZER -------------------
        qDebug() << "[Tokenizer] Starting tokenizer.exe…";

        QProcess process;
        process.setProgram("tokenizer/tokenizer.exe");
        process.setArguments({configPath});
        process.start();

        if (!process.waitForStarted()) {
            qWarning() << "[Tokenizer] ERROR: tokenizer.exe failed to start!";
            return;
        }

        qDebug() << "[Tokenizer] Running… waiting for finish.";

        process.waitForFinished(-1);

        QByteArray stdOut = process.readAllStandardOutput();
        QByteArray stdErr = process.readAllStandardError();

        qDebug() << "[Tokenizer] Finished with exit code:" << process.exitCode();
        qDebug() << "[Tokenizer] STDOUT:\n" << stdOut;
        if (!stdErr.isEmpty())
            qWarning() << "[Tokenizer] STDERR:\n" << stdErr;

        // ------------------- UPDATE MODEL -------------------
        qDebug() << "[UI] Updating embedding flags…";

        for (int i = 0; i < m_articles.size(); ++i) {
            m_articles[i]["hasEmbedding"] = true;
            emit dataChanged(index(i), index(i), {HasEmbeddingRole});
        }

        qDebug() << "[Embeddings] All embeddings completed!";
        emit embeddingsDone();
    });
}

void ArxivArticleList::topSimilarChunksAsync(int topK)
{
    qDebug() << "[Similarity] Starting similarity extraction on background thread…";

    QtConcurrent::run([this, topK]() {

        QVariantList results;

        QDir dir(m_tempFolder);
        QStringList jsonFiles = dir.entryList(QStringList() << "file_*.json", QDir::Files);

        if (jsonFiles.isEmpty()) {
            qWarning() << "[Similarity] No JSON files found!";
            emit similarityReady(results);
            return;
        }

        struct ChunkEntry {
            double sim;
            QString text;
            QString file;
            QString title;
            QString link;
        };

        QList<ChunkEntry> allChunks;

        qDebug() << "[Similarity] Found" << jsonFiles.size() << "JSON files.";

        // ==================== READ JSON FILES ====================
        for (const QString &fileName : jsonFiles) {

            QString jsonPath = dir.absoluteFilePath(fileName);
            qDebug() << "[Similarity] Reading JSON:" << jsonPath;

            QFile f(jsonPath);
            if (!f.open(QIODevice::ReadOnly)) {
                qWarning() << "[Similarity] Cannot read file:" << jsonPath;
                continue;
            }

            QJsonDocument doc = QJsonDocument::fromJson(f.readAll());
            f.close();

            if (!doc.isObject()) {
                qWarning() << "[Similarity] Invalid JSON Format!";
                continue;
            }

            QJsonObject root = doc.object();

            QString pdfPath = root.value("file").toString();
            double fileSim = root.value("file_similarity_pct").toDouble();

            qDebug() << "[Similarity] File similarity:" << fileSim;

            QJsonArray chunks = root.value("chunks").toArray();

            QString foundTitle, foundLink;
            for (const QVariantMap &a : m_articles) {
                if (a.value("localPdf").toString() == pdfPath) {
                    foundTitle = a.value("title").toString();
                    foundLink  = a.value("pdf").toString();
                    break;
                }
            }

            for (const QJsonValue &v : chunks) {
                QJsonObject c = v.toObject();

                QString text = c.value("chunk").toString();
                double sim = c.value("meta").toObject().value("similarity_pct").toDouble();

                allChunks.append({
                    sim,
                    text,
                    pdfPath,
                    foundTitle,
                    foundLink
                });
            }
        }

        qDebug() << "[Similarity] Total chunks loaded:" << allChunks.size();

        // ==================== SORT ====================
        std::sort(allChunks.begin(), allChunks.end(), [](const ChunkEntry &a, const ChunkEntry &b){
            return a.sim > b.sim;
        });

        qDebug() << "[Similarity] Sorting completed.";

        // ==================== TOP K ====================
        int count = qMin(topK, allChunks.size());

        qDebug() << "[Similarity] Selecting top" << count << "chunks.";

        for (int i = 0; i < count; ++i) {
            const ChunkEntry &c = allChunks[i];

            QVariantMap m;
            m["text"] = c.text;
            m["similarity"] = c.sim;
            m["file"] = c.file;
            m["title"] = c.title;
            m["link"] = c.link;

            results.append(m);

            qDebug() << "[Similarity] #" << i+1 << "sim=" << c.sim
                     << "file=" << c.file
                     << "title=" << c.title;
        }

        qDebug() << "[Similarity] Done! Emitting results…";

        emit similarityReady(results);

    }); // QtConcurrent
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
