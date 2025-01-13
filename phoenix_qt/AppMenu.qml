import QtQuick 2.15
import './component_library/style' as Style
import "./menu"

Item{
    id: root
    signal currentPage(int numberPage)

    Rectangle {
        id: menuId
        anchors.fill: parent
        color: "#00ffffff"

        Column {
            id: column
            anchors.fill: parent
            spacing: 0

            MyMenuItem {
                id: homeItemMenu
                myText: "Home"
                myToolTipText: "Home"
                myIcon: "image/homeIcon.svg"
                myFillIcon: "image/fillHomeIcon.svg"
                checked: true
                autoExclusive: true

                Connections {
                    target: homeItemMenu
                    function onClicked(){
                        root.currentPage(0)
                        showSelectMenuId.y = homeItemMenu.y
                    }
                }
            }

            MyMenuItem {
                id: chatItemMenu
                myText: "Chat"
                myToolTipText: "Chat"
                myIcon: "image/chatIcon.svg"
                myFillIcon: "image/fillChatIcon.svg"
                autoExclusive: true

                Connections {
                    target: chatItemMenu
                    function onClicked(){
                        root.currentPage(1)
                        showSelectMenuId.y = chatItemMenu.y
                    }
                }
            }

            MyMenuItem {
                id: modelsItemMenu
                myText: "Models"
                myToolTipText: "Models"
                myIcon: "image/modelIcon.svg"
                myFillIcon: "image/fillModelIcon.svg"
                autoExclusive: true

                Connections {
                    target: modelsItemMenu
                    function onClicked(){
                        root.currentPage(2)
                        showSelectMenuId.y = modelsItemMenu.y
                    }
                }
            }
        }

        Rectangle{
            id: showSelectMenuId
            color: Style.Colors.menuShowCheckedRectangle
            height: homeItemMenu.height
            width: 2
            anchors.left: parent.left
            anchors.leftMargin: 2
            radius: 4
            y: homeItemMenu.y

            Behavior on y{
                NumberAnimation{
                    duration: 200
                }
            }
        }
    }
}
