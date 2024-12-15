#pragma once

#include <QUndoCommand>
#include <QUuid>
#include <QVariantMap>

class WorkFlowEditorArea;
class QQmlComponent;
class Block;
class AddBlockCommand : public QUndoCommand
{
public:
    AddBlockCommand(WorkFlowEditorArea *parent, QQmlComponent *childComponent, const QVariantMap &props = {});

    void undo() override;
    void redo() override;

private:
    WorkFlowEditorArea *_parent;
    QQmlComponent *_childComponent;
    QVariantMap _props;
    Block *_childItem;
    QUuid _uuid;

    friend class WorkFlowEditorArea;
};
