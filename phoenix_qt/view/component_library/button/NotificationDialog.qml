import QtQuick 2.15
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import '../style' as Style

Popup{
    id: control
    x: parent.width - width - 10
    y: parent.height - height - 10
    width: 300
    height: titleId.height + informationId.height + 55

    property var titleText
    property var about
    property real progressValue: 0
    onOpened: {
        progressValue = 0;
        progressTimer.restart();
    }

    background: null
    contentItem: Rectangle {
        id: backgroundId
        anchors.fill: parent
        radius: 10
        border.width: 1
        border.color: Style.Colors.boxBorder
        color: Style.Colors.background

        Column{
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10
            Text {
                id: titleId
                text: control.titleText
                color: Style.Colors.textTitle
                font.pixelSize: 18
                font.styleName: "Bold"
            }

            Text {
                id: informationId
                text: control.about
                color: Style.Colors.textInformation
                clip: true
                width: parent.width
                font.pixelSize: 12
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
                    radius: 2
                    width: progressBarCPU.visualPosition * parent.width; height: 6
                    color: Style.Colors.boxBorder
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
