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
    // property var myChatListModel
    property bool isCurrentItem
    property bool isTheme

    property color fillIconColor
    property color iconColor
    property color normalButtonColor
    property color selectButtonColor
    property color hoverButtonColor
    property color chatMessageInformationTextColor
    property color glowColor

    signal currentChat()
    signal deleteChat()
    signal editChatName(var chatName)

    function onIsCurrentItemChanged(){
        if(isCurrentItem===true){
            backgroundId.color = control.selectButtonColor
        }else{
            backgroundId.color = control.normalButtonColor
        }
    }
    Rectangle{
        id: backgroundId
        anchors.fill: parent
        color: control.isCurrentItem? control.selectButtonColor:control.normalButtonColor
        radius: 2

        TextArea{
            id: textId
            text: "chat name"
            color: control.chatMessageInformationTextColor
            anchors.left: parent.left
            anchors.right: editIcon.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 5
            anchors.rightMargin: 0
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.family: control.fontFamily
            focus: false
            readOnly: true
            wrapMode: Text.NoWrap
            selectByMouse: false

            background: Rectangle {
                color: "transparent"
            }

            onEditingFinished: {
                if (textId.readOnly)
                    return;
                changeName();
            }
            function changeName() {
                control.editChatName(textId.text);
                textId.focus = false;
                textId.readOnly = true;
                textId.selectByMouse = false;
            }
            TapHandler {
                onTapped: {
                    if (control.isCurrentItem)
                        return;
                    control.currentChat();
                }
            }

            property bool isEnter: true
            hoverEnabled: true
            onHoveredChanged: {
                if(isEnter){
                    if(!control.isCurrentItem ){
                        backgroundId.color = control.hoverButtonColor
                    }
                    isEnter = false
                }else{
                    if(control.isCurrentItem){
                        backgroundId.color=control.selectButtonColor
                    }else{
                        backgroundId.color=control.normalButtonColor
                    }
                    isEnter = true
                }
            }

            Accessible.role: Accessible.Button
            Accessible.name: text
            Accessible.description: qsTr("Select the current chat or edit the chat when in edit mode")
        }

        MyIcon {
            id: editIcon
            width: 30
            visible: control.isCurrentItem
            anchors.right: deleteIcon.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            anchors.topMargin: 0
            myLable: " edit chat name"
            myIconId: textId.readOnly? "images/editIcon.svg": "images/okIcon.svg"
            myFillIconId: textId.readOnly? "images/fillEditIcon.svg": "images/okIcon.svg"
            normalColor: control.iconColor
            hoverColor: control.fillIconColor
            Connections {
                target: editIcon
                function onActionClicked() {
                    if(textId.readOnly){
                        textId.focus = true;
                        textId.readOnly = false;
                        textId.selectByMouse = true;
                    }else{
                        textId.focus = false;
                        textId.readOnly = true;
                        textId.selectByMouse = false;
                    }
                }
            }
        }

        MyIcon {
            id: deleteIcon
            width: 30
            visible: control.isCurrentItem
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 0
            anchors.rightMargin: 2
            myLable: " delete this chat"
            myIconId: "images/deleteIcon.svg"
            myFillIconId: "images/fillDeleteIcon.svg"
            normalColor: control.iconColor
            hoverColor: control.fillIconColor
            Connections {
                target: deleteIcon
                function onActionClicked() {
                    control.deleteChat()
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
