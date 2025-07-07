import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Controls 6.0

import '../component_library/style' as Style

Drawer{
    id: drawerId
    width: settingsMenuId.width
    height: parent.height - 40
    y: 40
    interactive: true
    edge: Qt.LeftEdge

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        color: Style.Colors.overlayDrawer
    }
    background: null
    SettingsMenu{
        id: settingsMenuId
    }
}
