#ifndef HUGGINGFACEMODELINFO_H
#define HUGGINGFACEMODELINFO_H

#include <QObject>
#include <QQmlEngine>
#include <QString>
#include <QStringList>
#include <QVector>

#include "huggingfacestruct.h"

class HuggingfaceModelInfo: public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(qint64 usedStorage READ usedStorage CONSTANT FINAL)
    Q_PROPERTY(QString createdAt READ createdAt CONSTANT FINAL)
    Q_PROPERTY(QStringList spaces READ spaces CONSTANT FINAL)
    Q_PROPERTY(QVector<SiblingFile> siblings READ siblings CONSTANT FINAL)
    Q_PROPERTY(GgufData gguf READ gguf CONSTANT FINAL)
    Q_PROPERTY(TransformersInfo transformersInfo READ transformersInfo CONSTANT FINAL)
    Q_PROPERTY(CardData cardData READ cardData CONSTANT FINAL)
    Q_PROPERTY(ConfigData config READ config CONSTANT FINAL)
    Q_PROPERTY(QVector<WidgetData> widgetData READ widgetData CONSTANT FINAL)
    Q_PROPERTY(bool disabled READ disabled CONSTANT FINAL)
    Q_PROPERTY(bool gated READ gated CONSTANT FINAL)
    Q_PROPERTY(QString lastModified READ lastModified CONSTANT FINAL)
    Q_PROPERTY(QString sha READ sha CONSTANT FINAL)
    Q_PROPERTY(QString author READ author CONSTANT FINAL)
    Q_PROPERTY(QString modelId READ modelId CONSTANT FINAL)
    Q_PROPERTY(int likes READ likes CONSTANT FINAL)
    Q_PROPERTY(int downloads READ downloads CONSTANT FINAL)
    Q_PROPERTY(QStringList tags READ tags CONSTANT FINAL)
    Q_PROPERTY(QString library_name READ library_name CONSTANT FINAL)
    Q_PROPERTY(QString pipeline_tag READ pipeline_tag CONSTANT FINAL)
    Q_PROPERTY(bool isPrivate READ isPrivate CONSTANT FINAL)
    Q_PROPERTY(QString id READ id CONSTANT FINAL)
public:
    explicit HuggingfaceModelInfo(QObject* parent = nullptr) : QObject(parent) {}

    explicit HuggingfaceModelInfo(const QString& id, const int likes, const int downloads, const QString& pipelineTag,
                              const QString& libraryName, const QStringList& tags, const QString& createdAt, QObject* parent);

    qint64 usedStorage() const;

    QString createdAt() const;

    QStringList spaces() const;

    QVector<SiblingFile> siblings() const;

    GgufData gguf() const;

    TransformersInfo transformersInfo() const;

    CardData cardData() const;

    ConfigData config() const;

    QVector<WidgetData> widgetData() const;

    bool disabled() const;

    bool gated() const;

    QString lastModified() const;

    QString sha() const;

    QString author() const;

    QString modelId() const;

    int likes() const;

    int downloads() const;

    QStringList tags() const;

    QString library_name() const;

    QString pipeline_tag() const;

    bool isPrivate() const;

    QString id() const;

private:
    QString m_id;
    bool m_isPrivate;
    QString m_pipeline_tag;
    QString m_library_name;
    QStringList m_tags;
    int m_downloads;
    int m_likes;
    QString m_modelId;
    QString m_author;
    QString m_sha;
    QString m_lastModified;
    bool m_gated;
    bool m_disabled;
    QVector<WidgetData> m_widgetData;
    ConfigData m_config;
    CardData m_cardData;
    TransformersInfo m_transformersInfo;
    GgufData m_gguf;
    QVector<SiblingFile> m_siblings;
    QStringList m_spaces;
    QString m_createdAt;
    qint64 m_usedStorage;
};

#endif // HUGGINGFACEMODELINFO_H
