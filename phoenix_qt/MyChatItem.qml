import QtQuick 2.15
import QtQuick.Controls
import Phoenix
import Qt5Compat.GraphicalEffects
import 'style' as Style

Item {
    id: control
    width: 150
    height: 30

    property alias myTextId: textId.text
    property bool isCurrentItem
    property var theme: Style.Theme.theme

    signal currentChat()
    signal deleteChat()
    signal editChatName(var chatName)

    onThemeChanged:{
        if(isCurrentItem===true){
            backgroundId.color = Style.Theme.selectButtonColor
        }else{
            backgroundId.color = Style.Theme.normalButtonColor
        }
    }

    Rectangle{
        id: backgroundId
        anchors.fill: parent
        color: selectColor()
        radius: 2

        function selectColor(){
            if(control.isCurrentItem){
                return Style.Theme.selectButtonColor;
            }else{
                return Style.Theme.normalButtonColor;
            }
        }

        TextArea{
            id: textId
            text: "chat name"
            color: Style.Theme.chatMessageInformationTextColor
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
            font.family: Style.Theme.fontFamily
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
                        backgroundId.color = Style.Theme.hoverButtonColor
                    }
                    isEnter = false
                }else{
                    if(control.isCurrentItem){
                        backgroundId.color=Style.Theme.selectButtonColor
                    }else{
                        backgroundId.color=Style.Theme.normalButtonColor
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
            normalColor: Style.Theme.iconColor
            hoverColor: Style.Theme.fillIconColor
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
            normalColor: Style.Theme.iconColor
            hoverColor: Style.Theme.fillIconColor
            Connections {
                target: deleteIcon
                function onActionClicked() {
                    deleteRequest.open()
                }
            }
        }

        Notification{
            id: deleteRequest
            title:"Delete LLM Model"
            about:"Are you sure you want to delete the LLM model? \nThis action is irreversible and may result in the loss of data or settings associated with the model."
            textBotton1: "Cancel"
            textBotton2: "Delete"

            Connections{
                target: deleteRequest
                function onBottonAction1(){
                    deleteRequest.close()
                }

                function onBottonAction2(){
                    control.deleteChat()
                    deleteRequest.close()
                }
            }
        }

        layer.enabled: true
        layer.effect: Glow {
             samples: 15
             color: Style.Theme.glowColor
             spread: 0.0
             transparentBorder: true
         }
    }
}
