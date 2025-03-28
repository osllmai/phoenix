import QtQuick 2.15
import QtQuick.Controls
import '../../component_library/style' as Style
import "./model_settings"

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
    Rectangle {
        color: Style.Colors.background
        anchors.fill: parent
        border.width: 0
        Column{
            anchors.fill: parent
            anchors.margins: 16
            ModelSettingsHeader{
                id: headerId
                Connections{
                    target: headerId
                    function onCloseDrawer(){
                        drawerId.close()
                    }
                }
            }
            ModelSettingsBody{
                id: historyBadyId
            }
        }
    }
}
