import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style
import '../../../../component_library/button'

Item {
    id: root
    height: 30; width: parent.width

    property string myTextName
    property bool myValue

    Row{
        id: settingsSliderBox
        anchors.left: parent.left
        anchors.leftMargin: 5
        height: parent.height
        width: parent.width - 5
        Label {
            id:textId
            text: root.myTextName
            color: Style.Colors.textTitle
            width: parent.width - switchId.width
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 10
        }

        MySwitch{
            id:switchId
            checked: root.myValue
        }
    }
}
