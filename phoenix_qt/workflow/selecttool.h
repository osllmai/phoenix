#pragma once

#include "abstracttool.h"

#include <QPointF>

class Block;
class SelectTool : public AbstractTool
{
    Q_OBJECT
    // QML_ELEMENT

public:
    SelectTool(WorkFlowEditorArea *parentArea);

    ChildMouseEventFilterResult childMouseEventFilter(QQuickItem *, QEvent *);

private:
    QPointF _clickMousePos;
    QPointF _clickItemPos;
    Block *_selectedBlock;
};
