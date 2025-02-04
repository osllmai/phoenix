import QtQuick 2.15
import QtQuick.Controls 2.15
import '../style' as Style

Switch {
    id: control

    readonly property int baseSize: 7

    background: backgroundItem
    Rectangle {
        id: backgroundItem
        color: "#00000000"
        implicitWidth: control.baseSize * 6.0
        implicitHeight: control.baseSize * 3.8
    }

    leftPadding: 4

    indicator: switchHandle
    Rectangle {
        id: switchHandle
        implicitWidth: control.baseSize * 4.8
        implicitHeight: control.baseSize * 2.6
        x: control.leftPadding
        color: "#e9e9e9"
        anchors.verticalCenter: parent.verticalCenter
        radius: control.baseSize * 1.3

        Rectangle {
            id: rectangle

            width: control.baseSize * 2.6
            height: control.baseSize * 2.6
            radius: control.baseSize * 1.3
            color: "#e9e9e9"
        }
    }
    states: [
        State {
            name: "off"
            when: !control.checked && !control.down

            PropertyChanges {
                target: rectangle
                color: "#cccccc"
            }

            PropertyChanges {
                target: switchHandle
                color: "#00000000"
                border.color: "#aeaeae"
            }
        },
        State {
            name: "on"
            when: control.checked && !control.down

            PropertyChanges {
                target: switchHandle
                color: "#047eff"
                border.color: "#ffffff"
            }

            PropertyChanges {
                target: rectangle
                x: parent.width - width
            }
        },
        State {
            name: "off_down"
            when: !control.checked && control.down

            PropertyChanges {
                target: rectangle
                color: "#e9e9e9"
            }

            PropertyChanges {
                target: switchHandle
                color: "#00000000"
                border.color: "#047eff"
            }
        },
        State {
            name: "on_down"
            when: control.checked && control.down

            PropertyChanges {
                target: rectangle
                x: parent.width - width
                color: "#e9e9e9"
            }

            PropertyChanges {
                target: switchHandle
                color: "#b1047eff"
                border.color: "#ffffff"
            }
        }
    ]
}
