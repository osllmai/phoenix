#include "chat.h"

#include <QtSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

#include "database.h"
#include "model.h"
#include "providers/openai.h"

Chat::Chat(const int &id, const QString &title, const QDateTime date , Message* root, QObject *parent) :
    QObject(parent), m_id(id), m_title(title),
    m_isLoadModel(false),
    m_loadModelInProgress(false),
    m_responseInProgress(false),
    // chatLLM(new ChatLLM(this)),
    m_date(date),
    m_valueTimer(0),
    m_model(nullptr)
{
    QThread::currentThread()->setObjectName("Main Thread");

    m_chatModel = new ChatModel(id, root, this);

    //load and unload model
    // connect(this, &Chat::loadModel, chatLLM, &ChatLLM::loadModel, Qt::QueuedConnection);
    // connect(this, &Chat::unLoadModel, chatLLM, &ChatLLM::unloadModel, Qt::QueuedConnection);
    // connect(this, &Chat::prompt, chatLLM, &ChatLLM::prompt, Qt::QueuedConnection);

    //prompt
    connect(m_chatModel, &ChatModel::startPrompt, this, &Chat::promptRequested, Qt::QueuedConnection);

    //finished response
    connect(this, &Chat::finishedResponnseRequest, m_chatModel, &ChatModel::finishedResponnse, Qt::QueuedConnection);
}

Chat::~Chat(){
    if(m_responseInProgress && _backend)
        _backend->stop();
    if(m_loadModelInProgress || m_isLoadModel)
        unloadModelRequested();

    if (_backend)
        _backend->deleteLater();
    m_chatModel->deleteLater();
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
        _backend->stop();
    emit responseInProgressChanged();
}
void Chat::setModel(Model* model){
    if(m_model == model)
        return;
    m_model = model;
    createBackend();
    emit modelChanged();
}

void Chat::timerEvent(QTimerEvent *event)
{
    ++m_valueTimer;
    emit valueTimerChanged();
}
//*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//


//*----------------------------------------------------------------------------------------------*******----------------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------------* Slots *----------------------------------------------------------------------------------------------*//
void Chat::LoadModelResult(const bool result){
    setIsLoadModel(result);
    setLoadModelInProgress( false);
}

void Chat::promptRequested(const QString &input){
    QDateTime now = QDateTime::currentDateTime();
    if(m_date.daysTo(now) > 1 || m_date.toString("dd")!=now.toString("dd")){
        m_date = now;
        phoenix_databace::updateConversationDate(m_id,m_date);
    }

    _timerId = startTimer(1000);
    if(!m_chatModel->isStart()){
        emit startChat();
    }
    setResponseInProgress(true);
    _backend->prompt(input);
}

void Chat::tokenResponseRequested(const QString &token){
    m_chatModel->updateResponse(token);
}

void Chat::finishedResponnse(){
    setResponseInProgress(false);
    killTimer(_timerId);
    m_chatModel->setExecutionTime(m_valueTimer);
    m_valueTimer = 0;
    emit valueTimerChanged();
    emit finishedResponnseRequest();
}

void Chat::createBackend() {
    if (!m_model)
        return ;

    if (_backend) {
        disconnect(_backend, nullptr, this, nullptr);
        _backend->deleteLater();
    }

    switch (m_model->backendType()) {
    case Model::BackendType::LocalModel: {
        auto chatLLM = new ChatLLM{this};
        connect(chatLLM, &ChatLLM::loadModelResult, this, &Chat::LoadModelResult, Qt::QueuedConnection);
        _backend = chatLLM;
        break;
    }
    case Model::BackendType::OnlineProvider:
        //TODO: Relying on string-based object creation is a valuable approach.
        if (m_model->name() == "Open AI")
            _backend = new OpenAI{m_model->apiKey(), this};

        break;
    }

    connect(_backend,
            &AbstractChatProvider::tokenResponse,
            this,
            &Chat::tokenResponseRequested,
            Qt::QueuedConnection);
    connect(_backend,
            &AbstractChatProvider::finishedResponnse,
            this,
            &Chat::finishedResponnse,
            Qt::QueuedConnection);
}

//*-------------------------------------------------------------------------------------------* end Slots *--------------------------------------------------------------------------------------------*//

void Chat::loadModelRequested(Model *model){
    if (m_isLoadModel)
        unloadModelRequested();

    if (model->backendType() == Model::BackendType::LocalModel)
        setLoadModelInProgress(true);
    else
        setIsLoadModel(true);

    setModel(model);
    emit loadModel(model->directoryPath());
}

void Chat::unloadModelRequested(){
    setIsLoadModel(false);
    setModel(nullptr);

    if (_backend)
        _backend->unloadModel();
}

void Chat::addChatItem(int id, QString prompt, QString response){}
