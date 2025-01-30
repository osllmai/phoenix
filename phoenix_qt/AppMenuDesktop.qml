import QtQuick 2.15
import QtQuick.Controls.Basic
import './component_library/style' as Style
import "./menu"

Rectangle{
    id: root
    width: 200
    anchors.top: parent.top; anchors.bottom: parent.bottom
    signal currentPage(int numberPage)

    color: Style.Colors.menu

    Item{
        id: appInfoId
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 0
        height: 60
        ToolButton {
            id: phoenixIconId
            visible: root.width>80
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            background: null
            icon{
                source: "./media/icon/phoenix.svg"
                color: Style.Colors.menuHoverAndCheckedIcon;
                width:18; height:18
            }
        }
        Label {
            id: textId
            visible: root.width>100
            color: Style.Colors.menuHoverAndCheckedIcon;
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: phoenixIconId.right
            anchors.leftMargin: 2
            text: "Phoenix"
            font.weight: 400
            font.pixelSize: 14
            font.styleName: "Bold"
            clip: true
        }
        ToolButton {
            id: iconId
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.leftMargin: 2
            background: null
            function myIcon(){
                if(root.width>100)
                    if(!iconId.hovered)
                        return "./media/icon/alignLeft.svg"
                    else
                        return "./media/icon/alignLeftFill.svg"
                else
                    if(!iconId.hovered)
                        return "./media/icon/alignRight.svg"
                    else
                        return "./media/icon/alignRightFill.svg"
            }

            icon{
                source: iconId.myIcon()
                color: Style.Colors.menuHoverAndCheckedIcon;
                width:18; height:18
            }
            onClicked: function() {
                if(root.width<100)
                    root.width = 200
                else
                    root.width = 60
            }
        }
    }

    Column {
        id: columnId
        anchors.left: parent.left
        anchors.right:parent.right
        anchors.top: appInfoId.bottom
        anchors.topMargin: 0
        spacing: 5
        clip:true

        MyMenuItem {
            id: homeItemMenu
            myText: "Home"
            myToolTipText: "Home"
            myIcon: "./media/icon/home.svg"
            myFillIcon: "./media/icon/homeFill.svg"
            checked: true
            autoExclusive: true

            Connections {
                target: homeItemMenu
                function onClicked(){
                    root.currentPage(0)
                    showSelectMenuId.y = homeItemMenu.y + appInfoId.height
                }
            }
        }

        MyMenuItem {
            id: chatItemMenu
            myText: "Chat"
            myToolTipText: "Chat"
            myIcon: "./media/icon/chat.svg"
            myFillIcon: "./media/icon/chatFill.svg"
            autoExclusive: true

            Connections {
                target: chatItemMenu
                function onClicked(){
                    root.currentPage(1)
                    showSelectMenuId.y = chatItemMenu.y + appInfoId.height
                }
            }
        }

        MyMenuItem {
            id: modelsItemMenu
            myText: "Models"
            myToolTipText: "Models"
            myIcon: "./media/icon/model.svg"
            myFillIcon: "./media/icon/modelFill.svg"
            autoExclusive: true

            Connections {
                target: modelsItemMenu
                function onClicked(){
                    root.currentPage(2)
                    showSelectMenuId.y = modelsItemMenu.y + appInfoId.height
                }
            }
        }
    }

    Rectangle{
        id: showSelectMenuId
        color: Style.Colors.menuShowCheckedRectangle
        height: homeItemMenu.height
        width: 3
        anchors.left: parent.left
        anchors.leftMargin: 10
        radius: 300
        y: homeItemMenu.y + appInfoId.height

        Behavior on y{
            NumberAnimation{
                duration: 200
            }
        }
    }
}
