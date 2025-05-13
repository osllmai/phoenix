import QtQuick 2.15
import "./components"

Item {
    DeveloperHeader{
        id: headerId
        Connections{
            target: headerId
            function onOpenModelSettingsDrawer(){
                modelSettingsId.open()
            }

            function onOpenHistoryDrawer(){
                historyId.open()
            }
        }
    }
    DeveloperBody{
        id: chatBodyId
        anchors.top: headerId.bottom; anchors.bottom: parent.bottom
        Connections{
            target: chatBodyId
            function onOpenModelList(){
                headerId.openModelComboBox();
            }
        }
    }
}
