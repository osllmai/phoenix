import QtQuick 2.15
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import '../style' as Style

Popup{
    id: control
    x: parent.width - width - 10
    y: parent.height - height - 40
    width: 250
    height: 100

    property var titleText
    property var about
    property real progressValue: 0
    onOpened: {
        progressValue = 0;
        progressTimer.restart();
    }

    focus: true
    modal: true
    closePolicy: Popup.NoAutoClose

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        color: Style.Colors.overlay
    }

    background: null
    contentItem: Rectangle {
        id: backgroundId
        anchors.fill: parent
        radius: 10
        border.width: 1
        border.color: Style.Colors.boxBorder

        gradient: Gradient {
            GradientStop {
                position: 0
                color: control.hovered ? Style.Colors.boxHoverGradient0 : Style.Colors.boxNormalGradient0
            }
            GradientStop {
                position: 1
                color: control.hovered ? Style.Colors.boxHoverGradient1 : Style.Colors.boxNormalGradient1
            }
            orientation: Gradient.Vertical
        }

        Column{
            anchors.fill: parent
            spacing: 10
            anchors.margins: 20
            Text {
                id: titleId
                text: control.titleText
                color: Style.Colors.textTitle
                font.pixelSize: 16
                font.styleName: "Bold"
            }

            Text {
                id: informationId
                text: control.about
                color: Style.Colors.textInformation
                clip: true
                width: parent.width
                font.pixelSize: 14
                wrapMode: Text.Wrap
            }
        }

        ProgressBar {
            id: progressBarCPU
            width: parent.width
            height: 6
            value: control.progressValue
            anchors.bottom: parent.bottom

            background: null

            contentItem: Item {
                implicitHeight: 6
                Rectangle {
                    width: progressBarCPU.visualPosition * parent.width
                    height: 6
                    radius: 2
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: Style.Colors.progressBarGradient0 }
                        GradientStop { position: 1.0; color: Style.Colors.progressBarGradient1 }
                    }
                    Behavior on width { NumberAnimation { duration: 100 } }
                }
            }
        }

        layer.enabled: control.hovered ? true : false
        layer.effect: Glow {
            samples: 40
            color: Style.Colors.boxBorder
            spread: 0.1
            transparentBorder: true
        }
    }

    Timer {
        id: progressTimer
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            if (control.progressValue < 1) {
                control.progressValue += 0.01;
            } else {
                control.close();
                stop();
                progressValue = 0;
            }
        }
    }
}
