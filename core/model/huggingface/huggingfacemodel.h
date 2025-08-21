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
    Q_PROPERTY(int likes READ likes CONSTANT FINAL)
    Q_PROPERTY(int downloads READ downloads CONSTANT FINAL)
    Q_PROPERTY(QString pipelineTag READ pipelineTag CONSTANT FINAL)
    Q_PROPERTY(QString libraryName READ libraryName CONSTANT FINAL)
    Q_PROPERTY(QStringList tags READ tags CONSTANT FINAL)
    Q_PROPERTY(QString createdAt READ createdAt CONSTANT FINAL)
    Q_PROPERTY(HuggingfaceModelInfo hugginfaceInfo READ hugginfaceInfo NOTIFY hugginfaceInfoChanged FINAL)
public:
    explicit HuggingfaceModel(QObject* parent = nullptr) : QObject(parent) {}

    explicit HuggingfaceModel(const QString& id, const int likes, const int downloads, const QString& pipelineTag,
                          const QString& libraryName, const QStringList& tags, const QString& createdAt, QObject* parent);

    const QString &id() const;

    const int likes() const;

    const int downloads() const;

    const QString &pipelineTag() const;

    const QString &libraryName() const;

    const QStringList &tags() const;

    const QString &createdAt() const;

    HuggingfaceModelInfo hugginfaceInfo() const;

signals:
    void hugginfaceInfoChanged();

private:
    QString m_id;
    int m_likes;
    int m_downloads;
    QString m_pipelineTag;
    QString m_libraryName;
    QStringList m_tags;
    QString m_createdAt;
    HuggingfaceModelInfo m_hugginfaceInfo;
};

#endif // HUGGINGFACEMODEL_H
