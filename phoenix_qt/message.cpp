#include "message.h"

Message::Message(const int &id, const QString &text, bool isPrompt, QObject *parent ):
    m_id(id),m_text(text), m_child(nullptr), QObject(parent),m_numberOfCurrentChild(-1),m_numberOfChildList(0),m_isPrompt(isPrompt)
{
    m_date = QDateTime::currentDateTime();
}

//*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Read Property  *----------------------------------------------------------------------------------------*//
int Message::id() const{
    return m_id;
}
QString Message::text() const{
    return m_text;
}
int Message::numberOfToken() const{
    return m_numberOfToken;
}
int Message::executionTime() const{
    return m_executionTime;
}
QDateTime Message::date() const{
    return m_date;
}
Message *Message::child() {
    return m_child;
}
int Message::numberOfCurrentChild() const{
    return m_numberOfCurrentChild;
}
int Message::numberOfChildList() const{
    return m_numberOfChildList;
}
bool Message::isPrompt() const{
    return m_isPrompt;
}
//*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


//*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Write Property *----------------------------------------------------------------------------------------*//
void Message::setId(const int id){
    if(m_id == id)
        return;
    m_id = id;
    emit idChanged(m_id);
}
void Message::setText(const QString text){
    if(m_text == text)
        return;
    m_text = text;
    emit textChanged(m_text);
}
void Message::setNumberOfToken(const int numberOfToken){
    if(m_numberOfToken == numberOfToken)
        return;
    m_numberOfToken = numberOfToken;
    emit numberOfTokenChanged(numberOfToken);
}
void Message::setExecutionTime(const int executionTime){
    if(m_executionTime == executionTime)
        return;
    m_executionTime = executionTime;
    emit executionTimeChanged(executionTime);
}
//*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//

void Message::nextChild(const int numberOfNext){
    if(numberOfNext<childList.size() && m_numberOfCurrentChild != numberOfNext){
        m_numberOfCurrentChild = numberOfNext;
        m_child = childList[numberOfNext];
        emit childChanged();
        emit numberOfCurrentChildChanged(m_numberOfCurrentChild);
    }
}
void Message::addChild(Message *message){
    m_numberOfCurrentChild = childList.size();
    childList.append(message);
    m_numberOfChildList = childList.size();
    m_child = childList.last();
    emit childChanged();
    emit numberOfCurrentChildChanged(m_numberOfCurrentChild);
    emit numberOfChildListChanged(m_numberOfChildList);
}
