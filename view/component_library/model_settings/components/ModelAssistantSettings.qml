import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../style' as Style

Item {
    id: control
    width: parent.width
    height: instructionsBox.height
    visible: false

     Rectangle {
         id: instructionsBox
         height: 80; width: parent.width
         color: Style.Colors.boxHover
         border.width: 0
         border.color: Style.Colors.boxBorder
         radius: 12
         ScrollView {
             id: scrollInstruction
             anchors.fill:parent; anchors.margins: 10
             ScrollBar.vertical: ScrollBar {
                 policy: ScrollBar.AsNeeded
             }

             TextArea {
                 id: instructionTextBox
                 text: modelSettingsId.systemPrompt
                 visible: true
                 color: Style.Colors.textInformation
                 wrapMode: Text.Wrap
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
                     if(instructionTextBox.height < 70 && instructionTextBox.text !== ""){
                         instructionsBox.height += 10;
                     }
                 }
                 onTextChanged: {
                     modelSettingsId.updateSystemPrompt(instructionTextBox.text.replace(/\\n/g, "\n"))
                 }
                 onEditingFinished: {
                     instructionsBox.border.width = 0
                 }
                 onPressed: {
                     instructionsBox.border.width = 1
                 }
             }
         }
     }
}
