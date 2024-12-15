#include "selecttool.h"

#include <QMouseEvent>
#include <QQuickItem>

#include "workfloweditorarea.h"
#include "block.h"

SelectTool::SelectTool(WorkFlowEditorArea *parentArea)
    : AbstractTool{parentArea}
{}

AbstractTool::ChildMouseEventFilterResult SelectTool::childMouseEventFilter(QQuickItem *child, QEvent *event)
{
    switch (event->type()) {
    case QEvent::MouseButtonPress: {
        QMouseEvent *mouseEvent = static_cast<QMouseEvent *>(event);

        _selectedBlock= qobject_cast<Block*>(child);
        if (_selectedBlock && mouseEvent->button() == Qt::LeftButton) {
            _clickMousePos = mouseEvent->globalPosition();
            _clickItemPos = child->position();
            event->accept();
            return ChildMouseEventFilterResult::True;
        }
        break;
    }
    case QEvent::MouseMove: {
        if (_selectedBlock) {
            QMouseEvent *mouseEvent = static_cast<QMouseEvent *>(event);
            QPointF delta = mouseEvent->globalPosition() - _clickMousePos;
            _selectedBlock->setPosition(_clickItemPos + delta);
            Q_EMIT _selectedBlock->moving();
        } else {
        }
        return ChildMouseEventFilterResult::False;
    }
    case QEvent::MouseButtonRelease: {
        QMouseEvent *mouseEvent = static_cast<QMouseEvent *>(event);
        if (mouseEvent->button() == Qt::LeftButton) {
            return ChildMouseEventFilterResult::False;
        }
        break;
    }
    default:
        break;
    }

    return ChildMouseEventFilterResult::CallParent;
}
