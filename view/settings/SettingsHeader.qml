import QtQuick 2.15
import QtQuick.Controls 2.15
import '../component_library/style' as Style
import "./components"

Item{
    id: titleBoxId
    height: 50
    width: parent.width

    OpenMenuSettingsButton{
        id: openMenuId
        anchors.left:parent.left; anchors.leftMargin: 10
        anchors.top: parent.top; anchors.topMargin: 10
    }

    Item{
        id: closeBox
        width: 35; height: 35
        anchors.right: parent.right; anchors.rightMargin: 10;
        anchors.top: parent.top; anchors.topMargin: 10;
        ToolButton {
            id: searchIcon
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width:searchIcon.hovered? 35: 30; height: searchIcon.hovered? 35: 30
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
                onClicked:{settingsDialogId.close()}
            }
        }
    }
}
