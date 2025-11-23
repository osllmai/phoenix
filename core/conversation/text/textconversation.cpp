#include "textconversation.h"

#include "./provider/onlineprovider.h"
#include "./provider/offlineprovider.h"
#include "./provider/provider.h"
#include "./chat/message.h"

#include "./conversationlist.h"

TextConversation::TextConversation(int id, const QString &title, const QString &description, const QString &icon,
                           const QDateTime &date, const bool isPinned, QObject *parent)
    : QObject(parent), m_id(id), m_title(title), m_description(description),
    m_icon(icon), m_date(date), m_isPinned(isPinned),  m_isLoadModel(false),
    m_loadModelInProgress(false), m_responseInProgress(false),
    m_model(new Model(this)), m_modelSettings(new ModelSettings(id,this)),m_messageList(new MessageList(this)),
    m_responseList(new ResponseList(this)), m_provider(nullptr), m_stopRequest(false)
{
    connect(m_modelSettings, &ModelSettings::streamChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::promptTemplateChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::systemPromptChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::temperatureChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::topKChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::topPChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::minPChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::repeatPenaltyChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::promptBatchSizeChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::maxTokensChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::repeatPenaltyTokensChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::contextLengthChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::numberOfGPULayersChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
}

TextConversation::TextConversation(int id, const QString &title, const QString &description, const QString &icon,
                           const QDateTime &date, const bool isPinned,
                           const bool &stream, const QString &promptTemplate, const QString &systemPrompt,
                           const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                           const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                           const int &contextLength, const int &numberOfGPULayers , QObject *parent)
    : QObject(parent),
    m_id(id),
    m_title(title),
    m_description(description),
    m_icon(icon),
    m_date(date),
    m_isPinned(isPinned),
    m_isLoadModel(false),
    m_loadModelInProgress(false),
    m_responseInProgress(false),
    m_model(new Model(this)),
    m_modelSettings(new ModelSettings(id, stream, promptTemplate, systemPrompt,
                                      temperature, topK, topP, minP, repeatPenalty,
                                      promptBatchSize, maxTokens, repeatPenaltyTokens,
                                      contextLength, numberOfGPULayers, this)),
    m_messageList(new MessageList(this)),
    m_responseList(new ResponseList(this)),
    m_provider(nullptr), m_stopRequest(false)
{
    connect(m_modelSettings, &ModelSettings::streamChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::promptTemplateChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::systemPromptChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::temperatureChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::topKChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::topPChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::minPChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::repeatPenaltyChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::promptBatchSizeChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::maxTokensChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::repeatPenaltyTokensChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::contextLengthChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::numberOfGPULayersChanged, this, &TextConversation::updateModelSettingsConversation, Qt::QueuedConnection);
}

TextConversation::~TextConversation() {
    disconnect(m_modelSettings, &ModelSettings::streamChanged, this, &TextConversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::promptTemplateChanged, this, &TextConversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::systemPromptChanged, this, &TextConversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::temperatureChanged, this, &TextConversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::topKChanged, this, &TextConversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::topPChanged, this, &TextConversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::minPChanged, this, &TextConversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::repeatPenaltyChanged, this, &TextConversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::promptBatchSizeChanged, this, &TextConversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::maxTokensChanged, this, &TextConversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::repeatPenaltyTokensChanged, this, &TextConversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::contextLengthChanged, this, &TextConversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::numberOfGPULayersChanged, this, &TextConversation::updateModelSettingsConversation);
}

void TextConversation::addMessage(const int id, const QString &text, const QString &fileName, QDateTime date, const QString &icon, bool isPrompt, const int like){
    m_messageList->addMessage(id, text, fileName, date, icon, isPrompt, like);
}

void TextConversation::readMessages(){
    emit requestReadMessages(m_id);
}

void TextConversation::prompt(const QString &input, const QString &fileName, const QString &fileInfo){
    m_isModelChanged = false;

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

        if(m_model->backend() == BackendType::OfflineModel){
            m_provider = new OfflineProvider(this);
        }else if(m_model->backend() == BackendType::OnlineModel){
            qInfo()<<m_model->modelName()<<"  "<<m_model->key();
            m_provider = new OnlineProvider(this, m_model->modelName(),m_model->key());
        }

        //load and unload model
        connect(this, &TextConversation::requestLoadModel, m_provider, &Provider::loadModel, Qt::QueuedConnection);
        connect(m_provider, &Provider::requestLoadModelResult, this, &TextConversation::loadModelResult, Qt::QueuedConnection);
        // connect(this, &TextConversation::requestUnLoadModel, m_provider, &Provider::unLoadModel, Qt::QueuedConnection);

        //prompt
        connect(m_provider, &Provider::requestTokenResponse, this, &TextConversation::tokenResponse, Qt::QueuedConnection);

        //finished response
        connect(m_provider, &Provider::requestFinishedResponse, this, &TextConversation::finishedResponse, Qt::QueuedConnection);
        connect(this, &TextConversation::requestStop, m_provider, &Provider::stop, Qt::QueuedConnection);

        if(m_model->backend() == BackendType::OfflineModel){
            emit requestLoadModel( m_model->modelName(), m_model->key());
        }

        setIsLoadModel(true);
    }

    emit requestInsertMessage(m_id, input, fileName, "qrc:/media/image_company/user.svg", true, 0);
    emit requestInsertMessage(m_id, "", "", m_model->icon(),  false, 0);

    qInfo()<<m_model->icon();

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

        finalInput.replace("{{history}}", m_messageList->history());
        finalInput.replace("{{input}}", input);
    }

    qInfo()<<"call promp";
    m_provider->prompt(finalInput, m_modelSettings->stream(), m_modelSettings->promptTemplate(),
                       m_modelSettings->systemPrompt(),m_modelSettings->temperature(),m_modelSettings->topK(),
                       m_modelSettings->topP(),m_modelSettings->minP(),m_modelSettings->repeatPenalty(),
                       m_modelSettings->promptBatchSize(),m_modelSettings->maxTokens(),
                       m_modelSettings->repeatPenaltyTokens(),m_modelSettings->contextLength(),
                       m_modelSettings->numberOfGPULayers());
}

