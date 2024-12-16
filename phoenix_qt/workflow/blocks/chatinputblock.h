#pragma once

#include <workflowstep.h>

class ChatInputBlock : public WorkFlowStep
{
    Q_OBJECT
    QML_ELEMENT

public:
    ChatInputBlock(WorkFlowRunner *parent);
    void run() override;

protected:
    bool checkReady() const override;

private:
    WorkFlowStepField *_inputField;

};
