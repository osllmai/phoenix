#include "deepsearchconversation.h"

#include "../../provider/onlineprovider.h"
#include "../../provider/offlineprovider.h"
#include "../../provider/provider.h"

#include "./conversationlist.h"
#include <QQmlEngine>

DeepSearchConversation::DeepSearchConversation(int id, const QString &title, const QString &description, const QString &icon,
                                               const QString type, const QDateTime &date, const bool isPinned, QObject *parent)
    : Conversation(id, title, description, icon, type, date, isPinned, parent)
{
    m_arxivModel = new ArxivArticleList(this);
    connect(m_arxivModel, &ArxivArticleList::arxivDone, this, &DeepSearchConversation::selectesPdfs);
    connect(m_arxivModel, &ArxivArticleList::downloadsDone, this, &DeepSearchConversation::downloadPdfs);
    connect(m_arxivModel, &ArxivArticleList::embeddingsDone, this, &DeepSearchConversation::embeddingPdfs);
    QQmlEngine::setObjectOwnership(m_arxivModel, QQmlEngine::CppOwnership);
}

DeepSearchConversation::DeepSearchConversation(int id, const QString &title, const QString &description, const QString &icon,
                                               const QString type, const QDateTime &date, const bool isPinned,
                                               const bool &stream, const QString &promptTemplate, const QString &systemPrompt,
                                               const double &temperature, const int &topK, const double &topP, const double &minP,
                                               const double &repeatPenalty, const int &promptBatchSize, const int &maxTokens,
                                               const int &repeatPenaltyTokens, const int &contextLength,
                                               const int &numberOfGPULayers , QObject *parent)
    : Conversation(id, title, description, icon, type, date, isPinned, stream, promptTemplate, systemPrompt,
                   temperature, topK, topP, minP, repeatPenalty, promptBatchSize, maxTokens,
                   repeatPenaltyTokens, contextLength, numberOfGPULayers, parent)
{
    m_arxivModel = new ArxivArticleList(this);
    QQmlEngine::setObjectOwnership(m_arxivModel, QQmlEngine::CppOwnership);
}

DeepSearchConversation::~DeepSearchConversation() {
    if (m_arxivModel) {
        m_arxivModel->clearList();
    }
}

void DeepSearchConversation::addMessage(const int id, const QString &text, const QString &fileName, QDateTime date, const QString &icon, bool isPrompt, const int like){
    messageList()->addMessage(id, text, fileName, date, icon, isPrompt, like);
}

void DeepSearchConversation::readMessages(){
    emit requestReadMessages(id());
}

void DeepSearchConversation::prompt(const QString &input, const QString &fileName, const QString &fileInfo){

    switch (m_state) {
    case DeepSearchState::WaitingPrompt:
        m_state = DeepSearchState::ClassifyQuery;
        break;

    case DeepSearchState::WaitingUserClarifications:
        m_state = DeepSearchState::GenerateSearchKeywords;
        break;

    default:
        return;
    }

    m_userQuery = input;
    m_userFileName = fileName;
    m_userFileInfo = fileInfo;

    emit requestInsertMessage(id(), input, fileName, "qrc:/media/image_company/user.svg", true, 0);
    emit requestInsertMessage(id(), "", "", model()->icon(),  false, 0);

    handleState();
}


void DeepSearchConversation::handleState() {
    switch (m_state) {
    case DeepSearchState::ClassifyQuery:
        qCInfo(logDeepSearch) << "Classifying query to decide if external search is needed.";
        classifyQuery();
        break;

    case DeepSearchState::GenerateClarificationQuestions:
        qCInfo(logDeepSearch) << "GenerateClarificationQuestions.";
        generateClarificationQuestions();
        break;

    case DeepSearchState::WaitingUserClarifications:
        qCInfo(logDeepSearch) << "CWaitingUserClarifications.";
        break;

    case DeepSearchState::GenerateSearchKeywords:
        qCInfo(logDeepSearch) << "GenerateSearchKeywords.";
        generateSearchKeywords();
        break;

    case DeepSearchState::SearchInSources:
        qCInfo(logDeepSearch) << "Searching in selected sources.";
        startSearchInSources();
        break;

    case DeepSearchState::generateUserIntentSummary:
        generateUserIntentSummary();
        break;

    case DeepSearchState::SelectesPdfs:
        qCInfo(logDeepSearch) << "Searching in selected sources.";
        m_arxivModel->processSelectedPdfs(m_userSummery);
        break;

    case DeepSearchState::DownloadPdfs:
        qCInfo(logDeepSearch) << "Downloading documents.";
        m_arxivModel->downloadPdfs();
        break;

    case DeepSearchState::EmbeddingPdfs:
        qCInfo(logDeepSearch) << "Downloading documents.";
        m_arxivModel->generateEmbeddings(m_userSummery);
        break;

    case DeepSearchState::RAGPreparation:
        qCInfo(logDeepSearch) << "Preparing RAG context.";
        break;

    case DeepSearchState::SendForTextModel:
        finalPrompt();
        break;

    case DeepSearchState::Finished:
        qCInfo(logDeepSearch) << "DeepSearch finished.";
        m_state = DeepSearchState::WaitingPrompt;
        break;

    default:
        qCWarning(logDeepSearch) << "Unhandled state in handleState.";
        break;
    }
}

