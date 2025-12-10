#include "source.h"

Source::Source(const int &id,
               const QString &text,
               const QString &icon,
               const QString &link,
               QObject *parent):
    m_id(id), m_text(text), m_icon(icon), m_link(link), QObject(parent){}

int Source::id() const{return m_id;}

QString Source::text() const{return m_text;}

QString Source::icon() const{return m_icon;}

QString Source::titel() const{return m_titel;}

QString Source::link() const{return m_link;}
