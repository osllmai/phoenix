import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style
import '../../../../component_library/button'

Item{
    id:headerId
    height: 80; width: parent.width
    clip:true
    signal search(var text)
    signal currentPage(int numberPage)

    Row{
        height: 35
        spacing: 10
        anchors.horizontalCenter: parent.horizontalCenter
        MyMenu{
            id: assistantMenuId
            myText: "Offline Model"
            myIcon: "qrc:/media/icon/offline.svg"
            checked: true
            autoExclusive: true
            Connections {
                target: assistantMenuId
                function onClicked(){headerId.currentPage(0)}
            }
        }
        MyMenu{
            id: modelMenuId
            myText: "Online Model"
            myIcon: "qrc:/media/icon/online.svg"
            checked: false
            autoExclusive: true
            Connections {
                target: modelMenuId
                function onClicked(){headerId.currentPage(1)}
            }
        }
    }
    Item{
        id: closeBox
        x: headerId.x +headerId.width - 30; y: headerId.y
        width: 25; height: 25
        ToolButton {
            id: searchIcon
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width:searchIcon.hovered? 24: 23; height: searchIcon.hovered? 24: 23
            Behavior on width{ NumberAnimation{ duration: 150}}
            Behavior on height{ NumberAnimation{ duration: 150}}
            background: null
            icon{
                source: "qrc:/media/icon/close.svg"
                color: searchIcon.hovered? Style.Colors.iconPrimaryHoverAndChecked: Style.Colors.iconPrimaryNormal
                width: searchIcon.width; height: searchIcon.height
            }
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked:{comboBoxId.popup.close()}
            }
        }
    }
}
