#pragma once

#include "abstracttool.h"

class RelationHandle;
class AbstractRelation;
class RelationTool : public AbstractTool
{
    Q_OBJECT
    QML_ELEMENT

public:
    RelationTool(WorkFlowEditorArea *parentArea);

    ChildMouseEventFilterResult childMouseEventFilter(QQuickItem *, QEvent *) override;

    QQuickItem *highlightItem() const;
    void setHighlightItem(QQuickItem *newHighlightItem);

private:
    void findHandles();
    RelationHandle *_firstHandle{nullptr};
    RelationHandle *_secondHandle{nullptr};
    QQuickItem *_highlightItem{nullptr};
    AbstractRelation *_preview;
    QList<RelationHandle *> _handles;

    // AbstractTool interface
protected:
    void activate();
    void deactivate();
};
