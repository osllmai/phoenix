import QtQuick 2.15
import QtQuick.Controls
import '../../component_library/style' as Style
import "./history"

Drawer{
    id: drawerId
    width: 320
    height: parent.height - 40
    y: 40

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
            }
            HistoryBody{
                id: historyBadyId
                height: parent.height - headerId.height
            }
        }
    }
}
