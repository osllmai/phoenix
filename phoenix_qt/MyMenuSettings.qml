import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import Qt5Compat.GraphicalEffects
import 'style' as Style

T.Button {
    id: control
    width: 100
    height: 30

    leftPadding: 4
    rightPadding: 4

    text: control.state
    property alias myTextId: textId.text

    autoExclusive: false
    checkable: true

    background: Rectangle{
        id: backgroundId
        anchors.fill: parent
        color: "#00ffffff"
        radius: 2
        Text {
            id: textId
            color: Style.Theme.informationTextColor
            text: qsTr("Text Button")
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: Style.Theme.fontFamily
            font.styleName: "Bold"
        }
    }

    states: [
        State {
            name: "checked"
            when: control.checked

            PropertyChanges {
                target: textId
                color:Style.Theme.fillIconColor
                font.styleName: "Bold"
            }
        },
        State {
            name: "hover"
            when: control.hovered && !control.checked && !control.pressed

            PropertyChanges {
                target: textId
                color: Style.Theme.fillIconColor
                font.styleName: "Bold"
            }

        },
        State {
            name: "normal"
            when: !control.pressed && !control.checked &&!control.hovered

            PropertyChanges {
                target: textId
                color: Style.Theme.informationTextColor
                font.styleName: "Bold"
            }
        }
    ]
}
