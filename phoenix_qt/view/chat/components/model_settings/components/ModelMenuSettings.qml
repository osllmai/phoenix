import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import QtQuick.Templates 2.1 as T

import '../../../../component_library/style' as Style
import '../../../../component_library/button'

 T.Button{
    id:control
    height: 35; width: parent.width

    property var myText
    property bool isOpen

    function selectIcon(){
        if(isOpen){
            return "qrc:/media/icon/up.svg";
        }else{
            return "qrc:/media/icon/down.svg";
        }
    }

    background: Rectangle{
        id: backgroundId
        width: parent.width; height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        radius: 8
        border.width: 1
        Row{
            anchors.fill: parent
            leftPadding: 10
            Label {
                id: textId
                width: parent.width - iconOpenId.width - 10 ; height: parent.height
                text: control.myText
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 10
                color: Style.Colors.textTitle

            }
            MyIcon {
                id: iconOpenId
                myIcon: control.selectIcon()
                iconType: Style.RoleEnum.IconType.Primary
                enabled: false
            }
        }
    }
    function choiceBackgroundColor(state) {
        switch (state) {
                case Style.RoleEnum.State.Normal:
                    return Style.Colors.buttonSecondaryNormal;

                case Style.RoleEnum.State.Hover:
                    return Style.Colors.buttonSecondaryHover;

                case Style.RoleEnum.State.Pressed:
                    return Style.Colors.buttonSecondaryPressed;

                case Style.RoleEnum.State.Disabled:
                    return Style.Colors.buttonSecondaryDisabled;

                case Style.RoleEnum.State.Selected:
                        return Style.Colors.buttonSecondarySelected;

                default:
                    return Style.Colors.buttonSecondaryNormal;
            }
    }

    function choiceTextColor(state) {
        switch (state) {
                case Style.RoleEnum.State.Normal:
                    return Style.Colors.buttonSecondaryTextNormal;

                case Style.RoleEnum.State.Hover:
                    return Style.Colors.buttonSecondaryTextHover;

                case Style.RoleEnum.State.Pressed:
                    return Style.Colors.buttonSecondaryTextPressed;

                case Style.RoleEnum.State.Disabled:
                    return Style.Colors.buttonSecondaryTextDisabled;

                case Style.RoleEnum.State.Selected:
                    return Style.Colors.buttonSecondaryTextSelected;

                default:
                    return Style.Colors.buttonSecondaryTextNormal;
            }
    }

    property bool isNormal: !control.hovered && !control.pressed && control.enabled
    property bool isHover: control.hovered && !control.pressed && control.enabled
    property bool isPressed: control.pressed && control.enabled
    property bool isDisabled: !control.enabled

    states: [
        State {
            name: "normal"
            when: control.isNormal
            PropertyChanges {
                target: backgroundId
                color: control.choiceBackgroundColor(Style.RoleEnum.State.Normal)
                border.color: control.choiceBackgroundColor(Style.RoleEnum.State.Normal)
            }
            PropertyChanges {
                target: textId
                color: control.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "hover"
            when: control.isHover
            PropertyChanges {
                target: backgroundId
                color: control.choiceBackgroundColor(Style.RoleEnum.State.Hover)
                border.color: control.choiceBackgroundColor(Style.RoleEnum.State.Hover)
            }
            PropertyChanges {
                target: textId
                color: control.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "pressed"
            when: control.isPressed
            PropertyChanges {
                target: backgroundId
                color: control.choiceBackgroundColor(Style.RoleEnum.State.Pressed)
                border.color: control.choiceBackgroundColor(Style.RoleEnum.State.Pressed)
            }
            PropertyChanges {
                target: textId
                color: control.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "disabled"
            when: control.isDisabled
            PropertyChanges {
                target: backgroundId
                color: control.choiceBackgroundColor(Style.RoleEnum.State.Disabled)
                border.color: control.choiceBackgroundColor(Style.RoleEnum.State.Disabled)
            }
            PropertyChanges {
                target: textId
                color: control.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        }
    ]
}

