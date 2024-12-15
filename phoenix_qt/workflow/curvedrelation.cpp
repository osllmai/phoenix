#include "curvedrelation.h"

#include <QPainter>
#include <QPainterPath>

#include "relationhandle.h"
#include "workfloweditorarea.h"

namespace {
constexpr int margin{10};
}

CurvedRelation::CurvedRelation(QQuickItem *parent)
    : AbstractRelation{parent}
{}

void CurvedRelation::paint(QPainter *painter)
{
    QPainterPath path;

    QPointF controlPoint1;
    QPointF controlPoint2;
    switch (_lineType) {
    case LineType::FlineHori:
        controlPoint1 = QPointF{width() / 2, 0};
        controlPoint2 = QPointF{width() / 2, height()};
        path.moveTo({margin, margin});
        path.cubicTo(controlPoint1, controlPoint2, {width() - margin, height() - margin});
        break;
    case LineType::BLineHori:
        controlPoint1 = QPointF{width() / 2, height()};
        controlPoint2 = QPointF{width() / 2, 0};
        path.moveTo({margin, height() - margin});
        path.cubicTo(controlPoint1, controlPoint2, {width() - margin, margin});
        break;
    }

    painter->setRenderHint(QPainter::Antialiasing);
    painter->setPen(QPen(color(), 2));
    painter->drawPath(path);
}

void CurvedRelation::updateGeometry()
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
        endPt = endHandle()->mapToItem(area(),
                                          endHandle()->width() / 2,
                                          endHandle()->height() / 2);
    else
        endPt = endPoint();

    if ((startPt.x() > endPt.x() && startPt.y() > endPt.y())
        || (startPt.x() < endPt.x() && startPt.y() < endPt.y()))
        _lineType = LineType::FlineHori;
    else
        _lineType = LineType::BLineHori;

    QRectF boundingRect;
    boundingRect.setTopLeft(
        QPointF(qMin(startPt.x(), endPt.x()), qMin(startPt.y(), endPt.y())));
    boundingRect.setBottomRight(
        QPointF(qMax(startPt.x(), endPt.x()), qMax(startPt.y(), endPt.y())));
    boundingRect.adjust(-margin, -margin, margin, margin); // Add some margin for the curve
    setX(boundingRect.x());
    setY(boundingRect.y());
    setWidth(boundingRect.width());
    setHeight(boundingRect.height());
}
