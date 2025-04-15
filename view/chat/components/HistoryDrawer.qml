import QtQuick 2.15
import QtQuick.Controls
import '../../component_library/style' as Style
import "./history"

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
            HistoryHeader{
                id: headerId
                Connections{
                    target: headerId
                    function onCloseDrawer(){
                        drawerId.close()
                    }
                }
            }
            HistoryBody{
                id: historyBadyId
                height: parent.height - headerId.height
            }
        }
    }
}
