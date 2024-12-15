#include "addrelationcommand.h"

#include "workfloweditorarea.h"
#include "abstractrelation.h"
#include "block.h"
#include "directrelation.h"

#include <QQmlEngine>

AddRelationCommand::AddRelationCommand(WorkFlowEditorArea *parent,
                                       QQmlComponent *relationComponent,
                                       const QUuid &from,
                                       const QUuid &to)
    : _parent{parent}
    , _relationComponent{relationComponent}
    , _from{from}
    , _to{to}
{}

void AddRelationCommand::undo() {}

void AddRelationCommand::redo() {
    auto fromBlock = _parent->findBlock(_from);
    auto toBlock = _parent->findBlock(_to);

    auto fromList = fromBlock->handles(RelationHandle::HandleType::Output);
    auto toList = toBlock->handles(RelationHandle::HandleType::Input);

    if (!fromList.size() || !toList.size())
        return;

    addRelation(fromList.first(), toList.first());
}


AbstractRelation *AddRelationCommand::addRelation(RelationHandle *from, RelationHandle *to)
{
    AbstractRelation *rel{};
    if (_relationComponent) {
        auto context = QQmlEngine::contextForObject(_relationComponent); // Get a valid context
        if (!context) {
            qDebug() << "Failed to get a valid QQmlContext!";
            return nullptr;
        }

        auto obj = _relationComponent->create(context);
        rel = qobject_cast<AbstractRelation *>(obj);
    }
    if (!rel)
        rel = new DirectRelation{_parent};
    rel->setArea(_parent);
    rel->setStartHandle(from);
    rel->setEndHandle(to);
    rel->setZ(15);
    rel->setVisible(true);

    from->setState(RelationHandle::HandleState::Connected);
    to->setState(RelationHandle::HandleState::Connected);
    return rel;
}