void DeepSearchConversation::stop(){
    if(stopRequest())
        return;
    setStopRequest(true);
    provider()->stop();
}

void DeepSearchConversation::loadModel(const int id){

    OfflineModel* offlineModel = OfflineModelList::instance(nullptr)->findModelById(id);
    if(offlineModel != nullptr){
        setModel(offlineModel);
    }

    OnlineCompany* company = OnlineCompanyList::instance(nullptr)->findCompanyById(id);
    if (company) {
        OnlineModel* onlineModel;

        if (company->name() == "Indox Router") {
            OnlineCompany* currentCompanyIndoxRouter = OnlineCompanyList::instance(nullptr)->currentIndoxRouterCompany();
            onlineModel = currentCompanyIndoxRouter->onlineModelList()->currentModel();
            QString modelName = onlineModel->modelName();
            if (!modelName.startsWith("IndoxRouter/")) {
                onlineModel->setModelName("IndoxRouter/" + modelName);
            }
        }else{
            onlineModel = company->onlineModelList()->currentModel();
        }

        if (onlineModel) {
            onlineModel->setKey(company->key());
            setModel(onlineModel);
        }
    }

    setIsModelChanged(true);
}

void DeepSearchConversation::unloadModel(){

    if(responseInProgress() && loadModelInProgress()){
        setIsModelChanged(true);
        return;
    }

    setIsLoadModel(false);
    setLoadModelInProgress(false);

    if(provider() != nullptr){
        //disconnect load and unload model
        disconnect(this, &DeepSearchConversation::requestLoadModel, provider(), &Provider::loadModel);
        disconnect(provider(), &Provider::requestLoadModelResult, this, &DeepSearchConversation::loadModelResult);
        // disconnect(this, &DeepSearchConversation::requestUnLoadModel, m_provider, &Provider::unLoadModel);

        //disconnect prompt
        disconnect(provider(), &Provider::requestTokenResponse, this, &DeepSearchConversation::tokenResponse);

        //disconnect finished response
        disconnect(provider(), &Provider::requestFinishedResponse, this, &DeepSearchConversation::finishedResponse);
        disconnect(this, &DeepSearchConversation::requestStop, provider(), &Provider::stop);
        delete provider();
    }
}

void DeepSearchConversation::loadModelResult(const bool result, const QString &warning){

}

void DeepSearchConversation::tokenResponse(const QString &token){
    setResponseInProgress(true);
    setLoadModelInProgress(false);

    QVariantMap lastMessage;
    QString lastText;

    switch (m_state) {

    case DeepSearchState::WaitingPrompt:
        qInfo() << "State: WaitingPrompt - Still waiting for user input";
        break;

    case DeepSearchState::ClassifyQuery:
        qInfo() << "State: ClassifyQuery" << token;
        if (token.contains("Yes", Qt::CaseInsensitive)) {
            m_selectedSources = DataSource::Arxiv;
            qInfo() << "Classified as Search Query → Searching in sources";
        } else {
            m_selectedSources = DataSource::None;
            qInfo() << "Classified as Local Response → Sending to LLM";
        }
        break;

    case DeepSearchState::GenerateClarificationQuestions:
        qCInfo(logDeepSearch) << "GenerateClarificationQuestions.";
        lastMessage = messageList()->lastMessageInfo();
        lastText = lastMessage["text"].toString();
        emit requestUpdateDescriptionText(id(), lastText);
        messageList()->updateLastMessage(token);
        break;

    case DeepSearchState::GenerateSearchKeywords:
        qInfo() << "Search Keywords: " << token;
        m_searchKeywords = token;
        break;

    case DeepSearchState::SearchInSources:
        qInfo() << "State: SearchInSources - Searching... Token:" << token;
        break;

    case DeepSearchState::generateUserIntentSummary:
        qCInfo(logDeepSearch) << "Searching in selected sources." << token;;
        m_userSummery = token;
        break;

    case DeepSearchState::DownloadPdfs:
        qInfo() << "State: DownloadDocuments - Downloading documents";
        break;

    case DeepSearchState::EmbeddingPdfs:
        qInfo() << "State: DownloadDocuments - Downloading documents";
        break;

    case DeepSearchState::RAGPreparation:
        qInfo() << "State: RAGPreparation - Preparing RAG context";
        break;

    case DeepSearchState::SendForTextModel:
        qInfo() << "State: SendForTextModel - Token:" << token;
        lastMessage = messageList()->lastMessageInfo();
        lastText = lastMessage["text"].toString();
        emit requestUpdateDescriptionText(id(), lastText);
        messageList()->updateLastMessage(token);
        break;

    case DeepSearchState::Finished:
        qInfo() << "State: Finished - Response completed";
        break;

    default:
        qCWarning(logDeepSearch) << "Unhandled state in tokenResponse!";
        break;
    }
}

