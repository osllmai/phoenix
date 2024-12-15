#pragma once

#include "abstractrelation.h"

class DirectRelation : public AbstractRelation
{
    Q_OBJECT
    QML_ELEMENT

public:
    DirectRelation(QQuickItem *parent = nullptr);
    void paint(QPainter *painter) override;

protected:
    void updateGeometry();

private:
    enum class LineType {
        BLineHori, /* //  */
        FlineHori, /* \\  */
        Horizontal,
        Vertical
    } _lineType;
};
