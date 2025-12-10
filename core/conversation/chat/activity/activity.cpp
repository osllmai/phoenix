#include "activity.h"

Activity::Activity(const int &id, const QString &text, const QString &icon, QObject *parent):
    m_id(id), m_text(text), m_icon(icon), QObject(parent){}

int Activity::id() const{return m_id;}

QString Activity::text() const{return m_text;}

QString Activity::icon() const{return m_icon;}
