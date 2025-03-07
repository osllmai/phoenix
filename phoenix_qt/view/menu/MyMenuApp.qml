import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects

import '../component_library/style' as Style

T.Button {
    id: control
    height: 40
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.rightMargin: 10
    anchors.leftMargin: 10

    leftPadding: 4; rightPadding: 4
    autoExclusive: false
    checkable: true

    property alias myText: textId.text
    property alias myToolTipText: toolTipId.text
    property var myIcon
    property var myFillIcon
    property int numberPage

    function iconColor(){
        if(!control.pressed &&!control.hovered &&(appBodyId.currentIndex != numberPage))
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
        visible: control.hovered  && control.width <60
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
        color: control.hovered || (appBodyId.currentIndex == numberPage) ? Style.Colors.menuHoverBackground : "#00ffffff"
        anchors.fill: parent
        radius: 10
        clip: true

        ToolButton {
            id: iconId
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 4
            background: null
            icon{
                source: (appBodyId.currentIndex == numberPage)? control.myFillIcon : control.myIcon
                color: control.iconColor()
                width:18; height:18
            }
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    control.click()
                }
            }
        }
        Label {
            id: textId
            color: control.iconColor()
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: iconId.right
            anchors.leftMargin: 2
            text: "Default"
            font.weight: 400
            font.pixelSize: 12
            visible: control.width>60
            clip: true
        }
    }
}
