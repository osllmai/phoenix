#pragma once

#include "abstractrelation.h"

class CurvedRelation : public AbstractRelation
{
    Q_OBJECT
    QML_ELEMENT

public:
    CurvedRelation(QQuickItem *parent = nullptr);

    void paint(QPainter *painter) override;

private:
    enum class LineType {
        BLineHori, /* //  */
        FlineHori  /* \\  */
    } _lineType;

protected:
    void updateGeometry();
};
