#pragma once

#include "relationhandle.h"

#include <QQuickItem>
#include <QQuickPaintedItem>

class WorkFlowEditorArea;
class AbstractRelation : public QQuickPaintedItem
{
    Q_OBJECT
    QML_UNCREATABLE("Abstract relation class")

    Q_PROPERTY(QPointF startPoint READ startPoint WRITE setStartPoint NOTIFY startPointChanged FINAL)
    Q_PROPERTY(QPointF endPoint READ endPoint WRITE setEndPoint NOTIFY endPointChanged FINAL)

    Q_PROPERTY(RelationHandle *startHandle READ startHandle WRITE setStartHandle NOTIFY
                   startHandleChanged FINAL)
    Q_PROPERTY(
        RelationHandle *endHandle READ endHandle WRITE setEndHandle NOTIFY endHandleChanged FINAL)

    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged FINAL)

public:
    AbstractRelation(QQuickItem *parent = nullptr);

    QPointF startPoint() const;
    void setStartPoint(const QPointF &point);

    QPointF endPoint() const;
    void setEndPoint(const QPointF &point);

    RelationHandle *startHandle() const;
    void setStartHandle(RelationHandle *newStartHandle);

    RelationHandle *endHandle() const;
    void setEndHandle(RelationHandle *newEndHandle);

    WorkFlowEditorArea *area() const;
    void setArea(WorkFlowEditorArea *newArea);

    QColor color() const;
    void setColor(const QColor &newColor);

protected:
    virtual void updateGeometry() = 0;

signals:
    void startPointChanged();
    void endPointChanged();
    void startHandleChanged();
    void endHandleChanged();
    void colorChanged();

private:
    QPointF m_startPoint;
    QPointF m_endPoint;

    RelationHandle *m_startHandle = nullptr;
    RelationHandle *m_endHandle = nullptr;
    WorkFlowEditorArea *_area;
    QColor m_color{Qt::black};
};
