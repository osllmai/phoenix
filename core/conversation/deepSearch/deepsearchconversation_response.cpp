#include "deepsearchconversation.h"

#include "../../provider/onlineprovider.h"
#include "../../provider/offlineprovider.h"
#include "../../provider/provider.h"

#include "./conversationlist.h"

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
