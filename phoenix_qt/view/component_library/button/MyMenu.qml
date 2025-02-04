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

    function iconColor(){
        if(!control.pressed && !control.checked &&!control.hovered)
            return Style.Colors.menuNormalIcon;
        else
            return Style.Colors.menuHoverAndCheckedIcon;
    }

    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevice.Mouse
        cursorShape: Qt.PointingHandCursor
    }

    background:null
    contentItem: Rectangle{
        id: backgroundId
        width: parent.width-3; height: parent.height-3
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: Style.Colors.buttonFeatureNormal
        border.width:1
        border.color: Style.Colors.buttonFeatureBorderNormal
        radius: 12
        clip: true

        Behavior on width{ NumberAnimation{ duration: 200}}
        Behavior on height{ NumberAnimation{ duration: 200}}


        MyIcon {
            id: iconId
            myIcon: control.myIcon
            iconType: Style.RoleEnum.IconType.FeatureBlue
            anchors.top: parent.top; anchors.topMargin: 7
            anchors.horizontalCenter: parent.horizontalCenter
            enabled: false
        }

        Label {
            id: textId
            color: Style.Colors.buttonFeatureTextNormal
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: iconId.bottom; anchors.topMargin: 2
            text: "Default"
            font.weight: 400
            font.pixelSize: 12
            visible: control.width>60
            clip: true
        }
    }

    property bool isNormal: !control.hovered && !control.pressed && !control.enabled
    property bool isHover: control.hovered && !control.pressed && !control.checked
    property bool isPressed: control.pressed && !control.checked
    property bool isChecked: control.checked

    states: [
        State {
            name: "normal"
            when: control.isNormal
            PropertyChanges {
                target: backgroundId
                color: Style.Colors.buttonFeatureNormal
                border.color: Style.Colors.buttonFeatureBorderNormal
                width: control.width-3; height: control.height-3
            }
            PropertyChanges {
                target: textId
                color: Style.Colors.buttonFeatureTextNormal
            }
        },
        State {
            name: "hover"
            when: control.isHover
            PropertyChanges {
                target: backgroundId
                color: Style.Colors.buttonFeatureNormal
                border.color: Style.Colors.buttonFeatureBorderHover
                width: control.width; height: control.height
            }
            PropertyChanges {
                target: textId
                color: Style.Colors.buttonFeatureTextHover
            }
        },
        State {
            name: "pressed"
            when: control.isPressed
            PropertyChanges {
                target: backgroundId
                color: Style.Colors.buttonFeatureHover
                border.color: Style.Colors.buttonFeatureBorderHover
                width: control.width; height: control.height
            }
            PropertyChanges {
                target: textId
                color: Style.Colors.buttonFeatureTextHover
            }
        },
        State {
            name: "checked"
            when: control.isChecked
            PropertyChanges {
                target: backgroundId
                color: control.pressed? Style.Colors.buttonFeatureHover: Style.Colors.buttonFeatureSelected
                border.color: Style.Colors.buttonFeatureBorderHover
                width: control.hovered? control.width: control.width-3; height: control.hovered? control.height: control.height-3
            }
            PropertyChanges {
                target: textId
                color: Style.Colors.buttonFeatureTextHover
            }
        }
    ]
}
