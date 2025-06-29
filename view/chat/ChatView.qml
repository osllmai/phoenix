import QtQuick 2.15
import "./components"

Item {
    ChatHeader{
        id: headerId
        Connections{
            target: headerId
            function onOpenModelSettingsDrawer(){
                modelSettingsId.open()
            }

            function onOpenHistoryDrawer(){
                historyId.open()
            }
            function onSendMessage(){
                chatBodyId.sendMessage()
            }

        }
    }
    ChatBody{
        id: chatBodyId
        anchors.top: headerId.bottom; anchors.bottom: parent.bottom
        Connections{
            target: chatBodyId
            function onOpenModelList(){
                headerId.openModelComboBox();
            }
        }
    }
    HistoryDrawer{
        id: historyId
    }
    ModelSettingsChatDrawer{
        id: modelSettingsId
    }
}
