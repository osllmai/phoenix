import QtQuick 2.15
import QtQuick.Controls
import '../../component_library/style' as Style
import "../../component_library/model_settings"

Drawer{
    id: drawerId
    width: 320
    height: parent.height
    interactive: true
    edge: Qt.RightEdge

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        color: Style.Colors.overlayDrawer
    }
    background: null
    ModelSettingsView{
        id: modelSettingsId
    }
}
