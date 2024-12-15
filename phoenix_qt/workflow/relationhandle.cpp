#include "relationhandle.h"

#include "block.h"

RelationHandle::RelationHandle(QQuickItem *parent)
    : QQuickItem{parent}
{
    setAcceptHoverEvents(true);
    setAcceptedMouseButtons(Qt::LeftButton);
}

RelationHandle::HandleType RelationHandle::type() const
{
    return m_type;
}

void RelationHandle::setType(HandleType newType)
{
    if (m_type == newType)
        return;
    m_type = newType;
    Q_EMIT typeChanged();
}

void RelationHandle::mousePressEvent(QMouseEvent *event) {
    QQuickItem::mousePressEvent(event);
    event->accept();
}

Block *RelationHandle::parentBlock() const
{
    return _parentBlock;
}

void RelationHandle::setParentBlock(Block *newParentBlock)
{
    _parentBlock = newParentBlock;
}

void RelationHandle::componentComplete() {
    QQuickItem::componentComplete();
    _parentBlock = qobject_cast<Block*>(parentItem());
}

RelationHandle::HandleState RelationHandle::state() const
{
    return m_state;
}

void RelationHandle::setState(HandleState newState)
{
    if (m_state == newState)
        return;
    m_state = newState;
    emit stateChanged();
}
