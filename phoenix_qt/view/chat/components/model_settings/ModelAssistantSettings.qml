import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style

Item {
    id: control
    width: parent.width
    height: instructionsBox.height
    visible: false

    property bool existConversation: !conversationList.isEmptyConversation

     Rectangle {
         id: instructionsBox
         height: 80; width: parent.width
         color: Style.Colors.boxHover
         radius: 12
         ScrollView {
             id: scrollInstruction
             anchors.fill:parent; anchors.margins: 10
             ScrollBar.vertical: ScrollBar {
                 policy: ScrollBar.AsNeeded
             }

             TextArea {
                 id: instructionTextBox
                 text: control.existConversation? conversationList.currentConversation.id: ""
                 visible: true
                 color: Style.Colors.textInformation
                 wrapMode: Text.WordWrap
                 placeholderText: qsTr("Eg. You are a helpful assistant")
                 clip: true
                 font.pointSize: 10
                 hoverEnabled: true
                 tabStopDistance: 80
                 selectionColor: "white"
                 persistentSelection: true
                 placeholderTextColor: Style.Colors.textInformation
                 background: null
                 onHeightChanged: {
                     if(instructionTextBox.height + 10>80 && instructionTextBox.text !== ""){
                         instructionsBox.height  = Math.min(instructionTextBox.height + 10,control.height - 10) ;
                     }
                 }
             }
         }
     }

}
