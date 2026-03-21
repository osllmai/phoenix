import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../component_library/style' as Style
import "qrc:/view/component_library/style/ThemeData.js" as ThemeData

AbstractButton {
    id: root
    width: 90
    height: 70

    property string themeName: "editra"
    property bool isSelected: false

    readonly property var _light: ThemeData.themes[themeName] ? ThemeData.themes[themeName].light : null
    readonly property color _primary: _light ? _light.primaryColor[2] : "#6C5CE7"
    readonly property color _bg: _light ? _light.backgroundColor[0] : "#FFFFFF"
    readonly property color _surface: _light ? _light.backgroundColor[1] : "#F8F9FA"

    Rectangle {
        anchors.fill: parent
        radius: 10
        border.color: root.isSelected ? Style.Colors.buttonPrimaryNormal : Style.Colors.boxBorder
        border.width: root.isSelected ? 2 : 1
        color: root._bg

        Column {
            anchors.centerIn: parent
            spacing: 4

            Rectangle {
                width: 50; height: 6; radius: 3
                color: root._primary
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                width: 40; height: 4; radius: 2
                color: root._surface
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                width: 30; height: 4; radius: 2
                color: root._surface
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Label {
        text: root.themeName.charAt(0).toUpperCase() + root.themeName.slice(1)
        anchors.top: parent.bottom
        anchors.topMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        color: Style.Colors.textInformation
        font.pixelSize: 11
        font.styleName: root.isSelected ? "Bold" : "Normal"
    }
}
