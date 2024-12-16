#include "workflowstepfield.h"

#include <QMetaEnum>

// namespace SerializationFields {
// constexpr QString name{"name"};
// }
WorkFlowStepField::WorkFlowStepField(QObject *parent)
    : QObject{parent}
{}

QString WorkFlowStepField::typeName() const {
    auto e = QMetaEnum::fromType<Type>();
    return e.valueToKey(static_cast<int>(m_type));
}

WorkFlowStepField::Type WorkFlowStepField::type() const
{
    return m_type;
}

void WorkFlowStepField::setType(Type newType)
{
    if (m_type == newType)
        return;
    m_type = newType;
    Q_EMIT typeChanged();
    Q_EMIT typeAndDirChanged();
}

QString WorkFlowStepField::name() const
{
    return m_name;
}

void WorkFlowStepField::setName(const QString &newName)
{
    if (m_name == newName)
        return;
    m_name = newName;
    emit nameChanged();
}

QString WorkFlowStepField::defaultValue() const
{
    return m_defaultValue;
}

void WorkFlowStepField::setDefaultValue(const QString &newDefaultValue)
{
    if (m_defaultValue == newDefaultValue)
        return;
    m_defaultValue = newDefaultValue;
    emit defaultValueChanged();
}

QVariant WorkFlowStepField::value() const
{
    return m_value;
}

void WorkFlowStepField::setValue(const QVariant &newValue)
{
    if (m_value == newValue)
        return;
    m_value = newValue;
    emit valueChanged();
}

WorkFlowStepField::Direction WorkFlowStepField::direction() const
{
    return m_direction;
}

void WorkFlowStepField::setDirection(Direction newDirection)
{
    if (m_direction == newDirection)
        return;
    m_direction = newDirection;
    Q_EMIT directionChanged();
    Q_EMIT typeAndDirChanged();
}

QJsonObject WorkFlowStepField::serialize() const {
    QJsonObject obj;
    return obj;
}

void WorkFlowStepField::deserialize(const QJsonObject &obj) {}

QString WorkFlowStepField::typeAndDir() const
{
    auto e = QMetaEnum::fromType<Direction>();
    QString dir =  e.valueToKey(static_cast<int>(m_direction));

    return typeName() + "_" + dir;
}
