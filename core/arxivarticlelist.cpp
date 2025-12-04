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
void ArxivArticleList::processSelectedPdfs(const QString &query)
{
    QtConcurrent::run([this, query]() {

        qInfo() << "[Arxiv] Starting processSelectedPdfs with query:" << query;

        QJsonObject rootObj, settingsObj;
        QJsonArray arxivArray;

        /* ---------------- SETTINGS SECTION ---------------- */
        qInfo() << "[Arxiv] Building settings object...";
        settingsObj.insert("chunk_words", 300);
        settingsObj.insert("chunk_overlap", 0);
        settingsObj.insert("min_chunk_length", 80);
        settingsObj.insert("semantic_threshold", 0.50);
        settingsObj.insert("embedding_model", "E:/all-mpnet-base-v2");
        settingsObj.insert("use_gpu", true);
        settingsObj.insert("language", "en");
        settingsObj.insert("lowercase", true);
        settingsObj.insert("remove_newlines", true);
        settingsObj.insert("save_embeddings_only", false);
        settingsObj.insert("pdf_password", QJsonValue::Null);
        settingsObj.insert("chunking_mode", "semantic");
        settingsObj.insert("min_paragraph_similarity", 0.50);
        settingsObj.insert("query_text", query);

        QJsonArray sections {
            "abstract","introduction","methods","materials and methods","methodology",
            "results","findings","evaluation","discussion","results and discussion",
            "conclusion","conclusions","summary"
        };
        settingsObj.insert("filter_sections", sections);

        settingsObj.insert("output_dir_auto_create", true);
        rootObj.insert("settings", settingsObj);

        /* ---------------- ARXIV FILES SECTION ---------------- */
        qInfo() << "[Arxiv] Preparing ARXIV entries...";
        for (int i = 0; i < m_articles.size(); i++) {
            QVariantMap &a = m_articles[i];

            QJsonObject obj;
            obj.insert("title", a.value("title").toString());
            obj.insert("pdf", a.value("pdf").toString());
            obj.insert("summary", a.value("summary").toString());

            arxivArray.append(obj);
        }

        rootObj.insert("arxiv_files", arxivArray);

        QJsonArray emptyFiles;
        rootObj.insert("files", emptyFiles);

        QString arxivOut = m_tempFolder + "arxiv_summaries.json";
        rootObj.insert("arxiv_output", arxivOut);

        /* ---------------- SAVE CONFIG FILE ---------------- */
        QString configPath = m_tempFolder + "config_arxiv.json";
        qInfo() << "[Arxiv] Saving config to:" << configPath;

        QFile configFile(configPath);
        if (!configFile.open(QIODevice::WriteOnly)) {
            qWarning() << "[Arxiv] ERROR: Cannot write config file!";
            emit arxivDone();
            return;
        }
        configFile.write(QJsonDocument(rootObj).toJson());
        configFile.close();

        /* ---------------- RUN TOKENIZER PIPELINE ---------------- */
        qInfo() << "[Arxiv] Running tokenizer...";
        QProcess proc;
        proc.setProgram("tokenizer/tokenizer.exe");
        proc.setArguments({configPath});
        proc.start();
        proc.waitForFinished(-1);

        qInfo() << "[Arxiv] Tokenizer finished with code:" << proc.exitCode();
        qInfo() << "[Arxiv] STDOUT:" << proc.readAllStandardOutput();
        qWarning() << "[Arxiv] STDERR:" << proc.readAllStandardError();


        qInfo() << "[Arxiv] Tokenizer finished with code:" << proc.exitCode();

        /* ---------------- READ SELECTED RESULTS ---------------- */
        QFile outFile(arxivOut);
        if (!outFile.open(QIODevice::ReadOnly)) {
            qWarning() << "[Arxiv] ERROR: Cannot open arxiv output file!";
            emit arxivDone();
            return;
        }

        auto json = QJsonDocument::fromJson(outFile.readAll()).object();
        outFile.close();

        QMap<QString, QVariantMap> resultInfoMap;  // key: arxiv_title

        qInfo() << "[Arxiv] Collecting selected results...";

        for (auto rVal : json["results"].toArray()) {
            QJsonObject r = rVal.toObject();

            QString title = r["arxiv_title"].toString();
            if (title.isEmpty()) continue;

            QVariantMap info;
            info["similarity_pct"] = r["similarity_pct"].toDouble();
            info["word_count"] = r["word_count"].toInt();
            info["embedding"] = r["embedding"].toVariant();
            info["chunk"] = r["chunk"].toString();
            info["type"] = r["type"].toString();
            info["chunk_index"] = r["chunk_index"].toInt();

            resultInfoMap.insert(title, info);
        }

        QVector<QVariantMap> newList;
        newList.reserve(m_articles.size());

        qInfo() << "[Arxiv] Merging tokenizer results with article list...";

        for (int i = 0; i < m_articles.size(); i++) {
            QString title = m_articles[i]["title"].toString();

            if (resultInfoMap.contains(title)) {

                QVariantMap info = resultInfoMap.value(title);

                m_articles[i]["embedding"] = info["embedding"];
                m_articles[i]["summary_chunk"] = info["chunk"];
                m_articles[i]["similarity_pct"] = info["similarity_pct"];
                m_articles[i]["word_count"] = info["word_count"];
                m_articles[i]["chunk_index"] = info["chunk_index"];
                m_articles[i]["type"] = info["type"];

                newList.append(m_articles[i]);

                qInfo() << "[Arxiv] Kept:" << title
                        << "similarity:" << info["similarity_pct"].toDouble();

            } else {
                qInfo() << "[Arxiv] Removed (no match):" << title;
            }
        }

        m_articles = newList;
        emit arxivDone();
        qInfo() << "[Arxiv] Processing completed.";

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
void ArxivArticleList::generateEmbeddings(const QString &query) {

    QtConcurrent::run([this, query]() {

        qDebug() << "[Embeddings] Starting embedding generation…";
        qDebug() << "[Embeddings] Query Text =" << query;

        QJsonObject rootObj, settingsObj;
        QJsonArray filesArray;

        // ---------------- SETTINGS ----------------
        qDebug() << "[Settings] Building settings JSON…";

        settingsObj.insert("chunk_words", 300);
        settingsObj.insert("chunk_overlap", 0);
        settingsObj.insert("min_chunk_length", 80);
        settingsObj.insert("semantic_threshold", 0.50);
        settingsObj.insert("embedding_model", "E:/all-mpnet-base-v2");
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
