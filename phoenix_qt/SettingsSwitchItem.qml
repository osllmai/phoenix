import QtQuick 2.15
import QtQuick.Controls 2.15
import 'style' as Style

Item {
    id: root
    width: 250
    height: 60


    property alias myTextName: textId.text
    property bool myValue

    // property color textColor: "black"

    Rectangle{
        id: settingsSliderBox
        anchors.fill: parent
        color: "#00ffffff"
        Text{
            id:textId
            text: "Temperature"
            color:Style.Theme.informationTextColor
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 0
            anchors.topMargin: 0
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 10
            font.family: Style.Theme.fontFamily
        }

        MySwitch{
            id:switchId
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 5
            checked: root.myValue
        }
    }
}
