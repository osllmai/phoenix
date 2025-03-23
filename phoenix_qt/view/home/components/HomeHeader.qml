import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../component_library/style' as Style

Item{
    id:headerId
    width: parent.width; height: 80
    clip:true
    Column{
        spacing: 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.left:parent.left
        anchors.leftMargin: 24
        anchors.top: parent.top
        anchors.topMargin: 24
        Label {
            id: inDoxId
            text: qsTr("Welcome to Phoenix!")
            color: Style.Colors.textTitle
            font.pixelSize: 24
            font.styleName: "Bold"
        }

        Label {
            id: informationText
            text: qsTr("Get Started.")
            color: Style.Colors.textInformation
            font.pixelSize: 16
        }
    }
}
