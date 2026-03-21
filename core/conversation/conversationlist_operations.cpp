#include "conversationlist.h"
#include <algorithm>

void ConversationList::addRequest(const QString &firstPrompt, const QString &fileName, const QString &fileInfo, const QString &converstationType){
    QStringList words = firstPrompt.split(QRegularExpression("\\s+"), Qt::SkipEmptyParts);

    QStringList selectedWords;
    for (const QString &word : words) {
        if (word.length() < 20) {
            selectedWords.append(word);
        }
        if (selectedWords.size() == 3) break;
    }

    QString title = selectedWords.join(" ");

    QString _systemPrompt = "### System:\nYou are an AI assistant who gives a quality response to whatever humans ask of you.\n\n";
    QString _propmtTemplate = "### Human:\n%1\n\n### Assistant:\n";

    if(m_modelSystemPrompt != "")
        _systemPrompt = m_modelSystemPrompt;
    if(m_modelPromptTemplate != "")
        _propmtTemplate = m_modelPromptTemplate;


    emit requestInsertConversation(title, firstPrompt, fileName, fileInfo, QDateTime::currentDateTime(), m_modelIcon, false, converstationType, true,
                                   _propmtTemplate, _systemPrompt, 0.7, 40, 0.4,0.0,1.18,128,4096,64,4096,80, true);

    qInfo()<<"HI Dear";
}

void ConversationList::deleteRequest(const int id){
    Conversation* conversation = findConversationById(id);

    if(conversation->isLoadModel()){
        conversation->unloadModel();
    }

    if(conversation == nullptr) return;
    const int index = m_conversations.indexOf(conversation);


    if(m_currentConversation != nullptr && id == m_currentConversation->id()){
        setIsEmptyConversation(true);
    }
    if(m_previousConversation != nullptr && id == m_previousConversation->id()){
        setPreviousConversation(nullptr);
    }

    beginRemoveRows(QModelIndex(), index, index);
    m_conversations.removeAll(conversation);
    endRemoveRows();

    emit requestDeleteConversation(conversation->id());
    delete conversation;
}

void ConversationList::pinnedRequest(const int id, const bool isPinned){
    Conversation* conversation = findConversationById(id);
    if(conversation == nullptr) return;
    const int index = m_conversations.indexOf(conversation);

    conversation->setIsPinned(isPinned);//update instance
    emit requestUpdateIsPinnedConversation(conversation->id(), isPinned);//update database

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {PinnedRole});
}

void ConversationList::editTitleRequest(const int id, const QString &title){
    Conversation* conversation = findConversationById(id);
    if(conversation == nullptr) return;
    const int index = m_conversations.indexOf(conversation);

    conversation->setTitle(title);//update instance
    emit requestUpdateTitleConversation(conversation->id(), title);//update database

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {TitleRole});
}

void ConversationList::likeMessageRequest(const int conversationId, const int messageId, const int like){
    emit requestUpdateLikeMessage(conversationId, messageId, like);
    Conversation* conversation = findConversationById(conversationId);
    if(conversation == nullptr) return;
    conversation->likeMessageRequest(messageId, like);
}

void ConversationList::setModelRequest(const int id, const QString &name,  const QString &icon, const QString &promptTemplate, const QString &systemPrompt){
    setModelId(id);
    setModelName(name);
    setModelIcon(icon);
    setModelPromptTemplate(promptTemplate);
    setModelSystemPrompt(systemPrompt);
    if(id == -1)
        setModelSelect(false);
    else
        setModelSelect(true);

    if(!m_isEmptyConversation){
        if(m_modelPromptTemplate != "")
            m_currentConversation->modelSettings()->setPromptTemplate(m_modelPromptTemplate);
        if(m_modelSystemPrompt != "")
            m_currentConversation->modelSettings()->setSystemPrompt(m_modelSystemPrompt);
        m_currentConversation->loadModel(id);
    }

    if(previousConversation() != nullptr &&
        previousConversation() != currentConversation() &&
        !previousConversation()->loadModelInProgress() &&
        !previousConversation()->responseInProgress() &&
        previousConversation()->isLoadModel()){

        previousConversation()->unloadModel();
    }
}

