#include "model.h"

Model::Model(const int id, const QString& modelName, const QString& name, const QString& key,
             QDateTime addModelTime, const QString& type,
             const BackendType backend,
             const QString& icon , const QString& information , const QString& promptTemplate ,
             const QString& systemPrompt, QDateTime expireModelTime,
             const bool recommended, QObject* parent)
    : m_id(id), m_name(name), m_modelName(modelName), m_key(key), m_addModelTime(addModelTime),
    m_type(type), m_backend(backend), m_icon(icon), m_information(information),
    m_promptTemplate(promptTemplate), m_systemPrompt(systemPrompt),
    m_expireModelTime(expireModelTime), m_recommended(recommended),
    QObject(parent)
{}

Model::~Model(){}

const int Model::id() const{return m_id;}

const QString &Model::name() const{return m_name;}

const QString Model::modelName() const{return m_modelName;}

const QString &Model::icon() const{return m_icon;}

const QString &Model::promptTemplate() const{return m_promptTemplate;}

const QString &Model::systemPrompt() const{return m_systemPrompt;}

const QString &Model::information() const{return m_information;}

const QString &Model::type() const{return m_type;}

const BackendType Model::backend() const{return m_backend;}

const QString &Model::key() const{return m_key;}
void Model::setKey(const QString &key){
    if(m_key == key)
        return;
    m_key = key;
    emit keyChanged();
}

QDateTime Model::addModelTime() const{return m_addModelTime;}
void Model::setAddModelTime(QDateTime newAddModelTime){
    if (m_addModelTime == newAddModelTime)
        return;
    m_addModelTime = newAddModelTime;
    emit addModelTimeChanged();
}

QDateTime Model::expireModelTime() const{return m_expireModelTime;}

const bool Model::recommended() const{return m_recommended;}
