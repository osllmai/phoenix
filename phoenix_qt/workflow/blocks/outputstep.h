#pragma once

#include <workflowstep.h>

class OutputStep : public WorkFlowStep
{
    Q_OBJECT

public:
    OutputStep(WorkFlowRunner *parent);

    void init() override;
    void run() override;

private:
    WorkFlowStepField *_outputField;
};
