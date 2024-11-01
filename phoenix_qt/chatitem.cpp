#include "chatitem.h"

ChatItem::ChatItem(const int &id, const QString &prompt, QObject *parent):
    QObject(parent), m_id(id), m_prompt(prompt), m_response(""){}

//*----------------------------------------------------------------------------------------**************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Read Property *----------------------------------------------------------------------------------------*//
int ChatItem::id() const{
    return m_id;
}
QString ChatItem::prompt() const{
    return m_prompt;
}
QString ChatItem::response() const{
    return m_response;
}
//*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


//*----------------------------------------------------------------------------------------**************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Write Property *----------------------------------------------------------------------------------------*//
void ChatItem::setId(const int id){
    if(m_id == id)
        return;
    m_id = id;
    emit idChanged(m_id);
}

void ChatItem::setPrompt(const QString prompt){
    if (m_prompt == prompt)
        return;
    m_prompt = prompt;
    emit promptChanged(m_prompt);
}

void ChatItem::setResponse(const QString tokenResponse){
    if (m_response == tokenResponse)
        return;
    m_response = tokenResponse;
    emit responseChanged(m_response);
}
//*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//
