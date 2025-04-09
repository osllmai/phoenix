import QtQuick
import QtQuick.Controls.Basic
import './component_library/style' as Style
import './component_library/button'
import "./menu"

Drawer{
    id: drawerId
    width: appMenuId.width
    height: parent.height
    interactive: true
    edge: Qt.LeftEdge

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        color: Style.Colors.overlayDrawer
    }
    background: null
    AppMenu{
        id: appMenuId
    }
}
