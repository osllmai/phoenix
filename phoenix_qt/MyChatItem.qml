import QtQuick 2.15
import Phoenix
import Qt5Compat.GraphicalEffects


Item {
    id: control
    width: 150
    height: 30

    property var fontFamily

    property alias myTextId: textId.text
    property var myChatListModel
    property int myIndex

    property color fillIconColor
    property color iconColor
    property color normalButtonColor
    property color selectButtonColor
    property color hoverButtonColor
    property color chatMessageInformationTextColor
    property color glowColor

    Rectangle{
        id: backgroundId
        anchors.fill: parent
        color: control.myChatListModel.currentChat === control.myChatListModel.getChat(myIndex)?control.selectButtonColor:control.normalButtonColor
        radius: 2
        Text {
            id:  textId
            color: control.chatMessageInformationTextColor
            text: qsTr("Text Button")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: control.fontFamily
        }
        MyIcon {
            id: deleteIcon
            visible: control.myChatListModel.currentChat === control.myChatListModel.getChat(myIndex)
            width: 30
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 0
            myLable: " delete this chat"
            myIconId: "images/deleteIcon.svg"
            myFillIconId: "images/fillDeleteIcon.svg"
            normalColor: control.iconColor
            hoverColor: control.fillIconColor
            Connections {
                target: deleteIcon
                function onClicked() {
                    deleteIcon.visible = true
                    editIcon.visible = true
                    control.myChatListModel.deleteChat(control.myIndex)
                }
            }
        }
        MyIcon {
            id: editIcon
            visible: control.myChatListModel.currentChat === myChatListModel.getChat(myIndex)
            width: 30
            anchors.right: deleteIcon.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            anchors.topMargin: 0
            myLable: " edit chat name"
            myIconId: "images/editIcon.svg"
            myFillIconId: "images/fillEditIcon.svg"
            normalColor: control.iconColor
            hoverColor: control.fillIconColor
            Connections {
                target: editIcon
                function onClicked() {
                    deleteIcon.visible = true
                    editIcon.visible = true
                }
            }
        }
        MouseArea {
            id:mouseAreaChatItem
            anchors.right: editIcon.left
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            anchors.topMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            onClicked: {
                control.myChatListModel.currentChat = control.myChatListModel.getChat(control.myIndex);

            }

            hoverEnabled: true
            // {
            //     if(control.myChatListModel.currentChat !== control.myChatListModel.getChat(control.myIndex) ){
            //         backgroundId.color = control.selectColor
            //     }
            // }


            onHoveredChanged: {


                if(containsMouse){
                    if(control.myChatListModel.currentChat !== control.myChatListModel.getChat(control.myIndex) ){
                        backgroundId.color = control.hoverButtonColor
                    }
                }else{
                    if(control.myChatListModel.currentChat === control.myChatListModel.getChat(control.myIndex)){
                    backgroundId.color=control.selectButtonColor
                    }else{
                        backgroundId.color=control.normalButtonColor
                    }
                }
            }
        }

        layer.enabled: true
        layer.effect: Glow {
             samples: 15
             color: control.glowColor
             spread: 0.0
             transparentBorder: true
         }
    }
}
