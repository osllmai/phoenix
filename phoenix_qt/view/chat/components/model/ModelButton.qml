import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import '../../../component_library/style' as Style
import '../../../component_library/button'


 T.Button{
    id:control
    height: 35; width: logoButton.width + textId.width + openButton.width + 35 + 15
    property var myText
    property bool isOpen

    signal open()

    background: Rectangle{
        id: backgroundId
        width: parent.width; height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        radius: 12
        border.width: 1

        Item{
            width: logoButton.width + textId.width
            height: parent.height
            Image {
                id: logoButton
                source: "qrc:/media/image_company/Phoenix.png"
                sourceSize.height: control.height - 10
                sourceSize.width: control.height - 10
                fillMode: Image.PreserveAspectCrop
                anchors.verticalCenter: parent.verticalCenter
                smooth: true
                clip: true
                anchors.left: parent.left
                anchors.leftMargin: 5
            }
            Text {
                id: textId
                height: parent.height
                text: control.myText
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 10
                color: Style.Colors.textTitle
                anchors.left: logoButton.right
                anchors.leftMargin: 5
            }
            MyIcon {
                id: openButton
                myIcon: control.isOpen?"qrc:/media/icon/up.svg": "qrc:/media/icon/down.svg"
                iconType: Style.RoleEnum.IconType.Primary
                Connections {
                    target: openButton
                    function onClicked(){
                        control.open()
                    }
                }
                anchors.left: textId.right
                anchors.leftMargin: 35
            }
        }
    }
    MouseArea{
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked:{
            control.open()
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
                width: control.width-3; height: control.height-3
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
                width: control.isNeedAnimation? control.width: parent.width-3; height: control.isNeedAnimation? control.height: control.height-3
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
                width: control.isNeedAnimation? control.width: parent.width-3; height: control.isNeedAnimation? control.height: control.height-3
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
                width: control.width-3; height: control.height-3
            }
            PropertyChanges {
                target: textId
                color: control.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        }
    ]
}
