import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import '../style' as Style

ComboBox {
    id: comboBoxId
    font.pixelSize: 12
    leftPadding: 10

    Accessible.role: Accessible.ComboBox
    contentItem: Row {
        id: contentRow
        Label {
            id: textId
            text: comboBoxId.displayText
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - iconId.width
            color: Style.Colors.textTitle
            verticalAlignment: Text.AlignLeft
            elide: Text.ElideRight
            clip: true
        }
        MyIcon{
            id:iconId
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

    delegate: ItemDelegate {
        function selectColor(){
            if(comboBoxId.displayText === modelData){
                return /*Style.Colors.boxChecked*/ "red"
            }else if(comboBoxId.highlightedIndex === index){
                return Style.Colors.boxHover
            }else{
                return "#00ffffff"
            }

        }

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
        y: comboBoxId.height - 4
        width: comboBoxId.width
        implicitHeight: Math.min(contentItem.implicitHeight + 20, 260)

        background: null
        contentItem: Rectangle {
            implicitWidth: myListView.contentWidth
            implicitHeight: myListView.contentHeight
            color: Style.Colors.background
            border.width: 1; border.color: Style.Colors.boxBorder
            radius: 10
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
    }
    indicator: Image {}
    background: Rectangle {
        color: Style.Colors.background
        border.width: 1; border.color: Style.Colors.boxBorder
        radius: 10
    }
    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
}
