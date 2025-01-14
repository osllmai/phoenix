import QtQuick 2.15
import '../../component_library/style' as Style

Rectangle{
    id:headerId
    color: Style.Colors.headerBackground
    Text {
        id: phoenixId
        text: qsTr("Welcome to Phoenix!")
        color: Style.Colors.textTitle
        anchors.left: parent.left; anchors.top: parent.top
        anchors.leftMargin: 24; anchors.topMargin: 12
        font.pixelSize: 20
        font.styleName: "Bold"
    }

    Text {
        id: informationText
        text: qsTr("Get Started.")
        color: Style.Colors.textInformation
        anchors.left: parent.left; anchors.top: phoenixId.bottom
        anchors.leftMargin: 24; anchors.topMargin: 2
        font.pixelSize: 16
    }
}
