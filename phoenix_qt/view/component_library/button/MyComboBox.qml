import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import '../style' as Style

ComboBox {
    id: comboBoxId
    font.pixelSize: 12
    spacing: 0
    padding: 10

    Accessible.role: Accessible.ComboBox
    contentItem: Row {
        id: contentRow
        spacing: 0
        Label {
            id: textId
            text: comboBoxId.displayText
            clip: true
            width: parent.width - iconId.width
            color: Style.Colors.textTitle
            verticalAlignment: Text.AlignLeft
            elide: Text.ElideRight
        }
        MyIcon{
            id:iconId
            myIcon: popupId.visible ? "qrc:/media/icon/up.svg" : "qrc:/media/icon/down.svg"
        }
    }
    delegate: ItemDelegate {
        width: comboBoxId.width - 20
        contentItem: Label {
            text: modelData
            color: Style.Colors.textInformation
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            radius: 10
            color: highlighted ? Style.Colors.boxHover : Style.Colors.background
        }
        highlighted: comboBoxId.highlightedIndex === index
    }
    popup: Popup {
        id: popupId
        y: comboBoxId.height - 1
        width: comboBoxId.width
        implicitHeight: Math.min(contentItem.implicitHeight + 20, 260)
        padding: 0

        contentItem: Rectangle {
            implicitWidth: myListView.contentWidth
            implicitHeight: myListView.contentHeight
            color: Style.Colors.background
            ListView {
                id: myListView
                anchors.fill: parent
                anchors.margins: 10
                clip: true
                implicitHeight: Math.min(contentHeight, 240)
                model: comboBoxId.popup.visible ? comboBoxId.delegateModel : null
                currentIndex: comboBoxId.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }
        }

        background: Rectangle {
            color: Style.Colors.background
            border.color: Style.Colors.boxBorder
            border.width: 1
            radius: 10
        }
    }
    indicator: Image {}
    background: Rectangle {
        color: Style.Colors.background
        border.width: 1
        border.color: Style.Colors.boxBorder
        radius: 10
    }
    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
}
