import QtQuick 2.15
import '../component_library/style' as Style

Item{
    id: root
    anchors.top: parent.top; anchors.bottom: parent.bottom
    anchors.topMargin: 24; anchors.bottomMargin: 24;
    width: 70

    Rectangle {
        id: menuId
        anchors.fill: parent
        color: "#00ffffff"

        Column {
            id: column
            anchors.fill: parent
            spacing: 0

            MyMenuItem {
                id: homeItemMenue
                myText: "Home"
                myToolTipText: "Home"
                myIcon: "image/homeIcon.svg"
                myFillIcon: "image/fillHomeIcon.svg"
                checked: true
                autoExclusive: true

                Connections {
                    target: homeItemMenue
                    function onClicked(){
                        // page.currentIndex = 0
                        showSelectMenuId.y = homeItemMenue.y
                    }
                }
            }

            MyMenuItem {
                id: chatItemMenue
                myText: "Chat"
                myToolTipText: "Chat"
                myIcon: "image/chatIcon.svg"
                myFillIcon: "image/fillChatIcon.svg"
                autoExclusive: true

                Connections {
                    target: chatItemMenue
                    function onClicked(){
                        // page.currentIndex = 1
                        showSelectMenuId.y = chatItemMenue.y
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
                        // page.currentIndex = 2
                        showSelectMenuId.y = modelsItemMenu.y
                    }
                }
            }
        }

        Rectangle{
            id: showSelectMenuId
            color: Style.Colors.menuShowCheckedRectangle
            height: homeItemMenue.height
            width: 2
            anchors.left: parent.left
            anchors.leftMargin: 2
            radius: 4
            y: homeItemMenue.y

            Behavior on y{
                NumberAnimation{
                    duration: 200
                }
            }
        }
    }
}
