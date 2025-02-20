#include "message.h"

Message::Message() {}

int Message::id() const {return m_id;}

QString Message::text() const{return m_text;}
void Message::setText(const QString &newText){
    if (m_text == newText)
        return;
    m_text = newText;
    emit textChanged();
}

QDateTime Message::date() const{return m_date;}
void Message::setDate(const QDateTime &newDate){
    if (m_date == newDate)
        return;
    m_date = newDate;
    emit dateChanged();
}

QString Message::icon() const{return m_icon;}
void Message::setIcon(const QString &newIcon){
    if (m_icon == newIcon)
        return;
    m_icon = newIcon;
    emit iconChanged();
}

bool Message::isPrompt() const{return m_isPrompt;}
void Message::setIsPrompt(bool newIsPrompt){
    if (m_isPrompt == newIsPrompt)
        return;
    m_isPrompt = newIsPrompt;
    emit isPromptChanged();
}
