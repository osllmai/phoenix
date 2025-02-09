#include "model.h"

Model::Model(/*const int id, const QString& name, const QString& key, QDateTime* addModelTime,
             const bool isLike, Company* company, const BackendType backend,*/ QObject* parent)
    :/*m_id(id), m_name(name), m_key(key), m_addModelTime(addModelTime), m_isLike(isLike),
    m_company(company), m_backend(backend),*/ QObject(parent)
{}

Model::~Model(){
    // delete m_addModelTime;
    // delete m_expireModelTime;
}

const int Model::id() const{return m_id;}

const QString &Model::name() const{return m_name;}

const QString &Model::icon() const{return m_icon;}

const QString &Model::promptTemplate() const{return m_promptTemplate;}

const QString &Model::systemPrompt() const{return m_systemPrompt;}

const QString &Model::information() const{return m_information;}

Company *Model::company() const{return m_company;}

const BackendType Model::backend() const{return m_backend;}

const QString &Model::key() const{return m_key;}
void Model::setKey(const QString &key){
    if(m_key == key)
        return;
    m_key = key;
    emit keyChanged();
}

const bool Model::isLike() const{return m_isLike;}
void Model::setIsLike(const bool isLike){
    if(m_isLike == isLike)
        return;
    m_isLike = isLike;
    emit isLikeChanged();
}

QDateTime Model::addModelTime() const{return m_addModelTime;}
void Model::setAddModelTime(QDateTime newAddModelTime){
    if (m_addModelTime == newAddModelTime)
        return;
    m_addModelTime = newAddModelTime;
    emit addModelTimeChanged();
}

QDateTime Model::expireModelTime() const{return m_expireModelTime;}
