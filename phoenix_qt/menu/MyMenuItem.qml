import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects

import '../component_library/style' as Style

T.Button {
    id: control
    width: 70; height: 60

    leftPadding: 4; rightPadding: 4
    autoExclusive: false
    checkable: true

    property alias myText: textId.text
    property alias myToolTipText: toolTipId.text
    property var myIcon
    property var myFillIcon

    function iconColor(){
        if(!control.pressed && !control.checked &&!control.hovered)
            return Style.Colors.menuNormalIcon;
        else
            return Style.Colors.menuHoverAndCheckedIcon;
    }

    // Define a custom tooltip using a Popup
    Popup {
        id: customToolTipId
        x: parent.x + parent.width + 7
        y: (parent.height - 30)/2
        width: toolTipId.width + 20
        height: 30
        visible: control.hovered  // Show when the button is hovered
        background:Rectangle {
            color: Style.Colors.toolTipBackground
            radius: 4
            border.color: Style.Colors.toolTipGlowAndBorder
            anchors.left: parent.left
            Label {
                id: toolTipId
                text: "toolTop text"
                anchors.centerIn: parent
                color: Style.Colors.toolTipText
            }
            layer.enabled: true
            layer.effect: Glow {
                 samples: 30
                 color: Style.Colors.toolTipGlowAndBorder
                 spread: 0.3
                 transparentBorder: true
             }
        }
    }

    background:null

    contentItem: Rectangle{
        id: backgroundId
        color: control.hovered ? Style.Colors.menuHoverBackground : "#00ffffff"
        anchors.fill: parent
        Image {
            id: iconId
            visible: true
            height: 20
            width: 20
            source: control.checked? control.myFillIcon : control.myIcon
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.height: 20
            sourceSize.width: 20
            anchors.top: parent.top
            anchors.topMargin: 10

        }
        ColorOverlay {
            id: colorOverlayFillIconId
            anchors.fill: iconId
            source: iconId
            color: control.iconColor()
        }

        Label {
            id: textId
            width: backgroundId.width
            color: control.iconColor()
            anchors.top: iconId.bottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            text: "Default"
            font.weight: 400
            font.pixelSize: 11
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
