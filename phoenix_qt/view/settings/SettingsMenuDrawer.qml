import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Controls 6.0

import '../component_library/style' as Style

Drawer{
    id: drawerId
    width: settingsMenuId.width
    height: parent.height
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

// Popup {
//     id: drawerId
//     modal: true
//     focus: true
//     x: 0
//     y: 0
//     width: settingsMenuId.width
//     height: parent.height
//     closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
//     background: null

//     Behavior on x {
//         NumberAnimation {
//             duration: 250
//             easing.type: Easing.InOutQuad
//         }
//     }

//     SettingsMenu {
//         anchors.fill: parent
//     }
// }