void DeepSearchConversation::finishedResponse(const QString &warning){
    QVariantMap lastMessage ;

    switch (m_state) {

    case DeepSearchState::WaitingPrompt:
        qInfo() << "State: WaitingPrompt - Still waiting for user input";
        break;

    case DeepSearchState::ClassifyQuery:
        switch (m_selectedSources) {
        case DataSource::None:
            m_state = DeepSearchState::SendForTextModel;
            break;

        case DataSource::Arxiv:
            m_state = DeepSearchState::GenerateClarificationQuestions;
            break;
        default:
            qCWarning(logDeepSearch) << "Unhandled state in handleState.";
            break;
        }
        break;

    case DeepSearchState::GenerateClarificationQuestions:
        qCInfo(logDeepSearch) << "GenerateClarificationQuestions.";
        lastMessage = messageList()->lastMessageInfo();
        if (!lastMessage.isEmpty()) {
            int lastId = lastMessage["id"].toInt();
            QString lastText = lastMessage["text"].toString();

            emit requestUpdateTextMessage(id(), lastId, lastText);
        }
        setResponseInProgress(false);
        setLoadModelInProgress(false);
        setStopRequest(false);

        if(isModelChanged()){
            unloadModel();
            setIsModelChanged(false);
        }

        m_state = DeepSearchState::WaitingUserClarifications;
        break;

    case DeepSearchState::GenerateSearchKeywords:
        m_state = DeepSearchState::SearchInSources;
        break;

    case DeepSearchState::SearchInSources:
        qInfo() << "State: SearchInSources - Searching... Token:";
        break;

    case DeepSearchState::generateUserIntentSummary:
        m_state = DeepSearchState::SelectesPdfs;
        break;

    case DeepSearchState::DownloadPdfs:
        qInfo() << "State: DownloadDocuments - Downloading documents";
        break;

    case DeepSearchState::EmbeddingPdfs:
        qInfo() << "State: DownloadDocuments - Downloading documents";
        break;

    case DeepSearchState::RAGPreparation:
        qInfo() << "State: RAGPreparation - Preparing RAG context";
        break;

    case DeepSearchState::SendForTextModel:
        lastMessage = messageList()->lastMessageInfo();
        if (!lastMessage.isEmpty()) {
            int lastId = lastMessage["id"].toInt();
            QString lastText = lastMessage["text"].toString();

            emit requestUpdateTextMessage(id(), lastId, lastText);
        }
        setResponseInProgress(false);
        setLoadModelInProgress(false);
        setStopRequest(false);

        if(isModelChanged()){
            unloadModel();
            setIsModelChanged(false);
        }

        m_state = DeepSearchState::Finished;
        break;

    case DeepSearchState::Finished:
        qInfo() << "State: Finished - Response completed";
        break;

    default:
        qCWarning(logDeepSearch) << "Unhandled state in tokenResponse!";
        break;
    }
    handleState();
}

void DeepSearchConversation::updateModelSettingsConversation(){
    emit requestUpdateModelSettingsConversation(modelSettings()->id(), modelSettings()->stream(),
                                                modelSettings()->promptTemplate(), modelSettings()->systemPrompt(),
                                                modelSettings()->temperature(), modelSettings()->topK(),
                                                modelSettings()->topP(), modelSettings()->minP(),
                                                modelSettings()->repeatPenalty(), modelSettings()->promptBatchSize(),
                                                modelSettings()->maxTokens(), modelSettings()->repeatPenaltyTokens(),
                                                modelSettings()->contextLength(), modelSettings()->numberOfGPULayers());
}

