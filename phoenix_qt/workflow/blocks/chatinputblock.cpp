#include "chatinputblock.h"

#include "workflowstepfield.h"

ChatInputBlock::ChatInputBlock(WorkFlowRunner *parent)
    : WorkFlowStep{parent, "Chat input"}
{
    _inputField = createInputField("input");
}

void ChatInputBlock::run()
{
    Q_EMIT finished();
}

bool ChatInputBlock::checkReady() const {
    return !_inputField->value().toString().isEmpty();
}
