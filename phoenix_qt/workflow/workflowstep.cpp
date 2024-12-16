#include "workflowstep.h"

#include "workflowrunner.h"
#include "workflowstepfield.h"

WorkFlowStep::WorkFlowStep(WorkFlowRunner *parent, const QString &name)
    : QObject{parent}
    , _parentRunner{parent}
    , m_name{std::move(name)}
{}

void WorkFlowStep::init() {}

void WorkFlowStep::run() {}

WorkFlowStepField *WorkFlowStep::createInputField(const QString &name)
{
    auto field = new WorkFlowStepField{this};
    field->setName(name);
    field->setDirection(WorkFlowStepField ::Direction::Input);
    _fields << field;

    Q_EMIT fieldsChanged();
    return field;
}

WorkFlowStepField *WorkFlowStep::createOutputField(const QString &name)
{
    auto field = new WorkFlowStepField{this};
    field->setName(name);
    field->setDirection(WorkFlowStepField ::Direction::Output);
    _fields << field;

    Q_EMIT fieldsChanged();
    return field;
}

QQmlListProperty<WorkFlowStepField> WorkFlowStep::fields()
{
    return QQmlListProperty<WorkFlowStepField>(this,
                                               &_fields,
                                               &WorkFlowStep::appendField,
                                               &WorkFlowStep::fieldCount,
                                               &WorkFlowStep::fieldAt,
                                               &WorkFlowStep::clearFields);
}

QList<WorkFlowStepField *> WorkFlowStep::fieldsList() const
{
    return _fields;
}

void WorkFlowStep::setFieldValue(const QString &name, const QVariant &value) {
    qDebug() << Q_FUNC_INFO << name << value;
    std::for_each(_fields.begin(), _fields.end(), [&](WorkFlowStepField *field) {
        if (field->name() == name)
            field->setValue(value);
    });
    Q_EMIT isReadyChanged();
}

WorkFlowRunner *WorkFlowStep::parentRunner() const
{
    return _parentRunner;
}

void WorkFlowStep::appendField(QQmlListProperty<WorkFlowStepField> *list, WorkFlowStepField *field) {
    auto *fields = static_cast<QList<WorkFlowStepField *> *>(list->data);
    fields->append(field);
}

qsizetype WorkFlowStep::fieldCount(QQmlListProperty<WorkFlowStepField> *list) {
    auto *fields = static_cast<QList<WorkFlowStepField *> *>(list->data);
    return fields->size();
}

WorkFlowStepField *WorkFlowStep::fieldAt(QQmlListProperty<WorkFlowStepField> *list, qsizetype index) {
    auto *fields = static_cast<QList<WorkFlowStepField *> *>(list->data);
    return fields->at(index);
}

void WorkFlowStep::clearFields(QQmlListProperty<WorkFlowStepField> *list) {
    auto *fields = static_cast<QList<WorkFlowStepField *> *>(list->data);
    qDeleteAll(*fields); // Optional: delete objects if necessary
    fields->clear();
}

bool WorkFlowStep::isReady() const
{
    return checkReady();
}

bool WorkFlowStep::checkReady() const
{
    return true;
}

QString WorkFlowStep::name() const
{
    return m_name;
}

void WorkFlowStep::setName(const QString &newName)
{
    if (m_name == newName)
        return;
    m_name = newName;
    emit nameChanged();
}
