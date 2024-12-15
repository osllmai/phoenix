#include "workflowstep.h"

#include "workflowrunner.h"
#include "workflowstepfield.h"

WorkFlowStep::WorkFlowStep(WorkFlowRunner *parent)
    : QObject{parent}
    , _parentRunner{parent}
{}

void WorkFlowStep::run() {}

WorkFlowStepField *WorkFlowStep::createInputField(const QString &name)
{
    auto field = new WorkFlowStepField{this};
    field->setName(name);
    field->setDirection(WorkFlowStepField ::Direction::Input);
    _fields << field;
    return field;
}

WorkFlowStepField *WorkFlowStep::createOutputField(const QString &name)
{
    auto field = new WorkFlowStepField{this};
    field->setName(name);
    field->setDirection(WorkFlowStepField ::Direction::Input);
    _fields << field;
    return field;
}
