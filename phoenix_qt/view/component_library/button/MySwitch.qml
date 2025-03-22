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
        color: Style.Colors.boxBorder
        anchors.verticalCenter: parent.verticalCenter
        radius: control.baseSize * 1.3

        Rectangle {
            id: rectangle

            width: control.baseSize * 2.6
            height: control.baseSize * 2.6
            radius: control.baseSize * 1.3
            color: Style.Colors.boxBorder
        }
    }
    states: [
        State {
            name: "off"
            when: !control.checked && !control.down

            PropertyChanges {
                target: rectangle
                color: Style.Colors.boxBorder
            }

            PropertyChanges {
                target: switchHandle
                color: "#00000000"
                border.color: Style.Colors.boxBorder
            }
        },
        State {
            name: "on"
            when: control.checked && !control.down

            PropertyChanges {
                target: switchHandle
                color: Style.Colors.progressBarGradient1
                border.color: control.background
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
                color: Style.Colors.boxBorder
            }

            PropertyChanges {
                target: switchHandle
                color: "#00000000"
                border.color: Style.Colors.progressBarGradient1
            }
        },
        State {
            name: "on_down"
            when: control.checked && control.down

            PropertyChanges {
                target: rectangle
                x: parent.width - width
                color: Style.Colors.boxBorder
            }

            PropertyChanges {
                target: switchHandle
                color: Style.Colors.progressBarGradient1
                border.color: control.background
            }
        }
    ]
}
