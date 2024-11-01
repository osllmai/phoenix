import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

ComboBox {
    id: comboBoxId
    font.pixelSize: 12
    spacing: 0
    padding: 10

    property color backgroundPageColor
    property color backgroungColor
    property color glowColor
    property color boxColor
    property color headerColor
    property color normalButtonColor
    property color selectButtonColor
    property color hoverButtonColor
    property color fillIconColor
    property color iconColor

    property color titleTextColor
    property color informationTextColor
    property color selectTextColor

    property var fontFamily

    Accessible.role: Accessible.comboBoxId
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
            color: "black"
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
                source: "./images/chatIcon.svg"
            }

            ColorOverlay {
                anchors.fill: updown
                source: updown
                color: "red"
            }
        }
    }
    delegate: ItemDelegate {
        width: comboBoxId.width -20
        contentItem: Text {
            text: modelData
            color: "black"
            font: comboBoxId.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            radius: 10
            color: "white"
        }
        highlighted: comboBoxId.highlightedIndex === index
    }
    popup: Popup {
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
            color: "white"
            border.color: "yellow"
            border.width: 1
            radius: 10
        }
    }
    indicator: Item {
    }
    background: Rectangle {
        color: "white"
        border.width: 1
        border.color: "blue"
        radius: 10
    }
    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
}
