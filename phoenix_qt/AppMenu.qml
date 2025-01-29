import QtQuick 2.15
import QtQuick.Controls.Basic
import './component_library/style' as Style
import "./menu"

Item{
    id: root
    signal currentPage(int numberPage)

    Rectangle {
        id: menuId
        anchors.fill: parent
        color: "#00ffffff"
        clip:true

        Rectangle{
            id: appInfoId
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 10
            color: "#00ffffff"
            height: 40
            ToolButton {
                id: phoenixIconId
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                background: Rectangle {
                    color: "#00ffffff"
                }
                icon{
                    source: "home/images/phoenixIcon.svg"
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
            Label {
                id: textId
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
                anchors.left: textId.right
                anchors.leftMargin: 2
                background: Rectangle {
                    color: "#00ffffff"
                }
                icon{
                    source: "home/images/phoenixIcon.svg"
                    color: Style.Colors.menuHoverAndCheckedIcon;
                    width:18; height:18
                }
            }
        }

        Column {
            id: column
            anchors.left: parent.left
            anchors.right:parent.right
            anchors.top: appInfoId.bottom
            anchors.topMargin: 10
            spacing: 0
            clip:true

            MyMenuItem {
                id: homeItemMenu
                myText: "Home"
                myToolTipText: "Home"
                myIcon: "images/homeIcon.svg"
                myFillIcon: "images/fillHomeIcon.svg"
                checked: true
                autoExclusive: true

                Connections {
                    target: homeItemMenu
                    function onClicked(){
                        root.currentPage(0)
                        showSelectMenuId.y = homeItemMenu.y + appInfoId.height + 20
                    }
                }
            }

            MyMenuItem {
                id: chatItemMenu
                myText: "Chat"
                myToolTipText: "Chat"
                myIcon: "images/chatIcon.svg"
                myFillIcon: "images/fillChatIcon.svg"
                autoExclusive: true

                Connections {
                    target: chatItemMenu
                    function onClicked(){
                        root.currentPage(1)
                        showSelectMenuId.y = chatItemMenu.y + appInfoId.height + 20
                    }
                }
            }

            MyMenuItem {
                id: modelsItemMenu
                myText: "Models"
                myToolTipText: "Models"
                myIcon: "images/modelIcon.svg"
                myFillIcon: "images/fillModelIcon.svg"
                autoExclusive: true

                Connections {
                    target: modelsItemMenu
                    function onClicked(){
                        root.currentPage(2)
                        showSelectMenuId.y = modelsItemMenu.y + appInfoId.height + 20
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
            y: homeItemMenu.y + appInfoId.height + 20

            Behavior on y{
                NumberAnimation{
                    duration: 200
                }
            }
        }
    }
}
