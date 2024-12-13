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

    function onIsCurrentItemChanged(){
        if(isCurrentItem===true){
            backgroundId.color = control.selectButtonColor
        }else{
            backgroundId.color = control.normalButtonColor
        }
    }
    function onIsThemeChanged(){
        console.log(" pl pl plp")
        if(isCurrentItem===true){
            backgroundId.color = control.selectButtonColor
        }else{
            backgroundId.color = control.normalButtonColor
        }
    }

    Rectangle{
        id: backgroundId
        anchors.fill: parent
        color: control.normalButtonColor
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
        MouseArea {
            id:mouseAreaChatItem
            anchors.fill:parent
            onClicked: {
                control.currentChat()
            }
            hoverEnabled: true
            onHoveredChanged: {
                if(containsMouse){
                    if(!control.isCurrentItem ){
                        backgroundId.color = control.hoverButtonColor
                    }
                }else{
                    if(control.isCurrentItem){
                        backgroundId.color=control.selectButtonColor
                    }else{
                        backgroundId.color=control.normalButtonColor
                    }
                }
            }
        }

        MyIcon {
            id: editIcon
            width: 30
            visible: control.isCurrentItem
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 2
            anchors.topMargin: 0
            myLable: " edit chat name"
            myIconId: "images/editIcon.svg"
            myFillIconId: "images/fillEditIcon.svg"
            normalColor: control.iconColor
            hoverColor: control.fillIconColor
            Connections {
                target: editIcon
                function onActionClicked() {
                }
            }
        }

        MyIcon {
            id: deleteIcon
            width: 30
            visible: control.isCurrentItem
            anchors.right: editIcon.left
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
