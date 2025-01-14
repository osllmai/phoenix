import QtQuick 2.15
import QtQuick.Templates 2.1 as T
// import Qt5Compat.GraphicalEffects
import '../style' as Style

T.Button {
    id: control
    width: 100; height: 30
    padding: 4

    property var myText
    property int bottonType: Style.RoleEnum.BottonType.Primary

    background: Rectangle{
        id: backgroundId
        anchors.fill: parent
        radius: 5
        Text {
            id: textId
            text: control.myText
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    function choiceBackgroundColor(buttonType, state) {
        switch (state) {
                case Style.RoleEnum.State.Normal:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryNormal;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerNormal;
                        default:
                            return Style.Colors.buttonPrimaryNormal;
                    }
                case Style.RoleEnum.State.Hover:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryHover;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerHover;
                        default:
                            return Style.Colors.buttonPrimaryHover;
                    }
                case Style.RoleEnum.State.Pressed:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryPressed;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerPressed;
                        default:
                            return Style.Colors.buttonPrimaryPressed;
                    }
                case Style.RoleEnum.State.Disabled:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryDisabled;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerDisabled;
                        default:
                            return Style.Colors.buttonPrimaryDisabled;
                    }
                case Style.RoleEnum.State.Selected:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimarySelected;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerSelected;
                        default:
                            return Style.Colors.buttonPrimarySelected;
                    }
                default:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryNormal;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerNormal;
                        default:
                            return Style.Colors.buttonPrimaryNormal;
                    }
            }
    }

    function choiceTextColor(buttonType, state) {
        switch (state) {
                case Style.RoleEnum.State.Normal:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextNormal;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextNormal;
                        default:
                            return Style.Colors.buttonPrimaryTextNormal;
                    }
                case Style.RoleEnum.State.Hover:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextHover;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextHover;
                        default:
                            return Style.Colors.buttonPrimaryTextHover;
                    }
                case Style.RoleEnum.State.Pressed:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextPressed;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextPressed;
                        default:
                            return Style.Colors.buttonPrimaryTextPressed;
                    }
                case Style.RoleEnum.State.Disabled:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextDisabled;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextDisabled;
                        default:
                            return Style.Colors.buttonPrimaryTextDisabled;
                    }
                case Style.RoleEnum.State.Selected:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextSelected;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextSelected;
                        default:
                            return Style.Colors.buttonPrimaryTextSelected;
                    }
                default:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextNormal;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextNormal;
                        default:
                            return Style.Colors.buttonPrimaryTextNormal;
                    }
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
                color: control.choiceBackgroundColor(bottonType, Style.RoleEnum.State.Normal)
            }
            PropertyChanges {
                target: textId
                color: control.choiceTextColor(bottonType, Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "hover"
            when: control.isHover
            PropertyChanges {
                target: backgroundId
                color: control.choiceBackgroundColor(bottonType, Style.RoleEnum.State.Hover)
            }
            PropertyChanges {
                target: textId
                color: control.choiceTextColor(bottonType, Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "pressed"
            when: control.isPressed
            PropertyChanges {
                target: backgroundId
                color: control.choiceBackgroundColor(bottonType, Style.RoleEnum.State.Pressed)
            }
            PropertyChanges {
                target: textId
                color: control.choiceTextColor(bottonType, Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "disabled"
            when: control.isDisabled
            PropertyChanges {
                target: backgroundId
                color: control.choiceBackgroundColor(bottonType, Style.RoleEnum.State.Disabled)
            }
            PropertyChanges {
                target: textId
                color: control.choiceTextColor(bottonType, Style.RoleEnum.State.Normal)
            }
        }
    ]
}
