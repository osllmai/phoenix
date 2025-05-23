import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import './../../component_library/style' as Style
import './../../component_library/button'
import './../../component_library/model'

ComboBox {
    id: comboBoxId
    height: 35
    width: 160
    font.pixelSize: 12
    property int modelId: conversationList.modelSelect? conversationList.modelId: -1
    property string modelName: conversationList.modelSelect? conversationList.modelText:"Phoenix"
    property string modelIcon: conversationList.modelSelect? conversationList.modelIcon:"qrc:/media/image_company/Phoenix.png"

    Accessible.role: Accessible.ComboBox
    contentItem: Row {
        id: contentRow
        MyIcon{
            id:iconId
            width: 33; height: 33
            myIcon: comboBoxId.modelIcon
            anchors.verticalCenter: parent.verticalCenter
            iconType: Style.RoleEnum.IconType.Image
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    comboBoxId.popup.visible ? comboBoxId.popup.close() : comboBoxId.popup.open()
                }
            }
        }
        Label {
            id: textId
            text: comboBoxId.modelName
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - iconId.width - iconId.width
            color: Style.Colors.textTitle
            verticalAlignment: Text.AlignLeft
            elide: Text.ElideRight
            clip: true
        }
        MyIcon{
            id: iconOpenId
            myIcon: popupId.visible ? "qrc:/media/icon/up.svg" : "qrc:/media/icon/down.svg"
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    comboBoxId.popup.visible ? comboBoxId.popup.close() : comboBoxId.popup.open()
                }
            }
        }
    }

    popup: Popup {
        id: popupId
        y: comboBoxId.height + 10
        width: 300
        height: 300
        // implicitHeight: Math.min(contentItem.implicitHeight + 20, 260)

        background: null
        contentItem: ModelSelectView{
            id: modelSelect
        }
    }
    indicator: Image {}
    background: Rectangle {
        id: backgroundId
        color: Style.Colors.background
        border.width: 1; border.color: Style.Colors.boxBorder
        radius: 10
    }
    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval

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

    property bool isNormal: !comboBoxId.hovered && !comboBoxId.pressed && comboBoxId.enabled
    property bool isHover: comboBoxId.hovered && !comboBoxId.pressed && comboBoxId.enabled
    property bool isPressed: comboBoxId.pressed && comboBoxId.enabled
    property bool isDisabled: !comboBoxId.enabled

    states: [
        State {
            name: "normal"
            when: comboBoxId.isNormal
            PropertyChanges {
                target: backgroundId
                color: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Normal)
                border.color: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Normal)
                width: comboBoxId.width-3; height: comboBoxId.height-3
            }
            PropertyChanges {
                target: textId
                color: comboBoxId.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "hover"
            when: comboBoxId.isHover
            PropertyChanges {
                target: backgroundId
                color: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Hover)
                border.color: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Hover)
                width: comboBoxId.isNeedAnimation? comboBoxId.width: parent.width-3; height: comboBoxId.isNeedAnimation? comboBoxId.height: comboBoxId.height-3
            }
            PropertyChanges {
                target: textId
                color: comboBoxId.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "pressed"
            when: comboBoxId.isPressed
            PropertyChanges {
                target: backgroundId
                color: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Pressed)
                border.color: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Pressed)
                width: comboBoxId.isNeedAnimation? comboBoxId.width: parent.width-3; height: comboBoxId.isNeedAnimation? comboBoxId.height: comboBoxId.height-3
            }
            PropertyChanges {
                target: textId
                color: comboBoxId.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "disabled"
            when: comboBoxId.isDisabled
            PropertyChanges {
                target: backgroundId
                color: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Disabled)
                border.color: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Disabled)
                width: comboBoxId.width-3; height: comboBoxId.height-3
            }
            PropertyChanges {
                target: textId
                color: comboBoxId.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        }
    ]
}
