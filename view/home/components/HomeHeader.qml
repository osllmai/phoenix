import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../component_library/style' as Style
import '../../component_library/button'
import "../../menu"

Item{
    id:headerId
    width: parent.width; height: 68
    clip:true
    Row{
        anchors.verticalCenter: parent.verticalCenter
        anchors.left:parent.left; anchors.leftMargin: 24
        anchors.top: parent.top; anchors.topMargin: 12
        spacing: 15

        MyOpenMenuButton{
            id: openMenuId
        }

        Column{
            spacing: 2
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
}
