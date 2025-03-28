import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import '../../component_library/style' as Style

T.Button {
    id: root
    width: 120
    height: 80

    leftPadding: 4; rightPadding: 4
    autoExclusive: false
    checkable: true

    property alias myIcon: icon.source
    property string myText

    Rectangle {
        id: backgroundId
        anchors.fill: parent
        radius: 10
        border.color: root.checked ? Style.Colors.buttonPrimaryNormal:  Style.Colors.background
        border.width: root.checked ? 2 : 0
        color: Style.Colors.background

        Image {
            id: icon
            anchors.centerIn: parent
            width: 110
            height: 70
        }
    }
    Label{
        id: textId
        text: myText
        anchors.top: backgroundId.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        color: Style.Colors.textInformation
        font.styleName: root.checked ? "Bold": "Normal"
    }
}
