#include "outputstep.h"

#include "workflowrunner.h"

OutputStep::OutputStep(WorkFlowRunner *parent)
    : WorkFlowStep{parent, "Output"}
{
    createOutputField("output");
}

void OutputStep::init()
{
    _outputField = parentRunner()->field("output");
}

void OutputStep::run()
{
    Q_EMIT finished();
}
