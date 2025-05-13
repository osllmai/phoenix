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
        id: developerBodyId
        anchors.top: headerId.bottom; anchors.bottom: parent.bottom
        width: parent.width
        Connections{
            target: developerBodyId
            function onOpenModelList(){
                headerId.openModelComboBox();
            }
        }
    }
    ModelSettingsDrawerDeveloper{
        id: modelSettingsId
    }
}
