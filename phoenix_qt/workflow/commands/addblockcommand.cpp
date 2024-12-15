#include "addblockcommand.h"

#include <QDebug>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickItem>
#include <QUuid>

#include "workfloweditorarea.h"
#include "block.h"

AddBlockCommand::AddBlockCommand(WorkFlowEditorArea *parent,
                                 QQmlComponent *childComponent,
                                 const QVariantMap &props)
    : _parent{parent}
    , _childComponent{childComponent}
    , _props{props}
    , _uuid{QUuid::createUuid()}
{

}

void AddBlockCommand::undo()
{
    if (_childItem) {
        _childItem->deleteLater();
        _childItem = nullptr;
    }
}

void AddBlockCommand::redo()
{
    _childItem = nullptr;
    if (!_childComponent) {
        qDebug() << "Block component is null!";
        return;
    }

    if (_childComponent->status() != QQmlComponent::Ready) {
        qDebug() << "Component is not ready:" << _childComponent->errorString();
        return;
    }

    auto context = QQmlEngine::contextForObject(_childComponent); // Get a valid context
    if (!context)
        context = _childComponent->creationContext();
    if (!context) {
        qDebug() << "Failed to get a valid QQmlContext!";
        return;
    }

    auto obj = _childComponent->create(context);
    _childItem = qobject_cast<Block *>(obj);
    if (!_childItem) {
        qDebug() << "Failed to cast component to QQuickItem:" << _childComponent->errorString();
        delete obj;
        return;
    }

    // Set parent item and properties
    _childItem->setParentItem(_parent);
    _childItem->setZ(10);
    _childItem->setUuid(_uuid);
    _parent->_blocks << _childItem;

    for (auto it = _props.begin(); it != _props.end(); ++it)
        _childItem->setProperty(it.key().toUtf8().data(), it.value());
}
