#include "ArxivArticleList.h"
#include <QDebug>

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
