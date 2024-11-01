import QtQuick 2.15
import QtQuick.Controls 2.15
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

    property var fontFamily: constantsId.fontFamily

    text: control.state
    property alias myTextId: textId.text

    autoExclusive: false
    checkable: true

    property color normalColor: "#f5f5f5"
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

        layer.enabled: true
        layer.effect: Glow {
             samples: 15
             color: control.glowColors
             spread: 0.0
             // radius: 2
             transparentBorder: true
         }
    }



    states: [
        State {
            name: "checked"
            when: control.checked

            PropertyChanges {
                target: backgroundId
                color:control. selectColor
            }
        },
        State {
            name: "hover"
            when: control.hovered && !control.checked && !control.pressed

            PropertyChanges {
                target: backgroundId
                color: control.selectColor
            }

        },
        State {
            name: "normal"
            when: !control.pressed && !control.checked &&!control.hovered

            PropertyChanges {
                target: backgroundId
                color: control.normalColor
            }

        }
    ]
}
