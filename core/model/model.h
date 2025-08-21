#ifndef MODEL_H
#define MODEL_H

#include <QObject>
#include <QQmlEngine>
#include <QDateTime>

#include "BackendType.h"

class Model : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int id READ id CONSTANT FINAL)
    Q_PROPERTY(QString name READ name CONSTANT FINAL)
    Q_PROPERTY(QString modelName READ modelName CONSTANT FINAL)
    Q_PROPERTY(QString icon READ icon CONSTANT FINAL)
    Q_PROPERTY(QString information READ information CONSTANT FINAL)
    Q_PROPERTY(QString promptTemplate READ promptTemplate CONSTANT FINAL)
    Q_PROPERTY(QString systemPrompt READ systemPrompt CONSTANT FINAL)
    Q_PROPERTY(QString type READ type CONSTANT FINAL)
    Q_PROPERTY(BackendType backend READ backend CONSTANT FINAL)
    Q_PROPERTY(QString key READ key WRITE setKey NOTIFY keyChanged FINAL)
    Q_PROPERTY(QDateTime addModelTime READ addModelTime WRITE setAddModelTime NOTIFY addModelTimeChanged FINAL)
    Q_PROPERTY(QDateTime expireModelTime READ expireModelTime CONSTANT FINAL)
    Q_PROPERTY(bool recommended READ recommended CONSTANT FINAL)

public:
    explicit Model(QObject* parent = nullptr) : QObject(parent) {}

    explicit Model(const int id, const QString& modelName, const QString& name, const QString& key,
                   QDateTime addModelTime, const QString& type,
                   const BackendType backend,
                   const QString& icon , const QString& information , const QString& promptTemplate ,
                   const QString& systemPrompt, QDateTime expireModelTime, const bool recommended, QObject* parent);
    virtual ~Model();

    const int id() const;

    const QString &name() const;

    const QString modelName() const;

    const QString &icon() const;

    const QString &information() const;

    const QString &promptTemplate() const;

    const QString &systemPrompt() const;

    const QString &type() const;

    const BackendType backend() const;

    const QString &key() const;
    void setKey(const QString &key);

    QDateTime addModelTime() const;
    void setAddModelTime(QDateTime newAddModelTime);

    QDateTime expireModelTime() const;

    const bool recommended() const;

signals:
    void keyChanged();
    void addModelTimeChanged();

private:
    int m_id;
    QString m_name;
    QString m_modelName;
    QString m_icon;
    QString m_information;
    QString m_promptTemplate;
    QString m_systemPrompt;
    QString m_type;
    bool m_recommended;
    BackendType m_backend;
    QString m_key;
    QDateTime m_addModelTime;
    QDateTime m_expireModelTime;
};

#endif // MODEL_H
