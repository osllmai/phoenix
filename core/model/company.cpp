#include "company.h"

Company::Company(const int id, const QString& name, const QString& icon,
                 const BackendType backend, const QString& filePath, QObject* parent)
    :m_id(id), m_name(name), m_icon(icon), m_backend(backend),
    m_filePath(filePath), QObject(parent){}

Company::~Company(){}

const int Company::id() const{return m_id;}

const QString &Company::name() const{return m_name;}

const QString &Company::icon() const{return m_icon;}

const BackendType Company::backend() const{return m_backend;}

const QString &Company::filePath() const{return m_filePath;}
