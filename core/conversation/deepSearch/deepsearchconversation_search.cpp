#include "deepsearchconversation.h"

void DeepSearchConversation::startSearchInSources() {

    QThread *thread = new QThread;
    ArxivSearchWorker *worker = new ArxivSearchWorker(m_searchKeywords);

    worker->moveToThread(thread);

    connect(thread, &QThread::started, worker, &ArxivSearchWorker::process);
    connect(worker, &ArxivSearchWorker::searchFinished, this, &DeepSearchConversation::onSearchResultsReady);
    // connect(worker, &ArxivSearchWorker::searchFinished, thread, &QThread::quit);
    // connect(worker, &ArxivSearchWorker::searchFinished, worker, &QObject::deleteLater);
    connect(thread, &QThread::finished, thread, &QObject::deleteLater);

    thread->start();
}

void DeepSearchConversation::onSearchResultsReady(QList<QVariantMap> results) {

    if (results.isEmpty()) {
        qCWarning(logDeepSearch) << " No search results retrieved.";
        return;
    }

    qCInfo(logDeepSearch) << " Search completed. Results count:" << results.size();

    int index = 0;
    for (const auto &item : results) {
        QString title = item.value("title").toString();
        QString authors = item.value("authors").toString();
        QString link = item.value("link").toString();

        qCInfo(logDeepSearch)
            << QString(" [%1] Title: %2").arg(index).arg(title);

        qCInfo(logDeepSearch)
            << QString(" Authors: %1").arg(authors);

        qCInfo(logDeepSearch)
            << QString(" summary: %1").arg(item.value("summary").toString());

        qCInfo(logDeepSearch)
            << QString(" Link: %1").arg(link);

        qCInfo(logDeepSearch)
            << QString(" pdf: %1").arg(item.value("pdf").toString());

        qCInfo(logDeepSearch)
            << QString(" published: %1").arg(item.value("published").toString());

        m_arxivModel->appendArticle(item);
        index++;
    }

    qCInfo(logDeepSearch) << " All results added to model for UI display.";

    m_state = DeepSearchState::generateUserIntentSummary;
    handleState();
}

void DeepSearchConversation::selectesPdfsDone(){
    qCInfo(logDeepSearch) << "Searching in selected sources.";
    m_state = DeepSearchState::DownloadPdfs;
    handleState();
}

void DeepSearchConversation::downloadPdfsDone(){
    m_state = DeepSearchState::EmbeddingPdfs;
    handleState();
}

void DeepSearchConversation::embeddingPdfsDone(){
    m_state = DeepSearchState::RAGPreparation;
    handleState();
}

void DeepSearchConversation::similarityTextDone(const QVariantList &results){
    m_results = results;
    m_state = DeepSearchState::SendForTextModel;
    handleState();
}
