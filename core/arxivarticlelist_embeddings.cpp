#include "ArxivArticleList.h"
#include <QDebug>

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

                allChunks.append({sim, text, pdfPath, foundTitle, foundLink});
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
