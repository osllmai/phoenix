#include "relationtool.h"

#include "block.h"
#include "directrelation.h"
#include "relationhandle.h"
#include "workfloweditorarea.h"

#include <QMouseEvent>

void findRelationHandles(QQuickItem* parent, QList<RelationHandle*>& result) {
    for (auto child : parent->childItems()) {
        auto handle = qobject_cast<RelationHandle*>(child);
        if (handle) {
            result.append(handle);
        }
        // Recursively search in child items
        findRelationHandles(child, result);
    }
}

RelationTool::RelationTool(WorkFlowEditorArea *parentArea)
    : AbstractTool{parentArea}
{
    _preview = new DirectRelation{parentArea};
    _preview->setZ(15);
    _preview->setVisible(false);
    _preview->setArea(parentArea);
}

RelationTool::ChildMouseEventFilterResult RelationTool::childMouseEventFilter(QQuickItem *item, QEvent *event) {
    // qDebug() << event->type();
    switch (event->type()) {
    case QEvent::HoverMove: {
        // qDebug() << "Hover" << item;
        auto b = qobject_cast<Block*>(item);
        if (item != _highlightItem && !b) {
            auto handle = qobject_cast<RelationHandle *>(item);

            if (handle) {
                // qDebug() << "Fid";

                auto rc = item->mapToItem(parentArea(),
                                          -10,
                                          -10,
                                          handle->width() + 20,
                                          handle->height() + 20);
                _highlightItem->setPosition(rc.topLeft());
                _highlightItem->setSize(rc.size());
                _highlightItem->setVisible(true);
            } else {
                _highlightItem->setVisible(false);
            }
        }
        break;
    }
    case QEvent::MouseButtonPress: {
        // qDebug() << "press";
        _firstHandle = qobject_cast<RelationHandle*>(item);

        QMouseEvent *mouseEvent = static_cast<QMouseEvent *>(event);
        if (mouseEvent->button() == Qt::LeftButton) {
            auto handles = parentArea()->findChildren<RelationHandle*>();
            auto handle = qobject_cast<RelationHandle *>(item);
            if (handle) {
                _preview->setStartHandle(handle);
                _preview->setEndHandle(handle);
                handle->setState(RelationHandle::HandleState::Connectig);
            }

            // Handle mouse press event for the child
            // qDebug() << "Mouse pressed on child at position:" << mouseEvent->pos()
                     // << handles.size();
            _preview->setVisible(true);
            _handles.clear();
            findRelationHandles(parentArea(), _handles);
            // qDebug() << _handles.size() << "item found";


            return ChildMouseEventFilterResult::False; // Continue with default processing
        }
        event->accept();
        break;
    }
    case QEvent::HoverLeave:
        // _highlightItem->setVisible(false);
        break;

    case QEvent::MouseMove: {
        if (_firstHandle) {
        QMouseEvent *mouseEvent = static_cast<QMouseEvent *>(event);
        // Handle mouse move event for the child

        auto p = item->mapToItem(parentArea(), mouseEvent->position());
        auto it = std::find_if(_handles.begin(), _handles.end(), [this, &p](RelationHandle *h) {
            auto handleRelPos = h->mapToItem(parentArea(), {0, 0});
            return handleRelPos.x() <= p.x() && handleRelPos.y() <= p.y() && handleRelPos.x() + h->width() >= p.x()
                   && handleRelPos.y() + h->height() >= p.y();
        });

        RelationHandle *h;
        if (it == _handles.end())
            h = nullptr;
        else
            h = *it;

        if (h) {
            if (_secondHandle && h != _secondHandle)
                _secondHandle->setState(RelationHandle::HandleState::UnConnected);
            _secondHandle = h;
            _secondHandle->setState(RelationHandle::HandleState::Connectig);
            auto handlePos = _secondHandle->mapToItem(parentArea(), {0, 0});
            _highlightItem->setPosition({handlePos.x() - 10, handlePos.y() - 10});
            _highlightItem->setSize({_secondHandle->width() + 20, _secondHandle->height() + 20});
            _highlightItem->setVisible(true);
            _preview->setEndHandle(_secondHandle);
        } else {
            _highlightItem->setVisible(true);
            _preview->setEndPoint(item->mapToItem(parentArea(), mouseEvent->position()));
        }

        // qDebug() << "Mouse moved on child to position:" << _secondHandle << p;
        return ChildMouseEventFilterResult::False; // Continue with default processing
        }
    }
    case QEvent::MouseButtonRelease: {
        QMouseEvent *mouseEvent = static_cast<QMouseEvent *>(event);
        _highlightItem->setVisible(false);
        _preview->setVisible(false);
        if (mouseEvent->button() == Qt::LeftButton) {
            // Handle mouse release event for the child
            qDebug() << "Mouse released on child at position:" << _firstHandle << _secondHandle;

            if (_firstHandle && _secondHandle) {
                // auto rel = new Relation{parentArea()};
                // rel->setArea(parentArea());
                // rel->setStartHandle(_firstHandle);
                // rel->setEndHandle(_secondHandle);
                // rel->setZ(15);
                // rel->setVisible(true);
                auto rel = parentArea()->addRelation(_firstHandle, _secondHandle);
                // qDebug() << "Relation created" <<rel->position() << rel->size();
            }
            return ChildMouseEventFilterResult::False; // Continue with default processing
        }
        break;
    }
    default:
        break;
    }

    return ChildMouseEventFilterResult::CallParent;
}

QQuickItem *RelationTool::highlightItem() const
{
    return _highlightItem;
}

void RelationTool::setHighlightItem(QQuickItem *newHighlightItem)
{
    _highlightItem = newHighlightItem;
    newHighlightItem->setAcceptHoverEvents(false);
    newHighlightItem->setAcceptedMouseButtons(Qt::NoButton);
    // newHighlightItem->setFlag();
}

void RelationTool::findHandles() {
    _handles.clear();
    auto blocks = parentArea()->findChildren<Block*>();
    for (auto block : blocks)
        for (auto child : block->childItems()) {
            auto handle = qobject_cast<RelationHandle *>(child);
            if (handle) {
                _handles << handle;
            }
            // Recursively search in child items
            // findRelationHandles(child, result);
        }
    qDebug() << _handles.size() << "item found";
}

void RelationTool::activate() {}

void RelationTool::deactivate() {
    _highlightItem->setVisible(false);
    _preview->setVisible(false);
}
