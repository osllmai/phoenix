#include "chat.h"

#include <QtSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include "database.h"
#include <model.h>

Chat::Chat(const int &id, const QString &title, const QDateTime date , Message* root, QObject *parent) :
    QObject(parent), m_id(id), m_title(title),
    m_isLoadModel(false),
    m_loadModelInProgress(false),
    m_responseInProgress(false),
    chatLLM(new ChatLLM(this)),
    m_timer(new QTimer(this)),
    m_date(date),
    m_valueTimer(0),
    m_model(nullptr)
{
    QThread::currentThread()->setObjectName("Main Thread");

    m_chatModel = new ChatModel(id,root,this);

    //load and unload model
    connect(this, &Chat::loadModel, chatLLM, &ChatLLM::loadModel, Qt::QueuedConnection);
    connect(chatLLM, &ChatLLM::loadModelResult, this, &Chat::LoadModelResult, Qt::QueuedConnection);
    connect(this, &Chat::unLoadModel, chatLLM, &ChatLLM::unLoadModel, Qt::QueuedConnection);

    //prompt
    connect(m_chatModel, &ChatModel::startPrompt, this, &Chat::promptRequested, Qt::QueuedConnection);
    connect(this, &Chat::prompt, chatLLM, &ChatLLM::prompt, Qt::QueuedConnection);
    connect(chatLLM, &ChatLLM::tokenResponse, this, &Chat::tokenResponseRequested, Qt::QueuedConnection);
    connect(m_timer, &QTimer::timeout, [=](){++m_valueTimer; emit valueTimerChanged();});

    //finished response
    connect(chatLLM, &ChatLLM::finishedResponnse, this, &Chat::finishedResponnse, Qt::QueuedConnection);
    connect(this, &Chat::finishedResponnseRequest, m_chatModel, &ChatModel::finishedResponnse, Qt::QueuedConnection);
}

Chat::~Chat(){
    delete chatLLM;
    chatLLM = nullptr;
}

//*----------------------------------------------------------------------------------------**************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Read Property*----------------------------------------------------------------------------------------*//
int Chat::id() const{
    return m_id;
}
QString Chat::title() const{
    return m_title;
}
QDateTime Chat::date() const{
    return m_date;
}
bool Chat::isLoadModel() const{
    return m_isLoadModel;
}
ChatModel* Chat::chatModel() const{
    return m_chatModel;
}
bool Chat::loadModelInProgress() const{
    return m_loadModelInProgress;
}
bool Chat::responseInProgress() const{
    return m_responseInProgress;
}
int Chat::valueTimer() const{
    return m_valueTimer;
}
Model* Chat::model() const{
    return m_model;
}
//*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


//*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Write Property  *----------------------------------------------------------------------------------------*//
void Chat::setId(const int id){
    if(m_id == id)
        return;
    m_id = id;
    m_chatModel->setParentId(id);
    emit idChanged();
}
void Chat::setTitle(const QString title){
    if(m_title == title)
        return;
    m_title = title;
    emit titleChanged();
}
void Chat::setIsLoadModel(const bool isLoadModel){
    if(m_isLoadModel == isLoadModel)
        return;
    m_isLoadModel = isLoadModel;
    emit isLoadModelChanged();
}
void Chat::setLoadModelInProgress(const bool loadModelInProgress){
    if(m_loadModelInProgress == loadModelInProgress)
        return;
    m_loadModelInProgress = loadModelInProgress;
    emit loadModelInProgressChanged();
}
void Chat::setResponseInProgress(const bool responseInProgress){
    if(m_responseInProgress == responseInProgress)
        return;
    m_responseInProgress = responseInProgress;
    if(!responseInProgress)
        chatLLM->setStop();
    emit responseInProgressChanged();
}
void Chat::setModel(Model* model){
    if(m_model == model)
        return;
    m_model = model;
    emit modelChanged();
}
//*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//


//*----------------------------------------------------------------------------------------------*******----------------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------------* Slots *----------------------------------------------------------------------------------------------*//
void Chat::LoadModelResult(const bool result){
    setIsLoadModel(result);
    setLoadModelInProgress( false);
}
void Chat::promptRequested(const QString &input){
    m_timer->start(1000);
    if(!m_chatModel->isStart()){
        emit startChat();
    }
    setResponseInProgress(true);
    emit prompt(input);
}
void Chat::tokenResponseRequested(const QString &token){
    m_chatModel->updateResponse(token);
}
void Chat::finishedResponnse(){
    setResponseInProgress(false);
    m_timer->stop();
    m_chatModel->setExecutionTime(m_valueTimer);
    m_valueTimer = 0;
    emit valueTimerChanged();
    emit finishedResponnseRequest();
}
//*-------------------------------------------------------------------------------------------* end Slots *--------------------------------------------------------------------------------------------*//


void Chat::loadModelRequested(Model *model){
    if(m_isLoadModel == true)
        unloadModelRequested();
    setLoadModelInProgress(true);
    setModel(model);
    emit loadModel(model->directoryPath());
}

void Chat::unloadModelRequested(){
    setIsLoadModel(false);
    emit unLoadModel();
}

void Chat::addChatItem(int id, QString prompt, QString response){}
