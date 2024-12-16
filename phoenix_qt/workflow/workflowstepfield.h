#pragma once

#include <QJsonObject>
#include <QObject>
#include <QQmlEngine>

class WorkFlowStepField : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(Type type READ type WRITE setType NOTIFY typeChanged FINAL)
    Q_PROPERTY(Direction direction READ direction WRITE setDirection NOTIFY directionChanged FINAL)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged FINAL)
    Q_PROPERTY(QString defaultValue READ defaultValue WRITE setDefaultValue NOTIFY defaultValueChanged FINAL)
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged FINAL)
    Q_PROPERTY(QString typeName READ typeName NOTIFY typeChanged FINAL)
    Q_PROPERTY(QString typeAndDir READ typeAndDir NOTIFY typeAndDirChanged FINAL)
public:
    enum class Type {
        String,
        File
    };
    Q_ENUM(Type)

    enum class Direction {
        Input,
        Output
    };
    Q_ENUM(Direction)

    explicit WorkFlowStepField(QObject *parent = nullptr);

    Type type() const;
    QString typeName() const;
    void setType(Type newType);

    QString name() const;
    void setName(const QString &newName);

    QString defaultValue() const;
    void setDefaultValue(const QString &newDefaultValue);

    QVariant value() const;
    void setValue(const QVariant &newValue);

    Direction direction() const;
    void setDirection(Direction newDirection);

    QJsonObject serialize() const;
    void deserialize(const QJsonObject &obj);

    QString typeAndDir() const;

Q_SIGNALS:
    void typeChanged();
    void nameChanged();
    void defaultValueChanged();
    void valueChanged();
    void directionChanged();

    void typeAndDirChanged();

private:
    Type m_type{Type::String};
    QString m_name;
    QString m_defaultValue;
    QVariant m_value;
    Direction m_direction{Direction::Input};
    QString m_typeAndDir;
};
