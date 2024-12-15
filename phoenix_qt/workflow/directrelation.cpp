#include "directrelation.h"

#include <QPainter>

#include "workfloweditorarea.h"

DirectRelation::DirectRelation(QQuickItem *parent)
    : AbstractRelation{parent}
{}

void DirectRelation::paint(QPainter *painter)
{
    painter->setPen(QPen(color(), 2));
    painter->setRenderHint(QPainter::Antialiasing);

    switch (_lineType) {
    case DirectRelation::LineType::Horizontal:
        painter->drawLine(0, 0, width() - 1, 0);
        break;
    case DirectRelation::LineType::Vertical:
        painter->drawLine(0, 0, 0, height() - 1);
        break;
    case LineType::FlineHori:
        painter->drawLine(0, 0, width() - 1, height() - 1);
        break;
    case LineType::BLineHori:
        painter->drawLine(width() - 1, 0, 0, height() - 1);
        break;
    }
}

void DirectRelation::updateGeometry()
{
    QPointF startPt;
    QPointF endPt;
    if (startHandle())
        startPt = startHandle()->mapToItem(area(),
                                           startHandle()->width() / 2,
                                           startHandle()->height() / 2);
    else
        startPt = startPoint();

    if (endHandle())
        endPt = endHandle()->mapToItem(area(), endHandle()->width() / 2, endHandle()->height() / 2);
    else
        endPt = endPoint();

    QRectF boundingRect;

    if (startPt.x() == endPt.x()) {
        _lineType = LineType::Vertical;
        boundingRect.setTopLeft(QPointF(startPt.x(), qMin(startPt.y(), endPt.y())));
        boundingRect.setBottomRight(QPointF(startPt.x() + 1, qMax(startPt.y(), endPt.y())));
    } else if (startPt.y() == endPt.y()) {
        _lineType = LineType::Horizontal;
        boundingRect.setTopLeft(QPointF(qMin(startPt.x(), endPt.x()), startPt.y()));
        boundingRect.setBottomRight(QPointF(qMax(startPt.x(), endPt.x()), startPt.y() + 1));
    } else {
        if ((startPt.x() > endPt.x() && startPt.y() > endPt.y())
            || (startPt.x() < endPt.x() && startPt.y() < endPt.y()))
            _lineType = LineType::FlineHori;
        else
            _lineType = LineType::BLineHori;

        boundingRect.setTopLeft(QPointF(qMin(startPt.x(), endPt.x()), qMin(startPt.y(), endPt.y())));
        boundingRect.setBottomRight(
            QPointF(qMax(startPt.x(), endPt.x()), qMax(startPt.y(), endPt.y())));
    }
    setX(boundingRect.x());
    setY(boundingRect.y());
    setWidth(boundingRect.width());
    setHeight(boundingRect.height());
}
