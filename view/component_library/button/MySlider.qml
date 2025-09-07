import QtQuick 2.15
import QtQuick.Controls 2.15
import '../style' as Style

Slider {
    id: control
    value: 0.5
    stepSize: 0.01
    from: 0.00
    to: 2.00

    background: Rectangle {
        id: backgroundRect
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4

        width: control.availableWidth
        height: implicitHeight
        radius: 2
        color: Style.Colors.boxBorder

        Rectangle {
            id: groove
            height: parent.height
            width: control.visualPosition * parent.width
            radius: 2
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: Style.Colors.progressBarGradient0 }
                GradientStop { position: 1.0; color: Style.Colors.progressBarGradient1 }
            }
        }
    }

    handle: Item {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        height: handleItem.height
        width: handleItem.width
    }

    Rectangle {
        parent: control.handle
        id: handleItem
        implicitWidth: 15
        implicitHeight: 15
        radius: 13
        color: Style.Colors.background
        border.color: Style.Colors.progressBarGradient1
    }
    states: [
        State {
            name: "normal"
            when: !control.pressed

            PropertyChanges {
                target: groove
                color: Style.Colors.progressBarGradient1
            }
        },
        State {
            name: "pressed"
            when: control.pressed

            PropertyChanges {
                target: handleItem
                color: Style.Colors.progressBarGradient1
                border.color: Style.Colors.background
            }

            PropertyChanges {
                target: groove
                color: Style.Colors.progressBarGradient1
            }
        }
    ]
}
