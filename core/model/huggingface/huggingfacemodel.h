#ifndef HUGGINGFACEMODEL_H
#define HUGGINGFACEMODEL_H

#include <QObject>
#include <QQmlEngine>
#include <huggingfacemodelinfo.h>

class HuggingfaceModel: public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString id READ id CONSTANT FINAL)
    Q_PROPERTY(QString name READ name CONSTANT FINAL)
    Q_PROPERTY(QString icon READ icon CONSTANT FINAL)
    Q_PROPERTY(int likes READ likes CONSTANT FINAL)
    Q_PROPERTY(int downloads READ downloads CONSTANT FINAL)
    Q_PROPERTY(QString pipelineTag READ pipelineTag CONSTANT FINAL)
    Q_PROPERTY(QString libraryName READ libraryName CONSTANT FINAL)
    Q_PROPERTY(QVariantList tags READ tags CONSTANT FINAL)
    Q_PROPERTY(QString createdAt READ createdAt CONSTANT FINAL)

public:
    explicit HuggingfaceModel(QObject* parent = nullptr) : QObject(parent) {}

    explicit HuggingfaceModel(const QString& id, const int likes, const int downloads, const QString& pipelineTag,
                          const QString& libraryName, const QStringList& tags, const QString& createdAt, QObject* parent);

    const QString &id() const;

    const QString &name() const;

    const QString &icon() const;

    const int likes() const;

    const int downloads() const;

    const QString &pipelineTag() const;

    const QString &libraryName() const;

    QVariantList tags() const;

    QString createdAt() const;

private:
    QString m_id;
    QString m_name;
    QString m_icon;
    int m_likes;
    int m_downloads;
    QString m_pipelineTag;
    QString m_libraryName;
    QVariantList m_tags;
    QString m_createdAt;
};

#endif // HUGGINGFACEMODEL_H
