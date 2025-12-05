#include "textconversation.h"

#include "../../provider/onlineprovider.h"
#include "../../provider/offlineprovider.h"
#include "../../provider/provider.h"
#include "../chat/message.h"

#include "./conversationlist.h"

TextConversation::TextConversation(int id, const QString &title, const QString &description, const QString &icon,
                            const QString type, const QDateTime &date, const bool isPinned, QObject *parent)
    : Conversation(id, title, description, icon, type, date, isPinned, parent)
{}

TextConversation::TextConversation(int id, const QString &title, const QString &description, const QString &icon,
                            const QString type, const QDateTime &date, const bool isPinned,
                           const bool &stream, const QString &promptTemplate, const QString &systemPrompt,
                           const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                           const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                           const int &contextLength, const int &numberOfGPULayers , QObject *parent)
    : Conversation(id, title, description, icon, type, date, isPinned, stream, promptTemplate, systemPrompt,
                   temperature, topK, topP, minP, repeatPenalty, promptBatchSize, maxTokens, repeatPenaltyTokens,
                   contextLength, numberOfGPULayers, parent)
{}

TextConversation::~TextConversation() {}

void TextConversation::addMessage(const int id, const QString &text, const QString &fileName, QDateTime date, const QString &icon, bool isPrompt, const int like){
    messageList()->addMessage(id, text, fileName, date, icon, isPrompt, like);
}

void TextConversation::readMessages(){
    emit requestReadMessages(id());
}

void TextConversation::prompt(const QString &input, const QString &fileName, const QString &fileInfo){
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
        connect(this, &TextConversation::requestLoadModel, provider(), &Provider::loadModel, Qt::QueuedConnection);
        connect(provider(), &Provider::requestLoadModelResult, this, &TextConversation::loadModelResult, Qt::QueuedConnection);
        // connect(this, &TextConversation::requestUnLoadModel, m_provider, &Provider::unLoadModel, Qt::QueuedConnection);

        //prompt
        connect(provider(), &Provider::requestTokenResponse, this, &TextConversation::tokenResponse, Qt::QueuedConnection);

        //finished response
        connect(provider(), &Provider::requestFinishedResponse, this, &TextConversation::finishedResponse, Qt::QueuedConnection);
        connect(this, &TextConversation::requestStop, provider(), &Provider::stop, Qt::QueuedConnection);

        if(model()->backend() == BackendType::OfflineModel){
            emit requestLoadModel( model()->modelName(), model()->key());
        }

        setIsLoadModel(true);
    }

    emit requestInsertMessage(id(), input, fileName, "qrc:/media/image_company/user.svg", true, 0);
    emit requestInsertMessage(id(), "", "", model()->icon(),  false, 0);

    qInfo()<<model()->icon();

    QString finalInput = "";

    if(fileInfo != ""){
        finalInput = R"(
                I have extracted the following text from a user's document. Please carefully read and analyze the content.
                Then, based on the user's question at the end, provide a detailed and helpful response.

                Extracted Document Text:
                {{fileInfo}}

                User's Question: {{input}}

                Assistant:
        )";

        finalInput.replace("{{fileInfo}}", fileInfo);
        finalInput.replace("{{input}}", input);

    }else{
        //add history for massage
        finalInput = R"(
                You are a helpful assistant. The following is a conversation history.
                Only consider relevant messages when generating your answer. Ignore unrelated messages.

                Chat History:
                {{history}}

                Current user message:
                User: {{input}}

                Assistant:
        )";

        finalInput.replace("{{history}}", messageList()->history());
        finalInput.replace("{{input}}", input);
    }

    qInfo()<<"call promp";
    provider()->prompt(finalInput, modelSettings()->stream(), modelSettings()->promptTemplate(),
                       modelSettings()->systemPrompt(),modelSettings()->temperature(),modelSettings()->topK(),
                       modelSettings()->topP(),modelSettings()->minP(),modelSettings()->repeatPenalty(),
                       modelSettings()->promptBatchSize(),modelSettings()->maxTokens(),
                       modelSettings()->repeatPenaltyTokens(),modelSettings()->contextLength(),
                       modelSettings()->numberOfGPULayers());
}

void TextConversation::stop(){
    if(stopRequest())
        return;
    setStopRequest(true);
    provider()->stop();
}

void TextConversation::loadModel(const int id){

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

void TextConversation::unloadModel(){

    if(responseInProgress() && loadModelInProgress()){
        setIsModelChanged(true);
        return;
    }

    setIsLoadModel(false);
    setLoadModelInProgress(false);

    if(provider() != nullptr){
        //disconnect load and unload model
        disconnect(this, &TextConversation::requestLoadModel, provider(), &Provider::loadModel);
        disconnect(provider(), &Provider::requestLoadModelResult, this, &TextConversation::loadModelResult);
        // disconnect(this, &TextConversation::requestUnLoadModel, m_provider, &Provider::unLoadModel);

        //disconnect prompt
        disconnect(provider(), &Provider::requestTokenResponse, this, &TextConversation::tokenResponse);

        //disconnect finished response
        disconnect(provider(), &Provider::requestFinishedResponse, this, &TextConversation::finishedResponse);
        disconnect(this, &TextConversation::requestStop, provider(), &Provider::stop);
        delete provider();
    }
}

void TextConversation::loadModelResult(const bool result, const QString &warning){

}

void TextConversation::tokenResponse(const QString &token){
    setResponseInProgress(true);
    setLoadModelInProgress(false);

    QVariantMap lastMessage = messageList()->lastMessageInfo();
    QString lastText = lastMessage["text"].toString();
    emit requestUpdateDescriptionText(id(), lastText);
    messageList()->updateLastMessage(token);
}

void TextConversation::finishedResponse(const QString &warning){
    QVariantMap lastMessage = messageList()->lastMessageInfo();
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
}

void TextConversation::updateModelSettingsConversation(){
    emit requestUpdateModelSettingsConversation(modelSettings()->id(), modelSettings()->stream(),
                                                modelSettings()->promptTemplate(), modelSettings()->systemPrompt(),
                                                modelSettings()->temperature(), modelSettings()->topK(),
                                                modelSettings()->topP(), modelSettings()->minP(),
                                                modelSettings()->repeatPenalty(), modelSettings()->promptBatchSize(),
                                                modelSettings()->maxTokens(), modelSettings()->repeatPenaltyTokens(),
                                                modelSettings()->contextLength(), modelSettings()->numberOfGPULayers());
}

void TextConversation::likeMessageRequest( const int messageId, const int like){
    messageList()->likeMessageRequest(messageId, like);
}
