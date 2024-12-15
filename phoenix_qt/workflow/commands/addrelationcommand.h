#pragma once

#include <QUndoCommand>
#include <QUuid>

class WorkFlowEditorArea;
class QQmlComponent;
class AbstractRelation;
class RelationHandle;
class AddRelationCommand : public QUndoCommand
{
public:
    AddRelationCommand(WorkFlowEditorArea *parent,
                       QQmlComponent *relationComponent,
                       const QUuid &from,
                       const QUuid &to);

    void undo() override;
    void redo() override;

private:
    WorkFlowEditorArea *_parent;
    QQmlComponent *_relationComponent;
    QUuid _from;
    QUuid _to;
    AbstractRelation *addRelation(RelationHandle *from, RelationHandle *to);
};
