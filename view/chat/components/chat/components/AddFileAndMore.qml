import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../../../component_library/style" as Style
import "../../../../component_library/button"

ComboBox {
    id: comboBoxId
    width: 32
    height: 32
    editable: false
    focusPolicy: Qt.ClickFocus

    property color backgroundColor: choiceBackgroundColor(Style.RoleEnum.State.Normal)
    property color borderColor: choiceBackgroundColor(Style.RoleEnum.State.Normal)
    property color textColor: choiceTextColor(Style.RoleEnum.State.Normal)

    contentItem: Item {
        anchors.fill: parent

        MyIcon {
            anchors.centerIn: parent
            width: 32; height: 32
            myIcon: "qrc:/media/icon/add.svg"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (comboBoxId.popup.visible)
                    comboBoxId.popup.close()
                else
                    comboBoxId.popup.open()
            }
        }
    }

    popup: Popup {
        id: popupId
        width: 180
        x: 0
        y: comboBoxId.height + 4
        modal: false
        focus: true
        padding: 0

        background: Rectangle {
            radius: 10
            color: Style.Colors.background
            border.width: 1
            border.color: Style.Colors.boxBorder
        }

        contentItem: ListView {
            id: listView
            width: parent.width
            implicitHeight: Math.min(contentHeight, 220)
            clip: true

            model: ListModel {
                ListElement { title: "Add photos & files"; icon:"qrc:/media/icon/selectFile.svg" }
                ListElement { title: "Create image"; icon:"qrc:/media/icon/imageEditor.svg" }
                ListElement { title: "Thinking"; icon:"qrc:/media/icon/indoxJudge.svg" }
                ListElement { title: "Deep research"; icon:"qrc:/media/icon/deepSearch.svg" }
                ListElement { title: "Study and Learn"; icon:"qrc:/media/icon/indoxJudge.svg" }
                ListElement { title: "Web Search"; icon:"qrc:/media/icon/indoxGen.svg" }
                ListElement { title: "Canvas"; icon:"qrc:/media/icon/developer.svg" }
            }

            delegate: ItemDelegate {
                width: listView.width
                height: 38

                Row {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 10

                    MyIcon {
                        width: 32; height: 32
                        myIcon: model.icon
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Label {
                        text: model.title
                        verticalAlignment: Text.AlignVCenter
                        color: comboBoxId.textColor
                    }
                }
                background: Rectangle {
                    radius: 10
                    width: popupId.width /*- 50*/; height: 35
                    color: highlighted ? Style.Colors.boxHover : Style.Colors.background
                }
                highlighted: /*comboBoxId.highlightedIndex === index*/true
            }
        }
    }

    indicator: null

    background: Rectangle {
        id: backgroundId
        color: comboBoxId.backgroundColor
        border.color: comboBoxId.borderColor
        border.width: 1
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
                target: comboBoxId
                backgroundColor: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Normal)
                borderColor: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Normal)
                textColor: comboBoxId.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "hover"
            when: comboBoxId.isHover
            PropertyChanges {
                target: comboBoxId
                backgroundColor: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Hover)
                borderColor: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Hover)
                textColor: comboBoxId.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "pressed"
            when: comboBoxId.isPressed
            PropertyChanges {
                target: comboBoxId
                backgroundColor: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Pressed)
                borderColor: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Pressed)
                textColor: comboBoxId.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "disabled"
            when: comboBoxId.isDisabled
            PropertyChanges {
                target: comboBoxId
                backgroundColor: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Disabled)
                borderColor: comboBoxId.choiceBackgroundColor(Style.RoleEnum.State.Disabled)
                textColor: comboBoxId.choiceTextColor(Style.RoleEnum.State.Normal)
            }
        }
    ]
}
