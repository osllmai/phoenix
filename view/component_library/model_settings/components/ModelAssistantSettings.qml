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
             id: scrollInput
             width: parent.width
             height: parent.height
             ScrollBar.vertical.interactive: true

             ScrollBar.vertical.policy: scrollInput.contentHeight > scrollInput.height
                                        ? ScrollBar.AlwaysOn
                                        : ScrollBar.AlwaysOff

             ScrollBar.vertical.active: (scrollInput.contentY > 0) &&
                             (scrollInput.contentY < scrollInput.contentHeight - scrollInput.height)

             ScrollBar.horizontal.interactive: true

             ScrollBar.horizontal.policy: scrollInput.contentWidth > scrollInput.width
                                        ? ScrollBar.AlwaysOn
                                        : ScrollBar.AlwaysOff

             ScrollBar.horizontal.active: (scrollInput.contentX > 0) &&
                             (scrollInput.contentX < scrollInput.contentWidth - scrollInput.width)

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
                 persistentSelection: true
                 selectionColor: Style.Colors.textSelection
                 placeholderTextColor: instructionTextBox.text ===""? Style.Colors.menuNormalIcon: Style.Colors.textPlaceholder
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
