#include "conversation.h"

Conversation::Conversation(int id, const QString &title, const QString &description, const QString &icon,
                           const QDateTime &date, const bool isPinned, QObject *parent)
    : QObject(parent), m_id(id), m_title(title), m_description(description),
    m_icon(icon), m_date(date), m_isPinned(isPinned),  m_isLoadModel(false),
    m_loadModelInProgress(false), m_responseInProgress(false),
    m_model(new Model(this)), m_modelSettings(new ModelSettings(id,this)),m_messageList(new MessageList(this)),
    m_responseList(new ResponseList(this))
{}

Conversation::~Conversation() {}

const int Conversation::id() const {return m_id;}

const QString &Conversation::title() const {return m_title;}
void Conversation::setTitle(const QString &title) {
    if (m_title != title) {
        m_title = title;
        emit titleChanged();
    }
}

const QString &Conversation::description() const {return m_description;}

const QDateTime Conversation::date() const {return m_date;}

const QString Conversation::icon() const{return m_icon;}

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

void Conversation::addMessage(const int id, const QString &text, QDateTime date, const QString &icon, bool isPrompt){
    m_messageList->addMessage(id, text, date, icon, isPrompt);
}

void Conversation::readMessages(){
    emit requestReadMessages(m_id);
}

void Conversation::prompt(const QString &input, const int idModel){
    if(!m_isLoadModel){
        loadModel(idModel);
    }
    emit requestInsertMessage(m_id, input, "qrc:/media/image_company/"+m_model->icon(), true);
}

void Conversation::stop(){

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
