import QtQuick 2.15
import '../../../../component_library/style' as Style
import '../../../../component_library/button'

Item {
    id: root
    height: 30; width: parent.width

    property alias myTextName: textId.text
    property bool myValue

    Item{
        id: settingsSliderBox
        anchors.fill: parent
        Text{
            id:textId
            text: "Temperature"
            color: Style.Colors.textTitle
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 0
            anchors.topMargin: 0
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 10
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
