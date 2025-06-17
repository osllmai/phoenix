import QtQuick 2.15
import '../../component_library/style' as Style
import "../../component_library/button"
import "../../menu"

Item{
    id:headerId
    width: parent.width; height: 60
    signal openModelSettingsDrawer()
    signal openHistoryDrawer()
    function openModelComboBox(){
        currentModelComboBoxId.popup.open();
    }

    clip: true

    Row{
        spacing: 10
        anchors.left: parent.left; anchors.leftMargin: 24
        anchors.top: parent.top; anchors.topMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        MyOpenMenuButton{
            id: openMenuId
        }
        MyButton{
            id: newChatId
            visible: !conversationList.isEmptyConversation
            anchors.verticalCenter: openMenuId.verticalCenter
            myText: (headerId.width<500)? "": "New Chat"
            myIcon: "qrc:/media/icon/add.svg"
            bottonType: Style.RoleEnum.BottonType.Primary
            Connections {
                target: newChatId
                function onClicked(){
                    conversationList.isEmptyConversation = true
                }
            }
        }
        ModelChatComboBox{
            id: currentModelComboBoxId
        }
    }

    Row{
        spacing: 10
        anchors.right: parent.right; anchors.rightMargin: 24
        anchors.top: parent.top; anchors.topMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        MyButton{
            id: openModelSettingsId
            myIcon: "qrc:/media/icon/settings.svg"
            bottonType: Style.RoleEnum.BottonType.Secondary
            Connections {
                target: openModelSettingsId
                function onClicked(){
                    headerId.openModelSettingsDrawer()
                }
            }
        }
        MyButton{
            id: openHistoryId
            myIcon: "qrc:/media/icon/history.svg"
            bottonType: Style.RoleEnum.BottonType.Secondary
            Connections {
                target: openHistoryId
                function onClicked(){
                    headerId.openHistoryDrawer()
                }
            }
        }
    }
}
