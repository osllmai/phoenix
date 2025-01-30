import QtQuick 2.15
import '../../component_library/style' as Style
import "../../component_library/button"

Item{
    id:headerId
    signal openModelSettingsDrawer()
    signal openHistoryDrawer()
    clip:true

    Row{
        spacing: 20
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        MyButton{
            id: newChatId
            myText: "New Chat"
            myIcon: "../../media/icon/add.svg"
            bottonType: Style.RoleEnum.BottonType.Primary
            Connections {
                target: newChatId
                function onActionClicked(){
                    headerId.openHistoryDrawer()
                }
            }
        }
        MyButton{
            id: openModelSettingsId
            myText: "Model Settings"
            myIcon: "../../media/icon/settings.svg"
            bottonType: Style.RoleEnum.BottonType.Secondary
            Connections {
                target: openModelSettingsId
                function onActionClicked(){
                    headerId.openModelSettingsDrawer()
                }
            }
        }
        MyButton{
            id: openHistoryId
            myText: "History"
            myIcon: "../../media/icon/history.svg"
            bottonType: Style.RoleEnum.BottonType.Secondary
            Connections {
                target: openHistoryId
                function onActionClicked(){
                    headerId.openHistoryDrawer()
                }
            }
        }
    }
}
