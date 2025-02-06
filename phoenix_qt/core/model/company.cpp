#include "company.h"

Company::Company(const int id, const QString& name, const QString& icon,
                 const QString backend, QObject* parent)
    :m_id(id), m_name(name), m_icon(icon),  QObject(parent)
{
    if(backend == "offline")
        m_backend = BackendType::OfflineModel;
    if(backend == "online")
        m_backend = BackendType::OnlineModel;
}

Company::~Company(){}

const int Company::id() const{return m_id;}

const QString &Company::name() const{return m_name;}

const QString &Company::icon() const{return m_icon;}

const BackendType Company::backend() const{return m_backend;}