void DeepSearchConversation::likeMessageRequest( const int messageId, const int like){
    messageList()->likeMessageRequest(messageId, like);
}

void DeepSearchConversation::sendPromptForModel(const QString &input, const bool &stream){
    setIsModelChanged(false);

    if(ConversationList::instance(nullptr)->previousConversation() != nullptr &&
        ConversationList::instance(nullptr)->previousConversation() != ConversationList::instance(nullptr)->currentConversation() &&
        !ConversationList::instance(nullptr)->previousConversation()->loadModelInProgress() &&
        !ConversationList::instance(nullptr)->previousConversation()->responseInProgress() &&
        ConversationList::instance(nullptr)->previousConversation()->isLoadModel()){

        ConversationList::instance(nullptr)->previousConversation()->unloadModel();
    }

    setLoadModelInProgress(true);
    setResponseInProgress(false);

    if(!isLoadModel()){

        if(model()->backend() == BackendType::OfflineModel){
            setProvider(new OfflineProvider(this));
        }else if(model()->backend() == BackendType::OnlineModel){
            qInfo()<<model()->modelName()<<"  "<<model()->key();
            setProvider(new OnlineProvider(this, model()->modelName(),model()->key()));
        }

        //load and unload model
        connect(this, &DeepSearchConversation::requestLoadModel, provider(), &Provider::loadModel, Qt::QueuedConnection);
        connect(provider(), &Provider::requestLoadModelResult, this, &DeepSearchConversation::loadModelResult, Qt::QueuedConnection);
        // connect(this, &DeepSearchConversation::requestUnLoadModel, m_provider, &Provider::unLoadModel, Qt::QueuedConnection);

        //prompt
        connect(provider(), &Provider::requestTokenResponse, this, &DeepSearchConversation::tokenResponse, Qt::QueuedConnection);

        //finished response
        connect(provider(), &Provider::requestFinishedResponse, this, &DeepSearchConversation::finishedResponse, Qt::QueuedConnection);
        connect(this, &DeepSearchConversation::requestStop, provider(), &Provider::stop, Qt::QueuedConnection);

        if(model()->backend() == BackendType::OfflineModel){
            emit requestLoadModel( model()->modelName(), model()->key());
        }

        setIsLoadModel(true);
    }

    qInfo()<<"call promp";
    provider()->prompt(input, stream, modelSettings()->promptTemplate(),
                       modelSettings()->systemPrompt(),modelSettings()->temperature(),modelSettings()->topK(),
                       modelSettings()->topP(),modelSettings()->minP(),modelSettings()->repeatPenalty(),
                       modelSettings()->promptBatchSize(),modelSettings()->maxTokens(),
                       modelSettings()->repeatPenaltyTokens(),modelSettings()->contextLength(),
                       modelSettings()->numberOfGPULayers());
}

void DeepSearchConversation::classifyQuery() {

    QString classifyPrompt = R"(
        You are a classifier. Your job is to decide whether answering the user's question requires
        searching and retrieving up-to-date scientific papers from arXiv or other external sources.

        Guidelines:
        - If the question is about general knowledge, greetings, casual chat, opinions, or widely-known facts → answer: No
        - If the question is a scientific or technical research question that may require recent findings, formulas, datasets, or academic references → answer: Yes

        Output format:
        ONLY respond with exactly one word: "Yes" or "No"

        User Question:
        {{query}}

        Response:
    )";

    QString text_prompt = classifyPrompt;
    text_prompt.replace("{{query}}", m_userQuery);

    sendPromptForModel(text_prompt, false);
}

void DeepSearchConversation::generateClarificationQuestions() {

    QString clarifyPrompt = R"(
        You are an AI assistant specialized in scientific information retrieval.
        Your task is to ask the user clarifying questions ONLY if necessary to perform
        a more accurate scientific deep search.

        Rules:
        - If the user query is unclear, ambiguous, or too broad → ask 2 to 4 clarifying questions
        - If the query is already specific enough → respond with "NO_QUESTIONS_NEEDED"
        - Do NOT answer the original question here
        - Do NOT add explanations
        - Keep questions short and focused

        Output format:
        - If questions needed: each question as a bullet using "-"
        - If not needed: output exactly "NO_QUESTIONS_NEEDED"

        User Query:
        {{query}}

        Response:
    )";

    QString text_prompt = clarifyPrompt;
    text_prompt.replace("{{query}}", m_userQuery);

    sendPromptForModel(text_prompt, modelSettings()->stream());
}

