import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import '../../../../component_library/style' as Style
import "../../../../component_library/button"
import "./components"

ComboBox {
    id: comboBoxId
    height: 35
    width: 200
    font.pixelSize: 12

    Accessible.role: Accessible.ComboBox

    signal search(var text)

    contentItem: Rectangle{
        id: control
        width: control.width; height: 32
        color: Style.Colors.menuHoverBackground
        border.width: 0
        border.color: Style.Colors.boxBorder
        radius: 8
        clip: true
        property bool isTextAreaVisible: true

        Row{
            anchors.fill: parent
            ToolButton {
                id: searchIcon
                anchors.verticalCenter: parent.verticalCenter
                background: null
                icon{
                    source: "qrc:/media/icon/search.svg"
                    color: Style.Colors.menuNormalIcon
                    width:18; height:18
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:{textArea.pressed}
                }
            }
            TextArea {
                id: textArea
                width: parent.width - searchIcon.width
                visible: control.isTextAreaVisible
                anchors.verticalCenter: searchIcon.verticalCenter
                hoverEnabled: true
                cursorVisible: false
                persistentSelection: true
                placeholderText: qsTr("Search")
                selectionColor: Style.Colors.textSelection
                placeholderTextColor: textArea.text ===""? Style.Colors.menuNormalIcon: Style.Colors.textPlaceholder
                color: Style.Colors.menuNormalIcon
                font.pointSize: 10
                wrapMode: TextEdit.NoWrap
                background: null
                onTextChanged: comboBoxId.search(textArea.text)
                Keys.onReturnPressed: (event)=> {
                  if (event.modifiers & Qt.ControlModifier || event.modifiers & Qt.ShiftModifier){
                    event.accepted = false;
                  }else {
                        comboBoxId.search(textArea.text)
                  }
                }
                onEditingFinished: {
                    control.border.width = 0
                    comboBoxId.popup.close()
                }
                onPressed: {
                    control.border.width = 1
                    comboBoxId.popup.open()
                }
            }
        }
    }

    popup: Item{
        width: parent.width
        height: 40
    }

    indicator: Image {}
    background: null
    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
}
