import QtQuick 2.15
import '../../component_library/style' as Style

Item{
    id:headerId
    clip:true
    Column{
        spacing: 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.left:parent.left
        anchors.leftMargin: 24
        Text {
            id: inDoxId
            text: qsTr("Welcome to InDox!")
            color: Style.Colors.textTitle
            font.pixelSize: 20
            font.styleName: "Bold"
        }

        Text {
            id: informationText
            text: qsTr("Get Started.")
            color: Style.Colors.textInformation
            font.pixelSize: 16
        }
    }
}
