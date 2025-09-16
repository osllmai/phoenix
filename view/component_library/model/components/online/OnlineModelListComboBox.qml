import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import '../../../style' as Style
import "../../../button"

ComboBox {
    id: comboBoxId
    height: comboBoxId.smallComboBox? 30: 35
    width: comboBoxId.smallComboBox? 30: 160
    font.pixelSize: 12

    property bool smallComboBox: false

    Accessible.role: Accessible.ComboBox
    contentItem: Item{
        MyIcon{
            id: iconOpenId2
            visible: comboBoxId.smallComboBox
            myIcon: popupId.visible ? "qrc:/media/icon/up.svg" : "qrc:/media/icon/down.svg"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    comboBoxId.popup.visible ? comboBoxId.popup.close() : comboBoxId.popup.open()
                }
            }
        }

        Row {
            id: contentRow
            visible: !comboBoxId.smallComboBox
            height: comboBoxId.height
            width: comboBoxId.width

            Label {
                id: textId
                text: "   " +(onlineModelList.currentModel? onlineModelList.currentModel.name: "")
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - iconOpenId.width /*- iconId.width*/
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
    }

    popup: Popup {
        id: popupId
        y: comboBoxId.height + 10
        width: 160
        height: Math.min(300, listView.contentHeight)

        background: null
        contentItem: Rectangle{
            color: Style.Colors.background
            anchors.fill: parent
            border.width: 1
            border.color: Style.Colors.boxBorder
            radius: 8

            ListView {
                id: listView
                anchors.fill: parent
                anchors.margins: 5
                clip: true
                // cacheBuffer: Math.max(0, listView.contentHeight)
                interactive: contentHeight > height
                boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds
                ScrollBar.vertical: ScrollBar {
                    policy: listView.contentHeight > listView.height
                            ? ScrollBar.AlwaysOn
                            : ScrollBar.AlwaysOff
                }
                ScrollIndicator.vertical: ScrollIndicator { }
                implicitHeight: Math.min(contentHeight, 240)
                model: onlineModelList

                delegate: Item{
                    width: listView.width - 10; height: 45

                    OnlineModelDelegateComboBox {
                       id: indoxItem
                       anchors.fill: parent; anchors.margins: indoxItem.hovered? 2: 4
                       Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
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