void TextConversation::stop(){
    if(m_stopRequest)
        return;
    m_stopRequest = true;
    m_provider->stop();
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

    m_isModelChanged = true;
}

void TextConversation::unloadModel(){

    if(responseInProgress() && loadModelInProgress()){
        m_isModelChanged = true;
        return;
    }

    setIsLoadModel(false);
    setLoadModelInProgress(false);

    if(m_provider != nullptr){
        //disconnect load and unload model
        disconnect(this, &TextConversation::requestLoadModel, m_provider, &Provider::loadModel);
        disconnect(m_provider, &Provider::requestLoadModelResult, this, &TextConversation::loadModelResult);
        // disconnect(this, &TextConversation::requestUnLoadModel, m_provider, &Provider::unLoadModel);

        //disconnect prompt
        disconnect(m_provider, &Provider::requestTokenResponse, this, &TextConversation::tokenResponse);

        //disconnect finished response
        disconnect(m_provider, &Provider::requestFinishedResponse, this, &TextConversation::finishedResponse);
        disconnect(this, &TextConversation::requestStop, m_provider, &Provider::stop);
        delete m_provider;
    }
}

void TextConversation::loadModelResult(const bool result, const QString &warning){

}

void TextConversation::tokenResponse(const QString &token){
    setResponseInProgress(true);
    setLoadModelInProgress(false);

    QVariantMap lastMessage = messageList()->lastMessageInfo();
    QString lastText = lastMessage["text"].toString();
    emit requestUpdateDescriptionText(m_id, lastText);
    messageList()->updateLastMessage(token);
}

void TextConversation::finishedResponse(const QString &warning){
    QVariantMap lastMessage = messageList()->lastMessageInfo();
    if (!lastMessage.isEmpty()) {
        int lastId = lastMessage["id"].toInt();
        QString lastText = lastMessage["text"].toString();

        emit requestUpdateTextMessage(m_id, lastId, lastText);
    }
    setResponseInProgress(false);
    setLoadModelInProgress(false);
    m_stopRequest = false;

    if(m_isModelChanged ){
        unloadModel();
        m_isModelChanged = false;
    }
}

void TextConversation::updateModelSettingsConversation(){
    emit requestUpdateModelSettingsConversation(m_modelSettings->id(), m_modelSettings->stream(),
                                                m_modelSettings->promptTemplate(), m_modelSettings->systemPrompt(),
                                                m_modelSettings->temperature(), m_modelSettings->topK(),
                                                m_modelSettings->topP(), m_modelSettings->minP(),
                                                m_modelSettings->repeatPenalty(), m_modelSettings->promptBatchSize(),
                                                m_modelSettings->maxTokens(), m_modelSettings->repeatPenaltyTokens(),
                                                m_modelSettings->contextLength(), m_modelSettings->numberOfGPULayers());
}

void TextConversation::likeMessageRequest( const int messageId, const int like){
    m_messageList->likeMessageRequest(messageId, like);
}


const int TextConversation::id() const {return m_id;}

const QString &TextConversation::title() const {return m_title;}
void TextConversation::setTitle(const QString &title) {
    if (m_title != title) {
        m_title = title;
        emit titleChanged();
    }
}

const QString &TextConversation::description() const { return m_description; }
void TextConversation::setDescription(const QString &description) {
    if (m_description != description) {
        m_description = description;
        emit descriptionChanged();
    }
}

const QDateTime TextConversation::date() const { return m_date; }
void TextConversation::setDate(QDateTime date) {
    if (m_date != date) {
        m_date = date;
        emit dateChanged();
    }
}

const QString TextConversation::icon() const { return m_icon; }
void TextConversation::setIcon(const QString &icon) {
    if (m_icon != icon) {
        m_icon = icon;
        emit iconChanged();
    }
}

const bool TextConversation::isPinned() const{return m_isPinned;}
void TextConversation::setIsPinned(bool isPinned){
    if (m_isPinned != isPinned) {
        m_isPinned = isPinned;
        emit isPinnedChanged();
    }
}

const bool TextConversation::isLoadModel() const {return m_isLoadModel;}
void TextConversation::setIsLoadModel(bool isLoadModel) {
    if (m_isLoadModel != isLoadModel) {
        m_isLoadModel = isLoadModel;
        emit isLoadModelChanged();
    }
}

const bool TextConversation::loadModelInProgress() const {return m_loadModelInProgress;}
void TextConversation::setLoadModelInProgress(bool inProgress) {
    if (m_loadModelInProgress != inProgress) {
        m_loadModelInProgress = inProgress;
        emit loadModelInProgressChanged();
    }
}

const bool TextConversation::responseInProgress() const {return m_responseInProgress;}
void TextConversation::setResponseInProgress(bool inProgress) {
    if (m_responseInProgress != inProgress) {
        m_responseInProgress = inProgress;
        emit responseInProgressChanged();
    }
}

MessageList* TextConversation::messageList() {return m_messageList;}

Model* TextConversation::model() {return m_model;}
void TextConversation::setModel(Model *model) {
    if (m_model != model) {
        m_model = model;
        emit modelChanged();
    }
}

ModelSettings* TextConversation::modelSettings() {return m_modelSettings;}

ResponseList *Conversation::responseList() const{return m_responseList;}

