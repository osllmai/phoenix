#pragma once

#include <QJsonObject>
#include <QObject>

class WorkFlowStepField : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Type type READ type WRITE setType NOTIFY typeChanged FINAL)
    Q_PROPERTY(Direction direction READ direction WRITE setDirection NOTIFY directionChanged FINAL)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged FINAL)
    Q_PROPERTY(QString defaultValue READ defaultValue WRITE setDefaultValue NOTIFY defaultValueChanged FINAL)
    Q_PROPERTY(QString value READ value WRITE setValue NOTIFY valueChanged FINAL)
    Q_PROPERTY(QString typeName READ typeName NOTIFY typeChanged FINAL)

public:
    enum class Type {
        String,
        File
    };
    enum class Direction {
        Input,
        Output
    };

    Q_ENUM(Type)
    explicit WorkFlowStepField(QObject *parent = nullptr);

    Type type() const;
    QString typeName() const;
    void setType(Type newType);

    QString name() const;
    void setName(const QString &newName);

    QString defaultValue() const;
    void setDefaultValue(const QString &newDefaultValue);

    QString value() const;
    void setValue(const QString &newValue);

    Direction direction() const;
    void setDirection(Direction newDirection);

    QJsonObject serialize() const;
    void deserialize(const QJsonObject &obj);

Q_SIGNALS:
    void typeChanged();
    void nameChanged();
    void defaultValueChanged();
    void valueChanged();
    void directionChanged();

private:
    Type m_type;
    QString m_name;
    QString m_defaultValue;
    QString m_value;
    Direction m_direction;
};
