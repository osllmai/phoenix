import QtQuick 2.15
import QtQuick.Controls 2.15
import '../style' as Style

Rectangle{
    id: control
    width: (textArea.visible? 240: control.height); height: 32
    color: Style.Colors.menuHoverBackground
    radius: 8
    clip: true
    property bool isTextAreaVisible: true

    signal search(var text)
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
            placeholderTextColor: Style.Colors.menuNormalIcon
            selectionColor: Style.Colors.boxNormalGradient1
            color: Style.Colors.menuNormalIcon
            font.pointSize: 10
            wrapMode: TextEdit.NoWrap
            background: null
            onTextChanged: control.search(textArea.text)
            Keys.onReturnPressed: (event)=> {
              if (event.modifiers & Qt.ControlModifier || event.modifiers & Qt.ShiftModifier){
                event.accepted = false;
              }else {
                    control.search(textArea.text)
              }
            }
        }
    }
    // Behavior on width{NumberAnimation{duration: 200}}
}