void ConversationList::addConversation(const int id, const QString &title, const QString &description, const QString &fileName,
                                       const QString &fileInfo, const QDateTime date, const QString &icon,
                                       const bool isPinned, const QString &type, const bool &stream, const QString &promptTemplate, const QString &systemPrompt,
                                       const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                       const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                       const int &contextLength, const int &numberOfGPULayers, const bool selectConversation) {
    const int index = m_conversations.size();
    beginInsertRows(QModelIndex(), index, index);

    Conversation* conversation;
    if(type == "Deep research"){
        conversation = new DeepSearchConversation(id, title, description, icon, type, date, isPinned,
                                        stream, promptTemplate, systemPrompt,
                                        temperature, topK, topP, minP, repeatPenalty,
                                        promptBatchSize, maxTokens, repeatPenaltyTokens,
                                        contextLength, numberOfGPULayers, this);
        m_conversations.append(conversation);
        connect(conversation, &DeepSearchConversation::requestReadMessages, this, &ConversationList::readMessages, Qt::QueuedConnection);
        connect(conversation, &DeepSearchConversation::requestInsertMessage, this, &ConversationList::insertMessage, Qt::QueuedConnection);
        connect(conversation, &DeepSearchConversation::requestUpdateDateConversation, this, &ConversationList::updateDateConversation, Qt::QueuedConnection);
        connect(conversation, &DeepSearchConversation::requestUpdateModelSettingsConversation, this, &ConversationList::updateModelSettingsConversation, Qt::QueuedConnection);
        connect(conversation, &DeepSearchConversation::requestUpdateTextMessage, this, &ConversationList::updateTextMessage, Qt::QueuedConnection);
        connect(conversation, &DeepSearchConversation::requestUpdateDescriptionText, this, &ConversationList::updateDescriptionText, Qt::QueuedConnection);
    }else {
        conversation = new TextConversation(id, title, description, icon, type, date, isPinned,
                                                      stream, promptTemplate, systemPrompt,
                                                      temperature, topK, topP, minP, repeatPenalty,
                                                      promptBatchSize, maxTokens, repeatPenaltyTokens,
                                                      contextLength, numberOfGPULayers, this);
        m_conversations.append(conversation);
        connect(conversation, &TextConversation::requestReadMessages, this, &ConversationList::readMessages, Qt::QueuedConnection);
        connect(conversation, &TextConversation::requestInsertMessage, this, &ConversationList::insertMessage, Qt::QueuedConnection);
        connect(conversation, &TextConversation::requestUpdateDateConversation, this, &ConversationList::updateDateConversation, Qt::QueuedConnection);
        connect(conversation, &TextConversation::requestUpdateModelSettingsConversation, this, &ConversationList::updateModelSettingsConversation, Qt::QueuedConnection);
        connect(conversation, &TextConversation::requestUpdateTextMessage, this, &ConversationList::updateTextMessage, Qt::QueuedConnection);
        connect(conversation, &TextConversation::requestUpdateDescriptionText, this, &ConversationList::updateDescriptionText, Qt::QueuedConnection);
    }
    endInsertRows();
    emit countChanged();

    if(selectConversation){

        if((m_currentConversation != nullptr) && m_currentConversation->isLoadModel())
            setPreviousConversation(m_currentConversation);

        setCurrentConversation(conversation);

        m_currentConversation->loadModel(modelId());
        m_currentConversation->prompt(description, fileName, fileInfo);

        setIsEmptyConversation(false);
    }
}

void ConversationList::addMessage(const int conversationId, const int id, const QString &text, const QString &fileName, QDateTime date, const QString &icon, bool isPrompt, const int like){
    Conversation* conversation = findConversationById(conversationId);
    if(conversation == nullptr) return;
    const int index = m_conversations.indexOf(conversation);
    conversation->addMessage(id, text, fileName, date, icon, isPrompt, like);
    conversation->setDescription(text);
    conversation->setDate(date);
    conversation->setIcon(icon);
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DescriptionRole, IconRole, DateRole});
}

void ConversationList::updateDescriptionText(const int conversationId, const QString &text){
    Conversation* conversation = findConversationById(conversationId);
    if(conversation == nullptr) return;
    const int index = m_conversations.indexOf(conversation);
    conversation->setDescription(text);
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DescriptionRole});
}

void ConversationList::selectCurrentConversationRequest(const int id){
    Conversation* conversation = findConversationById(id);
    if(conversation == nullptr) return;

    if(previousConversation() != nullptr &&
        previousConversation() != currentConversation() &&
        !previousConversation()->loadModelInProgress() &&
        !previousConversation()->responseInProgress() &&
        previousConversation()->isLoadModel()){

        previousConversation()->unloadModel();
    }

    if((m_currentConversation != nullptr) && m_currentConversation->isLoadModel())
        setPreviousConversation(m_currentConversation);

    setCurrentConversation(conversation);
    if(m_currentConversation->messageList()->count()<1)
        m_currentConversation->readMessages();
    setIsEmptyConversation(false);
    if(m_modelSelect){
        if(m_modelPromptTemplate != "")
            m_currentConversation->modelSettings()->setPromptTemplate(m_modelPromptTemplate);
        if(m_modelSystemPrompt != "")
            m_currentConversation->modelSettings()->setSystemPrompt(m_modelSystemPrompt);
        m_currentConversation->loadModel(modelId());
    }
}

void ConversationList::readMessages(const int conversationId){
    emit requestReadMessages(conversationId);
}

void ConversationList::insertMessage(const int conversationId, const QString &text, const QString &fileName, const QString &icon, bool isPrompt, const int like){
    emit requestInsertMessage(conversationId, text, fileName, icon, isPrompt, like);
}

void ConversationList::updateTextMessage(const int conversationId, const int messageId, const QString &text){
    emit requestUpdateTextMessage(conversationId, messageId, text);
    Conversation* conversation = findConversationById(conversationId);
    if(conversation == nullptr) return;
    const int index = m_conversations.indexOf(conversation);
    conversation->setDescription(text);
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DescriptionRole});
}

void ConversationList::updateDateConversation(const int id, const QString &description, const QString &icon){
    emit requestUpdateDateConversation(id, description, icon);
}

void ConversationList::updateModelSettingsConversation(const int id, const bool &stream,
                                                       const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                                                       const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                                       const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                                       const int &contextLength, const int &numberOfGPULayers)
{
    emit requestUpdateModelSettingsConversation(id, stream, promptTemplate, systemPrompt, temperature,
                                                topK, topP, minP, repeatPenalty, promptBatchSize, maxTokens, repeatPenaltyTokens,
                                                contextLength, numberOfGPULayers);
}
