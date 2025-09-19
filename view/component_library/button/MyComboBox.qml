import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import '../style' as Style

ComboBox {
    id: comboBoxId
    height: 35
    width: 160
    font.pixelSize: 12
    leftPadding: 10

    property var fullModel: []
    property string searchText: ""

    property color backgroundColor: choiceBackgroundColor(Style.RoleEnum.State.Normal)
    property color borderColor: choiceBackgroundColor(Style.RoleEnum.State.Normal)
    property color textColor: choiceTextColor(Style.RoleEnum.State.Normal)

    onModelChanged: {
        fullModel = model
        filterModel(searchText)
    }

    function filterModel(text) {
        searchText = text
        if (text === "") {
            comboBoxId.model = fullModel
            return
        }

        comboBoxId.model = fullModel.filter(function(item) {
            return item.toLowerCase().indexOf(text.toLowerCase()) !== -1
        })
    }

    Component.onCompleted: {
        fullModel = comboBoxId.model
        filterModel("")
    }

    Accessible.role: Accessible.ComboBox
    contentItem: Loader {
        id: contentLoader
        anchors.fill: parent
        active: true
        sourceComponent: comboBoxId.width > 36 ? fullContent : iconOnly

        Component {
            id: fullContent
            Row {
                id: contentRow
                anchors.fill: parent
                anchors.leftMargin: 10
                Label {
                    id: textId
                    text: comboBoxId.displayText
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - iconId.width
                    color: comboBoxId.textColor
                    verticalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    clip: true
                }
                MyIcon {
                    id: iconId
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

        Component {
            id: iconOnly
            Item {
                anchors.fill: parent
                MyIcon {
                    id: iconIdSmall
                    anchors.centerIn: parent
                    myIcon: popupId.visible ? "qrc:/media/icon/up.svg" : "qrc:/media/icon/down.svg"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            comboBoxId.popup.visible ? comboBoxId.popup.close() : comboBoxId.popup.open()
                        }
                    }
                }
            }
        }
    }


    delegate: ItemDelegate {
        height: 35; width: popupId.width /*- 50*/
        contentItem: Label {
            text: modelData
            color: Style.Colors.textInformation
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            radius: 10
            width: popupId.width /*- 50*/; height: 35
            color: highlighted ? Style.Colors.boxHover : Style.Colors.background
        }
        highlighted: comboBoxId.highlightedIndex === index
    }

    popup: Popup {
        id: popupId
        y: comboBoxId.height - 4
        x: - 10
        width: comboBoxId.width>36?comboBoxId.width + 20 : 120
        implicitHeight: Math.min(contentItem.implicitHeight + 50, 260)

        background: null
        contentItem: Rectangle {
            implicitWidth: /*myListView.contentWidth*/ comboBoxId.width
            implicitHeight: myListView.contentHeight
            color: Style.Colors.background
            border.width: 1; border.color: Style.Colors.boxBorder
            radius: 10
            ListView {
                id: myListView
                width: parent.width
                height: parent.height
                anchors.fill: parent
                anchors.margins: 5
                clip: true
                cacheBuffer: Math.max(0, myListView.contentHeight)
                interactive: contentHeight > height
                boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds
                ScrollBar.vertical: ScrollBar {
                    policy: myListView.contentHeight > myListView.height
                            ? ScrollBar.AlwaysOn
                            : ScrollBar.AlwaysOff
                }
                implicitHeight: Math.min(contentHeight, 240)
                model: comboBoxId.popup.visible ? comboBoxId.delegateModel : null
                currentIndex: comboBoxId.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }
        }
    }
    indicator: Image {}
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
