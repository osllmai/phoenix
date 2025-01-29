import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style

Rectangle{
    id: controlId
    height: 100; width: parent.width
    color: Style.Colors.boxHoverGradient1
    radius: 8
    Row{
        anchors.fill: parent
        anchors.margins: 24
        spacing: 10
        ScrollView {
            id: scrollInput
            width: parent.width - iconId.width -10

            TextArea {
                id: inputTextBox
                color: Style.Colors.textInformation

                wrapMode: Text.Wrap
                placeholderText: qsTr("What is in your mind ?")

                Accessible.role: Accessible.EditableText
                Accessible.name: placeholderText
                Accessible.description: qsTr("Send prompts to the model")

                clip: false
                font.pointSize: 12
                hoverEnabled: true
                tabStopDistance: 80
                selectionColor: Style.Colors.background
                cursorVisible: false
                persistentSelection: true
                placeholderTextColor: Style.Colors.textInformation
                onHeightChanged: {
                    if(inputTextBox.height >controlId-48 && inputTextBox.text !== ""){
                        controlId.height  = Math.min(controlId.height + 10 , 180) ;
                    }if(inputTextBox.text === ""){
                        controlId.height = 100
                    }
                }

                Keys.onReturnPressed: (event)=> {
                  if (event.modifiers & Qt.ControlModifier || event.modifiers & Qt.ShiftModifier)
                    event.accepted = false;
                  else {
                        // sendIcon.actionClicked()
                  }
                }

                background: Rectangle{
                    color: "#00ffffff"
                }
            }
        }
        ToolButton {
            id: iconId
            // anchors.verticalCenter: parent.verticalCenter
            background: Rectangle {
                color: "#00ffffff"
            }
            icon{
                source: iconId.hovered? "../../../media/icon/sendFill.svg": "../../../media/icon/send.svg"
                color: Style.Colors.menuHoverAndCheckedIcon;
                width:18; height:18
            }
            onClicked: function() {}
        }
    }

}
