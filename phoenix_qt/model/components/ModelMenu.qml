import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls.Basic

import '../../component_library/style' as Style

T.Button {
    id: control
    height: 65
    width: 100

    leftPadding: 4; rightPadding: 4
    autoExclusive: false
    checkable: true

    property alias myText: textId.text
    property var myIcon
    property var myFillIcon

    function iconColor(){
        if(!control.pressed && !control.checked &&!control.hovered)
            return Style.Colors.menuNormalIcon;
        else
            return Style.Colors.menuHoverAndCheckedIcon;
    }

    background:null

    contentItem: Rectangle{
        id: backgroundId
        color: control.hovered || control.checked ? Style.Colors.menuHoverBackground : "#00ffffff"
        border.width:1
        border.color: Style.Colors.menuHoverBackground
        radius: 10
        clip: true

        ToolButton {
            id: iconId
            anchors.top: parent.top; anchors.topMargin: 7
            anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle {
                color: "#00ffffff"
            }
            icon{
                source: control.checked? control.myFillIcon : control.myIcon
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
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: iconId.bottom; anchors.topMargin: 2
            text: "Default"
            font.weight: 400
            font.pixelSize: 12
            visible: control.width>60
            clip: true
        }
    }
}
