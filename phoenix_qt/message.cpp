#include "message.h"

Message::Message(const int &id, const QString &text, bool isPrompt, QObject *parent ):
    m_id(id),m_text(text), m_child(nullptr), QObject(parent),m_numberOfCurrentChild(-1),m_numberOfChildList(0),m_isPrompt(isPrompt){}


//*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Read Property  *----------------------------------------------------------------------------------------*//
int Message::id() const{
    return m_id;
}
QString Message::text() const{
    return m_text;
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
//*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//

// Message* Message::findChild(const int index){
//     return childList[index];
// }
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
