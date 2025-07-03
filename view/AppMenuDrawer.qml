import QtQuick
import QtQuick.Controls.Basic
import './component_library/style' as Style

Drawer{
    id: drawerId
    width: appMenuId.width
    height: parent.height - 40
    y: 40

    interactive: true
    edge: Qt.LeftEdge

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        color: Style.Colors.overlayDrawer
    }
    background: null
    AppMenu{
        id: appMenuId
        isDrawer: true
    }
}
