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
    contentItem: RowLayout {
        id: contentRow
        spacing: 0
        Text {
            id: textId
            Layout.fillWidth: true
            leftPadding: 10
            rightPadding: 20
            text: comboBoxId.displayText
            font: comboBoxId.font
            color: Style.Theme.informationTextColor
            verticalAlignment: Text.AlignLeft
            elide: Text.ElideRight
        }
        Item {
            Layout.preferredWidth: updown.width
            Layout.preferredHeight: updown.height
            Image {
                id: updown
                anchors.verticalCenter: parent.verticalCenter
                sourceSize.width: comboBoxId.font.pixelSize
                sourceSize.height: comboBoxId.font.pixelSize
                mipmap: true
                visible: false
                source: popupId.visible? "images/upIcon.svg":"images/downIcon.svg"
            }

            ColorOverlay {
                anchors.fill: updown
                source: updown
                color: Style.Theme.iconColor
            }
        }
    }
    delegate: ItemDelegate {
        width: comboBoxId.width - 20
        contentItem: Text {
            text: modelData
            color: Style.Theme.informationTextColor
            font.family: Style.Theme.fontFamily
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            radius: 10
            color: highlighted? Style.Theme.selectButtonColor: Style.Theme.normalButtonColor
        }
        highlighted: comboBoxId.highlightedIndex === index
    }
    popup: Popup {
        id: popupId
        y: comboBoxId.height - 1
        width: comboBoxId.width
        implicitHeight: contentItem.implicitHeight + 20
        padding: 0

        contentItem: Rectangle {
            implicitWidth: myListView.contentWidth
            implicitHeight: myListView.contentHeight
            color: "transparent"
            ListView {
                id: myListView
                anchors.fill: parent
                anchors.margins: 10
                clip: true
                implicitHeight: contentHeight
                model: comboBoxId.popup.visible ? comboBoxId.delegateModel : null
                currentIndex: comboBoxId.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }
        }

        background: Rectangle {
            color: Style.Theme.normalButtonColor
            border.color: Style.Theme.selectButtonColor
            border.width: 1
            radius: 10
        }
    }
    indicator: Image {}
    background: Rectangle {
        color: Style.Theme.normalButtonColor
        border.width: 1
        border.color: Style.Theme.selectButtonColor
        radius: 10
    }
    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
}
