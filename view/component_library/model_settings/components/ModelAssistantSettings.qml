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
         height: Math.max(80 , instructionTextBox.height); width: parent.width
         color: Style.Colors.boxHover
         border.width: 0
         border.color: Style.Colors.boxBorder
         radius: 12

         TextArea {
             id: instructionTextBox
             width: parent.width
             text: modelSettingsId.systemPrompt
             visible: true
             color: Style.Colors.textInformation
             wrapMode: Text.Wrap
             placeholderText: qsTr("Eg. You are a helpful assistant")
             clip: true
             font.pointSize: 10
             hoverEnabled: true
             tabStopDistance: 80
             persistentSelection: true
             selectionColor: Style.Colors.textSelection
             placeholderTextColor: instructionTextBox.text ===""? Style.Colors.menuNormalIcon: Style.Colors.textPlaceholder
             background: null
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
