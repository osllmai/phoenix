import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import './../style' as Style
import './../button'

ComboBox {
    id: comboBoxId
    height: 35
    width: 160
    font.pixelSize: 12

    property bool modelSelect: false
    property int modelId: -1
    property string modelName: "Phoenix"
    property string modelIcon: "qrc:/media/image_company/phoenix.png"
    signal setModelRequest(int id, string name, string icon, string promptTemplate, string systemPrompt)

    Accessible.role: Accessible.ComboBox
    contentItem: Row {
        id: contentRow
        height: comboBoxId.height
        width: comboBoxId.width
        MyIcon{
            id:iconId
            width: 33; height: 33
            myIcon: comboBoxId.modelIcon
            anchors.topMargin: 0
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
            anchors.verticalCenter: iconId.verticalCenter
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
        closePolicy: Popup.NoAutoClose
        width: 260
        height: 360
        background: null
/////////////////////////////////////////
        contentItem: Loader {
            id: popupLoader
            anchors.fill: parent
            active: popupId.visible
            sourceComponent: ModelSelectView {
                id: modelSelectId
                anchors.fill: parent
                modelSelect: comboBoxId.modelSelect
                modelId: comboBoxId.modelId
                modelName: comboBoxId.modelName
                modelIcon: comboBoxId.modelIcon

                Connections {
                    target: modelSelectId
                    function onSetModelRequest(id, name, icon, promptTemplate, systemPrompt) {
                        comboBoxId.setModelRequest(id, name, icon, promptTemplate, systemPrompt)
                    }
                }
            }
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
