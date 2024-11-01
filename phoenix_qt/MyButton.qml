import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import Qt5Compat.GraphicalEffects


T.Button {
    id: control
    width: 100
    height: 30

    Constants{
        id: constantsId
    }

    leftPadding: 4
    rightPadding: 4

    text: control.state
    property alias myTextId: textId.text

    autoExclusive: false
    checkable: true

    property var fontFamily: constantsId.fontFamily

    property color light: "#747474"
    property color dark: "#5b5fc7"
    property color normalColor: "#ebebeb"
    property color selectColor: "#ffffff"
    property color textColor: "#000000"
    property color glowColor: "#d7d7d7"

    background: Rectangle{
        id: backgroundId
        anchors.fill: parent
        color: control.selectColor
        radius: 2
        Text {
            id: textId
            color: control.textColor
            text: qsTr("Text Button")
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: control.fontFamily
        }

        border.width: 2
        border.color: control.selectColor

        layer.enabled: true
        layer.effect: Glow {
             samples: 15
             color: control.glowColor
             spread: 0.0
             transparentBorder: true
         }
    }

    states: [
        State {
            name: "hover"
            when: control.hovered || control.pressed
            PropertyChanges {
                target: backgroundId
                color: control.selectColor
            }
        },
        State {
            name: "normal"
            when: !control.pressed &&!control.hovered
            PropertyChanges {
                target: backgroundId
                color: control.normalColor
            }
        }
    ]
}
