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
        border.color: Style.Colors.buttonFeatureBorderPressed
        color: Style.Colors.background

        Column{
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10
            Label {
                id: titleId
                text: control.titleText
                color: Style.Colors.textTitle
                font.pixelSize: 18
                font.styleName: "Bold"
            }

            Label {
                id: informationId
                text: control.about
                color: Style.Colors.textInformation
                clip: true
                width: parent.width
                font.pixelSize: 12
                wrapMode: Text.Wrap
            }
        }

        layer.enabled: true
        layer.effect: Glow {
             samples: 40
             color:  Style.Colors.boxBorder
             spread: 0.1
             transparentBorder: true
         }
    }

    Timer {
        id: progressTimer
        interval: 2000
        repeat: false
        onTriggered: {
            control.close();
        }
    }
}
