#include "abstracttool.h"

AbstractTool::AbstractTool(WorkFlowEditorArea *parentArea)
    : _parentArea{parentArea}
{}

void AbstractTool::activate() {}

void AbstractTool::deactivate() {}

WorkFlowEditorArea *AbstractTool::parentArea() const
{
    return _parentArea;
}

bool AbstractTool::isActive() const
{
    return m_isActive;
}

void AbstractTool::setActive(bool newIsActive)
{
    if (m_isActive == newIsActive)
        return;
    m_isActive = newIsActive;
    emit isActiveChanged();

    if (newIsActive)
        activate();
    else
        deactivate();
}
