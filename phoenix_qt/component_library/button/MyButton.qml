import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import '../style' as Style

T.Button {
    id: control
    width: (textBoxId.visible? (iconId.width + textId.width + 20): control.height); height: 32
    padding: 5

    property var myText: ""
    property var myIcon: ""
    property bool textIsVisible: true
    property int bottonType: Style.RoleEnum.BottonType.Primary
    signal actionClicked()

    // ShaderEffect
    MouseArea {
        anchors.fill: parent
        onClicked: (mouse)=> {
            control.state = "pressed"
            control.actionClicked()
            resetTimer.start()
        }
    }
    Timer {
        id: resetTimer
        interval: 150
        repeat: false
        onTriggered: {
            if(control.state == "pressed")
                control.state = "hover"
        }
    }
    background: Rectangle{
        id: backgroundId
        width: parent.width; height: parent.height
        radius: 8
        border.width: 1

        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            ToolButton {
                id: iconId
                visible: control.myIcon != ""
                background: Rectangle { color: "#00ffffff" }
                icon{
                    source: control.myIcon
                    color: textId.color
                    width:18; height:18
                }
            }
            Item{
                id:textBoxId
                width: textId.width + (iconId.visible? 10: 0)
                height: textId.height
                visible: (control.myText != "") && (control.textIsVisible)
                Text {
                    id: textId
                    height: iconId.height
                    text: control.myText
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    function choiceBackgroundColor(buttonType, state) {
        switch (state) {
                case Style.RoleEnum.State.Normal:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryNormal;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryNormal;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerNormal;
                        default:
                            return Style.Colors.buttonPrimaryNormal;
                    }
                case Style.RoleEnum.State.Hover:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryHover;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryHover;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerHover;
                        default:
                            return Style.Colors.buttonPrimaryHover;
                    }
                case Style.RoleEnum.State.Pressed:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryPressed;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryPressed;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerPressed;
                        default:
                            return Style.Colors.buttonPrimaryPressed;
                    }
                case Style.RoleEnum.State.Disabled:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryDisabled;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryDisabled;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerDisabled;
                        default:
                            return Style.Colors.buttonPrimaryDisabled;
                    }
                case Style.RoleEnum.State.Selected:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimarySelected;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondarySelected;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerSelected;
                        default:
                            return Style.Colors.buttonPrimarySelected;
                    }
                default:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryNormal;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryNormal;
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
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryTextNormal;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextNormal;
                        default:
                            return Style.Colors.buttonPrimaryTextNormal;
                    }
                case Style.RoleEnum.State.Hover:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextHover;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryTextHover;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextHover;
                        default:
                            return Style.Colors.buttonPrimaryTextHover;
                    }
                case Style.RoleEnum.State.Pressed:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextPressed;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryTextPressed;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextPressed;
                        default:
                            return Style.Colors.buttonPrimaryTextPressed;
                    }
                case Style.RoleEnum.State.Disabled:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextDisabled;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryTextDisabled;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextDisabled;
                        default:
                            return Style.Colors.buttonPrimaryTextDisabled;
                    }
                case Style.RoleEnum.State.Selected:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextSelected;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryTextSelected;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextSelected;
                        default:
                            return Style.Colors.buttonPrimaryTextSelected;
                    }
                default:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextNormal;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryTextNormal;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextNormal;
                        default:
                            return Style.Colors.buttonPrimaryTextNormal;
                    }
            }
    }

    function choiceBorderColor(buttonType, state) {
        switch (state) {
                case Style.RoleEnum.State.Normal:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryBorderNormal;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryBorderNormal;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerBorderNormal;
                        default:
                            return Style.Colors.buttonPrimaryBorderNormal;
                    }
                case Style.RoleEnum.State.Hover:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryBorderHover;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryBorderHover;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerBorderHover;
                        default:
                            return Style.Colors.buttonPrimaryBorderHover;
                    }
                case Style.RoleEnum.State.Pressed:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryBorderPressed;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryBorderPressed;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerBorderPressed;
                        default:
                            return Style.Colors.buttonPrimaryBorderPressed;
                    }
                case Style.RoleEnum.State.Disabled:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryBorderDisabled;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryBorderDisabled;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerBorderDisabled;
                        default:
                            return Style.Colors.buttonPrimaryBorderDisabled;
                    }
                case Style.RoleEnum.State.Selected:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryBorderSelected;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryBorderSelected;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerBorderSelected;
                        default:
                            return Style.Colors.buttonPrimaryBorderSelected;
                    }
                default:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryBorderNormal;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryBorderNormal;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerBorderNormal;
                        default:
                            return Style.Colors.buttonPrimaryBorderNormal;
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
                target: backgroundId
                border.color: control.choiceBorderColor(bottonType, Style.RoleEnum.State.Normal)
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
                target: backgroundId
                border.color: control.choiceBorderColor(bottonType, Style.RoleEnum.State.Hover)
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
                target: backgroundId
                border.color: control.choiceBorderColor(bottonType, Style.RoleEnum.State.Pressed)
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
                target: backgroundId
                border.color: control.choiceBorderColor(bottonType, Style.RoleEnum.State.Disabled)
            }
            PropertyChanges {
                target: textId
                color: control.choiceTextColor(bottonType, Style.RoleEnum.State.Normal)
            }
        }
    ]
}
