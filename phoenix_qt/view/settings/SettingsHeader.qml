import QtQuick 2.15
import QtQuick.Controls 2.15
import '../component_library/style' as Style

Row{
    id: titleBoxId
    height: 50
    spacing: parent.width - titleId.width - closeBox.width
    Label {
        id: titleId
        text: "Settings"
        color: Style.Colors.textTitle
        font.pixelSize: 20
        font.styleName: "Bold"
        anchors.verticalCenter: closeBox.verticalCenter
    }
    Item{
        id: closeBox
        width: 35; height: 35
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
                color: searchIcon.hovered? Style.Colors.iconHoverAndChecked: Style.Colors.iconNormal
                width: searchIcon.width; height: searchIcon.height
            }
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked:{dialogId.close()}
            }
        }
    }
}
