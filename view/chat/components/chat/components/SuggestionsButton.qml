import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import '../../../../component_library/style' as Style
import '../../../../component_library/button'

T.Button {
    id: control
    height: 35
    width: parent.width

    property bool selected:  false

    property color backgroundColor: choiceBackgroundColor(Style.RoleEnum.State.Normal)
    property color borderColor: choiceBackgroundColor(Style.RoleEnum.State.Normal)
    property color textColor: choiceTextColor(Style.RoleEnum.State.Normal)

    contentItem:Label{
        text: modelData
        color: control.textColor
        anchors.fill: parent
        anchors.leftMargin: 10
        clip: true
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        id: backgroundId
        color: control.backgroundColor
        border.width: 1; border.color: Style.Colors.boxBorder
        radius: 10
    }

    function choiceBackgroundColor(state) {
        switch (state) {
                case Style.RoleEnum.State.Normal:
                    return Style.Colors.background;

                case Style.RoleEnum.State.Hover:
                    return Style.Colors.buttonSecondaryHover;

                case Style.RoleEnum.State.Pressed:
                    return Style.Colors.buttonSecondaryPressed;

                case Style.RoleEnum.State.Disabled:
                    return Style.Colors.buttonSecondaryDisabled;

                case Style.RoleEnum.State.Selected:
                        return Style.Colors.buttonSecondarySelected;

                default:
                    return Style.Colors.background;
            }
    }

    function choiceTextColor(state) {
        switch (state) {
                case Style.RoleEnum.State.Normal:
                    return Style.Colors.textInformation;

                case Style.RoleEnum.State.Hover:
                    return Style.Colors.buttonSecondaryTextHover;

                case Style.RoleEnum.State.Pressed:
                    return Style.Colors.buttonSecondaryTextPressed;

                case Style.RoleEnum.State.Disabled:
                    return Style.Colors.buttonSecondaryTextDisabled;

                case Style.RoleEnum.State.Selected:
                    return Style.Colors.buttonSecondaryTextSelected;

                default:
                    return Style.Colors.textInformation;
            }
    }

    property bool isNormal: !control.hovered && !control.pressed && !control.selected && control.enabled && !control.checked
    property bool isHover: (control.hovered ||control.selected) && !control.pressed && control.enabled
    property bool isPressed: (control.pressed) && control.enabled
    property bool isDisabled: !control.enabled
    property bool isSelected: control.checked

    states: [
        State {
            name: "normal"
            when: control.isNormal
            PropertyChanges {
                target: control
                backgroundColor: control.choiceBackgroundColor(Style.RoleEnum.State.Normal)
                borderColor: control.choiceBackgroundColor(Style.RoleEnum.State.Normal)
                textColor: control.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "hover"
            when: control.isHover
            PropertyChanges {
                target: control
                backgroundColor: control.choiceBackgroundColor(Style.RoleEnum.State.Hover)
                borderColor: control.choiceBackgroundColor(Style.RoleEnum.State.Hover)
                textColor: control.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "pressed"
            when: control.isPressed
            PropertyChanges {
                target: control
                backgroundColor: control.choiceBackgroundColor(Style.RoleEnum.State.Pressed)
                borderColor: control.choiceBackgroundColor(Style.RoleEnum.State.Pressed)
                textColor: control.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "disabled"
            when: control.isDisabled
            PropertyChanges {
                target: control
                backgroundColor: control.choiceBackgroundColor(Style.RoleEnum.State.Disabled)
                borderColor: control.choiceBackgroundColor(Style.RoleEnum.State.Disabled)
                textColor: control.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "selected"
            when: control.isSelected
            PropertyChanges {
                target: control
                backgroundColor: control.choiceBackgroundColor(Style.RoleEnum.State.Selected)
                borderColor: control.choiceBackgroundColor(Style.RoleEnum.State.Selected)
                textColor: control.choiceTextColor(Style.RoleEnum.State.Selected)
            }
        }
    ]
}