void DeepSearchConversation::generateSearchKeywords() {

    QString keywordPrompt = R"(
        You are an AI system specialized in scientific information retrieval, trained on arXiv structure.

        Your task:
        Generate 5–8 **high-precision scientific search keywords** optimized for arXiv API queries.

        You must deeply analyze:
        • User query
        • Recent dialog context
        • True scientific intent and subfield
        • Relevant arXiv subject-class taxonomy

        === STRICT OUTPUT REQUIREMENTS ===
        Each keyword MUST:
        • Be a real scientific concept, model, architecture, method family, dataset, or mathematical construct
        • Use EXACT terminology found in arXiv papers (NO natural language)
        • Be 1–4 words ONLY
        • Avoid filler words:
          (“methods”, “techniques”, “approach”, “system”, “application”, “introduction”, “study”, “analysis”, “framework”, “performance”)
        • Avoid question patterns (“how to”, “why”, “which”)
        • Avoid vague or generic words (“deep learning”, “machine learning”, “neural network”)
        • Be highly discriminative

        === CATEGORY REQUIREMENTS ===
        Each keyword MUST be assigned a valid arXiv subject class that best matches it:
        Examples:
          cs.CL, cs.LG, cs.CV, cs.IR, cs.AI, stat.ML, math.IT, eess.AS, physics.optics, etc.

        === CONFIDENCE REQUIREMENTS ===
        • confidence ∈ [0.50, 1.00], representing concept relevance

        === INPUT CONTEXT ===
        User Query:
        {{query}}

        Conversation Context (last 2 messages):
        {{history_2}}

        === OUTPUT FORMAT (MANDATORY JSON ONLY) ===
        {
          "keywords": [
            {
              "term": "precise scientific keyword",
              "category": "arXivClass",
              "confidence": 0.0
            }
          ]
        }

        NO extra text. NO comments. NO explanations. JSON ONLY.
    )";



    keywordPrompt.replace("{{query}}", m_userQuery);

    QString history = messageList()->history(2);
    keywordPrompt.replace("{{history_2}}", history);

    sendPromptForModel(keywordPrompt, false);
}

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

void DeepSearchConversation::generateUserIntentSummary()
{
    QString prompt = R"(
        You are an AI assistant specialized in scientific information extraction.

        Your task:
        - Read the user's original query.
        - Read the user's answers to clarification questions (the last few messages).
        - Understand the true intent behind the user's scientific search.
        - Produce a **single, short, precise paragraph** that summarizes the user's actual goal.

        Rules:
        - The output MUST be 1 paragraph only.
        - No bullet points.
        - No explanations.
        - No greetings.
        - Scientific style, concise, embedding-friendly.
        - Focus on key concepts, constraints, domain, and purpose.
        - Avoid unnecessary filler text.

        Input:
        User Query:
        {{query}}

        Recent Conversation:
        {{history}}

        Output:
        (One short paragraph describing the user's exact information need)
    )";

    QString textPrompt = prompt;
    textPrompt.replace("{{query}}", m_userQuery);
    textPrompt.replace("{{history}}", messageList()->history(6));

    sendPromptForModel(textPrompt, false);
}


// void DeepSearchConversation::onSearchResultsReady(QList<QVariantMap> results) {
//     for (const auto &item : results) {
//         m_arxivModel->appendArticle(item); // Your model insert method
//     }

//     qCInfo(logDeepSearch) << "Search completed. Found:" << results.size();
// }

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

void DeepSearchConversation::finalPrompt(){
    switch (m_selectedSources) {
    case DataSource::None:
        sendPromptForModel(m_userQuery, modelSettings()->stream());
        break;

    case DataSource::Arxiv:
        break;
    default:
        qCWarning(logDeepSearch) << "Unhandled state in handleState.";
        break;
    }
}

void DeepSearchConversation::selectesPdfs(){
    m_state = DeepSearchState::DownloadPdfs;
    handleState();
}

void DeepSearchConversation::downloadPdfs(){
    m_state = DeepSearchState::EmbeddingPdfs;
    handleState();
}

void DeepSearchConversation::embeddingPdfs(){
    // m_state = DeepSearchState::SendForTextModel;
    // handleState();
}
