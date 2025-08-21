#include "huggingfacemodelinfo.h"

HuggingfaceModelInfo::HuggingfaceModelInfo() {}

QString HuggingfaceModelInfo::id() const
{
    return m_id;
}

bool HuggingfaceModelInfo::isPrivate() const
{
    return m_isPrivate;
}

QString HuggingfaceModelInfo::pipeline_tag() const
{
    return m_pipeline_tag;
}

QString HuggingfaceModelInfo::library_name() const
{
    return m_library_name;
}

QStringList HuggingfaceModelInfo::tags() const
{
    return m_tags;
}

int HuggingfaceModelInfo::downloads() const
{
    return m_downloads;
}

int HuggingfaceModelInfo::likes() const
{
    return m_likes;
}

QString HuggingfaceModelInfo::modelId() const
{
    return m_modelId;
}

QString HuggingfaceModelInfo::author() const
{
    return m_author;
}

QString HuggingfaceModelInfo::sha() const
{
    return m_sha;
}

QString HuggingfaceModelInfo::lastModified() const
{
    return m_lastModified;
}

bool HuggingfaceModelInfo::gated() const
{
    return m_gated;
}

bool HuggingfaceModelInfo::disabled() const
{
    return m_disabled;
}

QVector<WidgetData> HuggingfaceModelInfo::widgetData() const
{
    return m_widgetData;
}

ConfigData HuggingfaceModelInfo::config() const
{
    return m_config;
}

CardData HuggingfaceModelInfo::cardData() const
{
    return m_cardData;
}

TransformersInfo HuggingfaceModelInfo::transformersInfo() const
{
    return m_transformersInfo;
}

GgufData HuggingfaceModelInfo::gguf() const
{
    return m_gguf;
}

QVector<SiblingFile> HuggingfaceModelInfo::siblings() const
{
    return m_siblings;
}

QStringList HuggingfaceModelInfo::spaces() const
{
    return m_spaces;
}

QString HuggingfaceModelInfo::createdAt() const
{
    return m_createdAt;
}

qint64 HuggingfaceModelInfo::usedStorage() const
{
    return m_usedStorage;
}
