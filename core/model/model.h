#ifndef MODEL_H
#define MODEL_H

#include <QObject>
#include <QQmlEngine>
#include <QDateTime>

#include "BackendType.h"
#include "company.h"

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
    Q_PROPERTY(Company *company READ company CONSTANT FINAL)
    Q_PROPERTY(QString type READ type CONSTANT FINAL)
    Q_PROPERTY(BackendType backend READ backend CONSTANT FINAL)
    Q_PROPERTY(QString key READ key WRITE setKey NOTIFY keyChanged FINAL)
    Q_PROPERTY(bool isLike READ isLike WRITE setIsLike NOTIFY isLikeChanged FINAL)
    Q_PROPERTY(QDateTime addModelTime READ addModelTime WRITE setAddModelTime NOTIFY addModelTimeChanged FINAL)
    Q_PROPERTY(QDateTime expireModelTime READ expireModelTime CONSTANT FINAL)

public:
    explicit Model(QObject* parent = nullptr) : QObject(parent) {}

    explicit Model(const int id, const QString& modelName, const QString& name, const QString& key,
                   QDateTime addModelTime, const bool isLike, Company* company, const QString& type,
                   const BackendType backend,
                   const QString& icon , const QString& information , const QString& promptTemplate ,
                   const QString& systemPrompt, QDateTime expireModelTime, QObject* parent);
    virtual ~Model();

    const int id() const;

    const QString &name() const;

    const QString modelName() const;

    const QString &icon() const;

    const QString &information() const;

    const QString &promptTemplate() const;

    const QString &systemPrompt() const;

    Company *company() const;

    const QString &type() const;

    const BackendType backend() const;

    const QString &key() const;
    void setKey(const QString &key);

    const bool isLike() const;
    void setIsLike(const bool isLike);

    QDateTime addModelTime() const;
    void setAddModelTime(QDateTime newAddModelTime);

    QDateTime expireModelTime() const;

signals:
    void keyChanged();
    void isLikeChanged();
    void addModelTimeChanged();

private:
    int m_id;
    QString m_name;
    QString m_modelName;
    QString m_icon;
    QString m_information;
    QString m_promptTemplate;
    QString m_systemPrompt;
    Company* m_company;
    QString m_type;
    BackendType m_backend;
    QString m_key;
    bool m_isLike;
    QDateTime m_addModelTime;
    QDateTime m_expireModelTime;
};

#endif // MODEL_H
