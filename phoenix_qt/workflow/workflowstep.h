#pragma once

#include <QObject>
#include <QQmlEngine>

class WorkFlowRunner;
class WorkFlowStepField;
class WorkFlowStep : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    WorkFlowStep(WorkFlowRunner *parent);

    virtual void run();

Q_SIGNALS:
    void finished();

protected:
    WorkFlowStepField *createInputField(const QString &name);
    WorkFlowStepField *createOutputField(const QString &name);

private:
    WorkFlowRunner *_parentRunner;
    QList<WorkFlowStepField *> _fields;
};
