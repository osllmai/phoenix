#include "message.h"

Message::Message(const int &id, const QString &text, const QDateTime date, const QString &icon, bool isPrompt, const int like, QObject *parent):
    m_id(id), m_text(text),m_date(date), m_icon(icon), m_isPrompt(isPrompt), m_like(like), QObject(parent){}

int Message::id() const {return m_id;}

QString Message::text() const{return m_text;}
void Message::setText(const QString &newText){
    if (m_text == newText)
        return;
    m_text = newText;
    emit textChanged();
}

QDateTime Message::date() const{return m_date;}

QString Message::icon() const{return m_icon;}

bool Message::isPrompt() const{return m_isPrompt;}

int Message::like() const{return m_like;}
void Message::setLike(const int &newLike){
    if (m_like == newLike)
        return;
    m_like = newLike;
    emit likeChanged();
}
