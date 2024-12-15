#include "abstractrelation.h"

#include "block.h"
#include "workfloweditorarea.h"

namespace {
constexpr int margin{10};
}

AbstractRelation::AbstractRelation(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , m_startPoint(0, 0)
    , m_endPoint(0, 0)
{
}

QPointF AbstractRelation::startPoint() const
{
    return m_startPoint;
}

void AbstractRelation::setStartPoint(const QPointF &point)
{
    if (m_startPoint != point) {
        m_startHandle = nullptr;
        m_startPoint = point;
        emit startPointChanged();
        updateGeometry();
        update();
    }
}

QPointF AbstractRelation::endPoint() const
{
    return m_endPoint;
}

void AbstractRelation::setEndPoint(const QPointF &point)
{
    if (m_endPoint != point) {
        m_endHandle = nullptr;
        m_endPoint = point;
        emit endPointChanged();
        updateGeometry();
        update();
    }
}

WorkFlowEditorArea *AbstractRelation::area() const
{
    return _area;
}

void AbstractRelation::setArea(WorkFlowEditorArea *newArea)
{
    _area = newArea;
    setParentItem(newArea);
}

RelationHandle *AbstractRelation::startHandle() const
{
    return m_startHandle;
}

void AbstractRelation::setStartHandle(RelationHandle *newStartHandle)
{
    if (m_startHandle == newStartHandle)
        return;

    if (m_startHandle)
        disconnect(m_startHandle->parentBlock(), nullptr, this, nullptr);
    m_startHandle = newStartHandle;
    updateGeometry();
    emit startHandleChanged();

    connect(newStartHandle->parentBlock(), &Block::moving, this, &AbstractRelation::updateGeometry);
}

RelationHandle *AbstractRelation::endHandle() const
{
    return m_endHandle;
}

void AbstractRelation::setEndHandle(RelationHandle *newEndHandle)
{
    if (m_endHandle == newEndHandle)
        return;

    if (m_endHandle)
        disconnect(m_endHandle->parentBlock(), nullptr, this, nullptr);

    m_endHandle = newEndHandle;
    updateGeometry();
    emit endHandleChanged();

    connect(newEndHandle->parentBlock(), &Block::moving, this, &AbstractRelation::updateGeometry);
}

QColor AbstractRelation::color() const
{
    return m_color;
}

void AbstractRelation::setColor(const QColor &newColor)
{
    if (m_color == newColor)
        return;
    m_color = newColor;
    emit colorChanged();
    update();
}
