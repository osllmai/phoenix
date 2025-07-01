import QtQuick 2.15
import QtQuick.Controls
import '../../component_library/style' as Style
import '../../component_library/button'
import "./history"

Drawer{
    id: historyDrawerId
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
    // NotificationDialog {
    //     id: modelIsloadedDialog2Id
    //     z:100
    //     titleText: "Loading Model"
    //     about: "Please wait until the model finishes loading. You can stop the process after the loading is complete."
    // }
}
