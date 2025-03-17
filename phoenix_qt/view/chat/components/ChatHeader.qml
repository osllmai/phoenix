import QtQuick 2.15
import '../../component_library/style' as Style
import "../../component_library/button"
import "./model"

Item{
    id:headerId
    width: parent.width; height: 80
    signal openModelSettingsDrawer()
    signal openHistoryDrawer()
    clip: true

    function openModelList(){
        currentModelDialogId.open();
    }

    Row{
        spacing: 20
        anchors.left: parent.left; anchors.leftMargin: 24
        anchors.top: parent.top; anchors.topMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        MyButton{
            id: newChatId
            visible: !conversationList.isEmptyConversation
            myText: "New Chat"
            myIcon: "qrc:/media/icon/add.svg"
            bottonType: Style.RoleEnum.BottonType.Primary
            Connections {
                target: newChatId
                function onClicked(){
                    conversationList.isEmptyConversation = true
                }
            }
        }
        ModelButton{
            id: modelButtonId
        }
    }

    Row{
        spacing: 20
        anchors.right: parent.right; anchors.rightMargin: 24
        anchors.top: parent.top; anchors.topMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        MyButton{
            id: openModelSettingsId
            myText: "Model Settings"
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
            myText: "History"
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
    ModelDialog{
        id: currentModelDialogId
        y: modelButtonId.y + modelButtonId.height + 20 + 24
        x: modelButtonId.x + 20
        onClosed: {
            modelButtonId.isClose = true;
        }
    }
}
