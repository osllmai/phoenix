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
    connect(m_arxivModel, &ArxivArticleList::arxivDone, this, &DeepSearchConversation::selectesPdfsDone);
    connect(m_arxivModel, &ArxivArticleList::downloadsDone, this, &DeepSearchConversation::downloadPdfsDone);
    connect(m_arxivModel, &ArxivArticleList::embeddingsDone, this, &DeepSearchConversation::embeddingPdfsDone);
    connect(m_arxivModel, &ArxivArticleList::similarityReady, this, &DeepSearchConversation::similarityTextDone);
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
    connect(m_arxivModel, &ArxivArticleList::arxivDone, this, &DeepSearchConversation::selectesPdfsDone);
    connect(m_arxivModel, &ArxivArticleList::downloadsDone, this, &DeepSearchConversation::downloadPdfsDone);
    connect(m_arxivModel, &ArxivArticleList::embeddingsDone, this, &DeepSearchConversation::embeddingPdfsDone);
    connect(m_arxivModel, &ArxivArticleList::similarityReady, this, &DeepSearchConversation::similarityTextDone);
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
        setLogState("Analyzing your question to understand what type of information is needed.");
        classifyQuery();
        break;

    case DeepSearchState::GenerateClarificationQuestions:
        setLogState("Preparing a few short questions to better understand your request.");
        generateClarificationQuestions();
        break;

    case DeepSearchState::WaitingUserClarifications:
        setLogState("Waiting for your answers so we can continue.");
        break;

    case DeepSearchState::GenerateSearchKeywords:
        setLogState("Extracting important keywords from your request to search more effectively.");
        generateSearchKeywords();
        break;

    case DeepSearchState::SearchInSources:
        setLogState("Searching through available sources to collect useful information.");
        startSearchInSources();
        break;

    case DeepSearchState::generateUserIntentSummary:
        setLogState("Summarizing your request to ensure we fully understand your goal.");
        generateUserIntentSummary();
        break;

    case DeepSearchState::SelectesPdfs:
        setLogState("Processing selected documents to prepare them for analysis.");
        m_arxivModel->processSelectedPdfs(m_userSummery);
        break;

    case DeepSearchState::DownloadPdfs:
        setLogState("Downloading the required documents.");
        m_arxivModel->downloadPdfs();
        break;

    case DeepSearchState::EmbeddingPdfs:
        setLogState("Analyzing the downloaded documents and preparing them for deeper understanding.");
        m_arxivModel->generateEmbeddings(m_userSummery);
        break;

    case DeepSearchState::RAGPreparation:
        setLogState("Preparing the most relevant information from documents to answer your request.");
        m_arxivModel->topSimilarChunksAsync(10);
        break;

    case DeepSearchState::SendForTextModel:
        setLogState("Generating a final response based on all gathered information.");
        finalPrompt();
        break;

    case DeepSearchState::Finished:
        setLogState("Search and analysis completed.");
        m_state = DeepSearchState::WaitingPrompt;
        break;

    default:
        setLogState("An unexpected state occurred.");
        break;
    }
}

void DeepSearchConversation::stop(){
    if(stopRequest())
        return;
    setStopRequest(true);
    m_state = DeepSearchState::Finished;
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
