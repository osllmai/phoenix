#include "conversation.h"

#include "./provider/onlineprovider.h"
#include "./provider/provider.h"

Conversation::Conversation(int id, const QString &title, const QString &description, const QString &icon,
                           const QDateTime &date, const bool isPinned, QObject *parent)
    : QObject(parent), m_id(id), m_title(title), m_description(description),
    m_icon(icon), m_date(date), m_isPinned(isPinned),  m_isLoadModel(false),
    m_loadModelInProgress(false), m_responseInProgress(false),
    m_model(new Model(this)), m_modelSettings(new ModelSettings(id,this)),m_messageList(new MessageList(this)),
    m_responseList(new ResponseList(this)), m_provider(nullptr), m_currentResponse("")
{
    connect(m_modelSettings, &ModelSettings::streamChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::promptTemplateChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::systemPromptChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::temperatureChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::topKChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::topPChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::minPChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::repeatPenaltyChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::promptBatchSizeChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::maxTokensChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::repeatPenaltyTokensChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::contextLengthChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::numberOfGPULayersChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
}

Conversation::Conversation(int id, const QString &title, const QString &description, const QString &icon,
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
    m_provider(nullptr),
    m_currentResponse("")
{
    connect(m_modelSettings, &ModelSettings::streamChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::promptTemplateChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::systemPromptChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::temperatureChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::topKChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::topPChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::minPChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::repeatPenaltyChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::promptBatchSizeChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::maxTokensChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::repeatPenaltyTokensChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::contextLengthChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
    connect(m_modelSettings, &ModelSettings::numberOfGPULayersChanged, this, &Conversation::updateModelSettingsConversation, Qt::QueuedConnection);
}

Conversation::~Conversation() {
    disconnect(m_modelSettings, &ModelSettings::streamChanged, this, &Conversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::promptTemplateChanged, this, &Conversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::systemPromptChanged, this, &Conversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::temperatureChanged, this, &Conversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::topKChanged, this, &Conversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::topPChanged, this, &Conversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::minPChanged, this, &Conversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::repeatPenaltyChanged, this, &Conversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::promptBatchSizeChanged, this, &Conversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::maxTokensChanged, this, &Conversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::repeatPenaltyTokensChanged, this, &Conversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::contextLengthChanged, this, &Conversation::updateModelSettingsConversation);
    disconnect(m_modelSettings, &ModelSettings::numberOfGPULayersChanged, this, &Conversation::updateModelSettingsConversation);
}

const int Conversation::id() const {return m_id;}

const QString &Conversation::title() const {return m_title;}
void Conversation::setTitle(const QString &title) {
    if (m_title != title) {
        m_title = title;
        emit titleChanged();
    }
}

const QString &Conversation::description() const { return m_description; }
void Conversation::setDescription(const QString &description) {
    if (m_description != description) {
        m_description = description;
        emit descriptionChanged();
    }
}

const QDateTime Conversation::date() const { return m_date; }
void Conversation::setDate(QDateTime date) {
    if (m_date != date) {
        m_date = date;
        emit dateChanged();
    }
}

const QString Conversation::icon() const { return m_icon; }
void Conversation::setIcon(const QString &icon) {
    if (m_icon != icon) {
        m_icon = icon;
        emit iconChanged();
    }
}

const bool Conversation::isPinned() const{return m_isPinned;}
void Conversation::setIsPinned(bool isPinned){
    if (m_isPinned != isPinned) {
        m_isPinned = isPinned;
        emit isPinnedChanged();
    }
}

const bool Conversation::isLoadModel() const {return m_isLoadModel;}
void Conversation::setIsLoadModel(bool isLoadModel) {
    if (m_isLoadModel != isLoadModel) {
        m_isLoadModel = isLoadModel;
        emit isLoadModelChanged();
    }
}

const bool Conversation::loadModelInProgress() const {return m_loadModelInProgress;}
void Conversation::setLoadModelInProgress(bool inProgress) {
    if (m_loadModelInProgress != inProgress) {
        m_loadModelInProgress = inProgress;
        emit loadModelInProgressChanged();
    }
}

const bool Conversation::responseInProgress() const {return m_responseInProgress;}
void Conversation::setResponseInProgress(bool inProgress) {
    if (m_responseInProgress != inProgress) {
        m_responseInProgress = inProgress;
        emit responseInProgressChanged();
    }
}

MessageList* Conversation::messageList() {return m_messageList;}

Model* Conversation::model() {return m_model;}
void Conversation::setModel(Model *model) {
    if (m_model != model) {
        m_model = model;
        emit modelChanged();
        setLoadModelInProgress(true);
    }
}

ModelSettings* Conversation::modelSettings() {return m_modelSettings;}

ResponseList *Conversation::responseList() const{return m_responseList;}

void Conversation::addMessage(const int id, const QString &text, QDateTime date, const QString &icon, bool isPrompt, const int like){
    m_messageList->addMessage(id, text, date, icon, isPrompt, like);
    setCurrentResponse("");
}

void Conversation::readMessages(){
    emit requestReadMessages(m_id);
}

void Conversation::prompt(const QString &input, const int idModel){
    if(!m_isLoadModel){
        loadModel(idModel);
        setIsLoadModel(true);
        if(m_model->backend() == BackendType::OfflineModel){

        }else if(m_model->backend() == BackendType::OnlineModel){
            if(m_provider != nullptr){
                //disconnect load and unload model
                disconnect(this, &Conversation::requestLoadModel, m_provider, &Provider::loadModel);
                disconnect(m_provider, &Provider::requestLoadModelResult, this, &Conversation::loadModelResult);
                disconnect(this, &Conversation::requestUnLoadModel, m_provider, &Provider::unLoadModel);

                //disconnect prompt
                disconnect(m_provider, &Provider::requestTokenResponse, this, &Conversation::tokenResponse);

                //disconnect finished response
                disconnect(m_provider, &Provider::requestFinishedResponse, this, &Conversation::finishedResponse);
                disconnect(this, &Conversation::requestStop, m_provider, &Provider::stop);
                delete m_provider;
            }

            m_provider = new OnlineProvider(this);
            m_provider->loadModel((m_model->company()->name() + "/" + m_model->modelName()), m_model->key());
            qInfo()<<(m_model->company()->name() + "/" + m_model->modelName())<<"  "<<m_model->key();

            // //load and unload model
            connect(this, &Conversation::requestLoadModel, m_provider, &Provider::loadModel, Qt::QueuedConnection);
            connect(m_provider, &Provider::requestLoadModelResult, this, &Conversation::loadModelResult, Qt::QueuedConnection);
            connect(this, &Conversation::requestUnLoadModel, m_provider, &Provider::unLoadModel, Qt::QueuedConnection);

            //prompt
            connect(m_provider, &Provider::requestTokenResponse, this, &Conversation::tokenResponse, Qt::QueuedConnection);

            //finished response
            connect(m_provider, &Provider::requestFinishedResponse, this, &Conversation::finishedResponse, Qt::QueuedConnection);
            connect(this, &Conversation::requestStop, m_provider, &Provider::stop, Qt::QueuedConnection);

        }
    }
    if(idModel != m_model->id()){
        m_provider->loadModel(m_model->company()->name() + "/" + m_model->modelName(),m_model->key());
        qInfo()<<(m_model->company()->name() + "/" + m_model->modelName())<<"  "<<m_model->key();
    }

    emit requestInsertMessage(m_id, input, "qrc:/media/image_company/user.svg", true, 0);

    setResponseInProgress(true);
    m_provider->prompt(input, m_modelSettings->stream(), m_modelSettings->promptTemplate(),
                        m_modelSettings->systemPrompt(),m_modelSettings->temperature(),m_modelSettings->topK(),
                        m_modelSettings->topP(),m_modelSettings->minP(),m_modelSettings->repeatPenalty(),
                        m_modelSettings->promptBatchSize(),m_modelSettings->maxTokens(),
                       m_modelSettings->repeatPenaltyTokens(),m_modelSettings->contextLength(),
                       m_modelSettings->numberOfGPULayers());
}

void Conversation::stop(){
    qInfo()<<"Stop";
}

void Conversation::loadModel(const int id){
    OfflineModel* offlineModel = OfflineModelList::instance(nullptr)->findModelById(id);
    if(offlineModel != nullptr){
        setModel(offlineModel);
    }
    OnlineModel* onlineModel = OnlineModelList::instance(nullptr)->findModelById(id);
    if(onlineModel != nullptr){
        setModel(onlineModel);
    }
}

void Conversation::unloadModel(){

}

void Conversation::loadModelResult(const bool result, const QString &warning){

}

void Conversation::tokenResponse(const QString &token){
    if(m_isLoadModel && m_responseInProgress){
        setCurrentResponse(m_currentResponse + token);
        emit requestUpadateCurrentResponse(m_id);
    }
}

void Conversation::finishedResponse(const QString &warning){
    emit requestInsertMessage(m_id, m_currentResponse, "qrc:/media/image_company/" + m_model->icon(), false, 0);
    setResponseInProgress(false);
}

void Conversation::updateModelSettingsConversation(){
    emit requestUpdateModelSettingsConversation(m_modelSettings->id(), m_modelSettings->stream(),
                                                m_modelSettings->promptTemplate(), m_modelSettings->systemPrompt(),
                                                m_modelSettings->temperature(), m_modelSettings->topK(),
                                                m_modelSettings->topP(), m_modelSettings->minP(),
                                                m_modelSettings->repeatPenalty(), m_modelSettings->promptBatchSize(),
                                                m_modelSettings->maxTokens(), m_modelSettings->repeatPenaltyTokens(),
                                                m_modelSettings->contextLength(), m_modelSettings->numberOfGPULayers());
}

QString Conversation::currentResponse() const{return m_currentResponse;}
void Conversation::setCurrentResponse(const QString &newCurrentResponse){
    if (m_currentResponse == newCurrentResponse)
        return;
    m_currentResponse = newCurrentResponse;
    emit currentResponseChanged();
}
