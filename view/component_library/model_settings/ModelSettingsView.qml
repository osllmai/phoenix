import QtQuick 2.15
import QtQuick.Controls
import '../style' as Style

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
