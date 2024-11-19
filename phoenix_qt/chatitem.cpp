#include "chatitem.h"

ChatItem::ChatItem(const int &id, Message *prompt, Message *response, int numberOfPrompt,
                   int numberOfEditPrompt, int numberOfResponse, int numberOfRegenerate, QObject *parent):
    QObject(parent), m_id(id), m_prompt(prompt), m_response(response), m_numberOfPrompt(numberOfPrompt),
    m_numberOfEditPrompt(numberOfEditPrompt), m_numberOfResponse(numberOfResponse),
    m_numberOfRegenerate(numberOfRegenerate){}

//*----------------------------------------------------------------------------------------**************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Read Property *----------------------------------------------------------------------------------------*//
int ChatItem::id() const{
    return m_id;
}
Message* ChatItem::prompt(){
    return m_prompt;
}
Message* ChatItem::response(){
    return m_response;
}
int ChatItem::numberOfPrompt() const{
    return m_numberOfPrompt;
}
int ChatItem::numberOfEditPrompt() const{
    return m_numberOfEditPrompt;
}
int ChatItem::numberOfResponse() const{
    return m_numberOfResponse;
}
int ChatItem::numberOfRegenerate() const{
    return m_numberOfRegenerate;
}
// int ChatItem::numberOfTokens() const{
//     return m_numberOfTokens;
// }
// int ChatItem::executionTime() const{
//     return m_executionTime;
// }
//*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


//*----------------------------------------------------------------------------------------**************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Write Property *----------------------------------------------------------------------------------------*//
void ChatItem::setId(const int id){
    if(m_id == id)
        return;
    m_id = id;
    emit idChanged(m_id);
}
void ChatItem::setPrompt(Message *prompt){
    if (m_prompt == prompt)
        return;
    m_prompt = prompt;
    emit promptChanged();
}
void ChatItem::setResponse(Message *response){
    if (m_response == response)
        return;
    m_response = response;
    emit responseChanged();
}
//*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//
