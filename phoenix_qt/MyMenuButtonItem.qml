import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects


T.Button {
    id: control
    width: 53
    height: 40

    leftPadding: 4
    rightPadding: 4

    text: control.state
    property alias myTextId: textId.text
    property alias myLable: lableFoolTipId.text
    property var myIconId
    property var myFillIconId


    autoExclusive: false
    checkable: true

    property var fontFamily
    property color menuIconColor
    property color iconColor


    // Define a custom tooltip using a Popup
    Popup {
        id: customToolTipId
        x: parent.x + parent.width + 7
        width: lableFoolTipId.width + 20
        height: 30
        visible: control.hovered  // Show when the button is hovered
        background:Rectangle {
            color: "#ffffff"
            radius: 4
            border.color: "#cbcbcb"
            anchors.left: parent.left
            Label {
                id: lableFoolTipId
                text: "Customized tooltip background"
                anchors.centerIn: parent
                color: "black"
            }
            layer.enabled: true
            layer.effect: Glow {
                 samples: 30
                 color: "#cbcbcb"
                 spread: 0.3
                 transparentBorder: true
             }
        }
    }

    background: Rectangle{
        id: backgroundId
        color: "#00ffffff"
        anchors.fill: parent
        Rectangle{
            id: column
            color: "#00ffffff"
            anchors.fill: parent
            Image {
                id: fillIconId
                visible: true
                height: 20
                width: 20
                source: control.hovered? control.myFillIconId : control.myIconId
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.height: 20
                sourceSize.width: 20
                anchors.top: parent.top
                anchors.topMargin: 0

            }
            ColorOverlay {
                id: colorOverlayFillIconId
                anchors.fill: fillIconId
                source: fillIconId
                color: !control.pressed &&!control.hovered? control.iconColor: control.menuIconColor
            }

            Text {
                id: textId
                width: backgroundId.width
                height: 15
                color: !control.pressed &&!control.hovered? control.iconColor: control.menuIconColor
                anchors.top: fillIconId.bottom
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                text: "Default"
                font.weight: 400
                font.family: control.fontFamily
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
