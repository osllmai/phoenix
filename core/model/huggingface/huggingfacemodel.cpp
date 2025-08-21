#include "huggingfacemodel.h"

HuggingfaceModel::HuggingfaceModel(const QString& id, const int likes, const int downloads,
                                   const QString& pipelineTag, const QString& libraryName, const QStringList& tags,
                                   const QString& createdAt, QObject* parent):
    m_id(id), m_likes(likes), m_downloads(downloads), m_pipelineTag(pipelineTag),
    m_libraryName(libraryName), m_tags(tags), m_createdAt(createdAt), QObject(parent)
{}

const QString &HuggingfaceModel::id() const{return m_id;}

const int HuggingfaceModel::likes() const{return m_likes;}

const int HuggingfaceModel::downloads() const{return m_downloads;}

const QString &HuggingfaceModel::pipelineTag() const{return m_pipelineTag;}

const QString &HuggingfaceModel::libraryName() const{return m_libraryName;}

const QStringList &HuggingfaceModel::tags() const{return m_tags;}

const QString &HuggingfaceModel::createdAt() const{return m_createdAt;}

HuggingfaceModelInfo HuggingfaceModel::hugginfaceInfo() const{return m_hugginfaceInfo;}
