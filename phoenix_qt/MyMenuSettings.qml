import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import Qt5Compat.GraphicalEffects


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

    property color backgroungColor: "#f5f5f5"
    property color borderColor: "#ffffff"
    property color textColor: "#000000"
    property color selectTextColor: "#000000"
    property color glowColor: "#d7d7d7"
    property var fontFamily

    background: Rectangle{
        id: backgroundId
        anchors.fill: parent
        color: control.backgroungColor
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
            font.styleName: "Bold"
        }

        // layer.enabled: true
        // layer.effect: Glow {
        //      samples: 15
        //      color: control.glowColor
        //      spread: 0.0
        //      // radius: 2
        //      transparentBorder: true
        //  }
    }



    states: [
        State {
            name: "checked"
            when: control.checked

            PropertyChanges {
                target: textId
                color:control. selectTextColor
                font.styleName: "Bold"
            }
        },
        State {
            name: "hover"
            when: control.hovered && !control.checked && !control.pressed

            PropertyChanges {
                target: textId
                color: control.selectTextColor
                font.styleName: "Bold"
            }

        },
        State {
            name: "normal"
            when: !control.pressed && !control.checked &&!control.hovered

            PropertyChanges {
                target: textId
                color: control.textColor
                font.styleName: "Bold"
            }

        }
    ]
}
