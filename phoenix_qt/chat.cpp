#include "chat.h"

#include <QtSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include "database.h"

Chat::Chat(const int &id, const QString &title, const QDateTime date , Message* root, QObject *parent) :
    QObject(parent), m_id(id), m_title(title),
    m_isLoadModel(false),
    m_responseInProgress(false),
    chatLLM(new ChatLLM(this)),
    m_timer(new QTimer(this)),
    m_date(date),
    m_valueTimer(0)
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
bool Chat::responseInProgress() const{
    return m_responseInProgress;
}
int Chat::valueTimer() const{
    return m_valueTimer;
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
void Chat::setResponseInProgress(const bool responseInProgress){
    if(m_responseInProgress == responseInProgress)
        return;
    m_responseInProgress = responseInProgress;
    if(!responseInProgress)
        chatLLM->setStop();
    qInfo()<<m_responseInProgress;
    emit responseInProgressChanged();
}
//*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//


//*----------------------------------------------------------------------------------------------*******----------------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------------* Slots *----------------------------------------------------------------------------------------------*//
void Chat::LoadModelResult(const bool result){
    setIsLoadModel(result);
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
    // m_chatModel->saveChatItem(m_id);
    setResponseInProgress(false);
    m_timer->stop();
    m_chatModel->setExecutionTime(m_valueTimer);
    m_valueTimer = 0;
    emit valueTimerChanged();
    emit finishedResponnseRequest();
}
//*-------------------------------------------------------------------------------------------* end Slots *--------------------------------------------------------------------------------------------*//


void Chat::loadModelRequested(QString modelPath){
    emit loadModel(modelPath);
}

void Chat::unloadModelRequested(){
    m_isLoadModel = false;
    emit unLoadModel();
}

void Chat::addChatItem(int id, QString prompt, QString response){
    // m_chatModel->addChatItem(id, prompt, response);
}
