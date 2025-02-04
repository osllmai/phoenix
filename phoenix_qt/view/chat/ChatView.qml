import QtQuick 2.15
import "./components"

Item {
    ChatHeader{
        id: headerId
        width: parent.width; height: 60
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
    ChatBody{
        id: chatBodyId
        anchors.top: headerId.bottom; anchors.bottom: parent.bottom
    }
    HistoryDrawer{
        id: historyId
    }
    ModelSettingsDrawer{
        id: modelSettingsId
    }
}
