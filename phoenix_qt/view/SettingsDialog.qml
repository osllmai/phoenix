import QtQuick
import QtQuick.Controls
import './component_library/style' as Style

Dialog {
    id: settingsDialog
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: (2*parent.width)/3
    height: (2*parent.height)/3
    parent: Overlay.overlay

    Overlay.modal: Rectangle {
        color: Style.Theme.colorOverlay
    }

    focus: true
    modal: true

    background: null
    Rectangle{
        id:settingsPage
        anchors.fill: parent
        color: Style.Theme.backgroungColor

    }
}
