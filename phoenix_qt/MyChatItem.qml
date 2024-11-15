import QtQuick 2.15
import QtQuick.Controls
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
        Rectangle{
            id:recTexxt
            anchors.fill:parent
            color: "#00ffffff"
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
            MouseArea {
                id:mouseAreaChatItem
                anchors.fill:parent
                onClicked: {
                    control.myChatListModel.currentChat = control.myChatListModel.getChat(control.myIndex);
                    chatIcon.open()
                }
                hoverEnabled: true
                onHoveredChanged: {
                    if(containsMouse){
                        if(control.myChatListModel.currentChat !== control.myChatListModel.getChat(control.myIndex) ){
                            backgroundId.color = control.hoverButtonColor
                            chatIcon.open()
                        }
                    }else{
                        if(control.myChatListModel.currentChat === control.myChatListModel.getChat(control.myIndex)){
                            backgroundId.color=control.selectButtonColor
                        }else{
                            backgroundId.color=control.normalButtonColor
                            // chatIcon.close()
                        }
                    }
                }
            }
        }

        Popup {
            id: chatIcon
            width: 60
            height: 30
            x: recTexxt.width -60
            y: 0
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside


            background:Rectangle{
                color: "#00ffffff" // Background color of tooltip
                radius: 4
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 3
                anchors.bottomMargin: 0
            }

            MyIcon {
                id: deleteIcon
                // visible: control.myChatListModel.currentChat === control.myChatListModel.getChat(myIndex)
                width: 30
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 0
                anchors.leftMargin: 0
                myLable: " delete this chat"
                myIconId: "images/deleteIcon.svg"
                myFillIconId: "images/fillDeleteIcon.svg"
                normalColor: control.iconColor
                hoverColor: control.fillIconColor
                Connections {
                    target: deleteIcon
                    function onClicked() {
                        // deleteIcon.visible = true
                        // editIcon.visible = true
                        control.myChatListModel.deleteChat(control.myIndex)
                    }
                }
            }

            MyIcon {
                id: editIcon
                // visible: control.myChatListModel.currentChat === myChatListModel.getChat(myIndex)
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
                        // deleteIcon.visible = true
                        // editIcon.visible = true
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
