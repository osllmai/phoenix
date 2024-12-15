#pragma once

#include <QObject>
#include <QQmlEngine>

class QQuickItem;
class QEvent;
class WorkFlowEditorArea;

class AbstractTool : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isActive READ isActive WRITE setActive NOTIFY isActiveChanged FINAL)

public:
    AbstractTool(WorkFlowEditorArea *parentArea);
    enum class ChildMouseEventFilterResult { True, False, CallParent };

    virtual ChildMouseEventFilterResult childMouseEventFilter(QQuickItem *, QEvent *) = 0;

    WorkFlowEditorArea *parentArea() const;

    bool isActive() const;
    void setActive(bool newIsActive);

protected:
    virtual void activate();
    virtual void deactivate();

Q_SIGNALS:
    void isActiveChanged();

private:
    WorkFlowEditorArea *_parentArea;
    bool m_isActive;
};
