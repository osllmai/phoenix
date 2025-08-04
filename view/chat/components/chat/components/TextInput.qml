import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style

Item {
    id: root
    property string inputValue: ""

    function setText(text){
        inputTextBox.text = text
    }

    ScrollView {
        id: scrollInput
        anchors.fill: parent
        ScrollBar.vertical.interactive: true

        ScrollBar.vertical.policy: scrollInput.contentHeight > scrollInput.height
                                   ? ScrollBar.AlwaysOn
                                   : ScrollBar.AlwaysOff

        ScrollBar.vertical.active: (scrollInput.contentY > 0) &&
                        (scrollInput.contentY < scrollInput.contentHeight - scrollInput.height)


        TextArea {
            id: inputTextBox

            color: Style.Colors.textInformation
            background: null

            wrapMode: Text.Wrap
            placeholderText: qsTr("How can I help you?")

            Accessible.role: Accessible.EditableText
            Accessible.name: placeholderText
            Accessible.description: qsTr("Send prompts to the model")

            clip: false
            font.pointSize: 10
            hoverEnabled: true
            tabStopDistance: 80
            cursorVisible: false
            persistentSelection: true
            selectionColor: Style.Colors.textSelection
            placeholderTextColor: inputTextBox.text ===""? Style.Colors.menuNormalIcon: Style.Colors.textPlaceholder

            onTextChanged: {
                root.inputValue = inputTextBox.text
                control.layer.enabled = true
                adjustHeight()
            }

            onContentHeightChanged: {
                adjustHeight()
            }

            function adjustHeight() {
                const newHeight = Math.max(40, inputTextBox.contentHeight);
                if (inputTextBox.text === "") {
                    control.height =  90 + (allFileExist.visible? allFileExist.height:0);
                } else {
                    control.height = Math.min(newHeight + 28, 180) + iconList.height + (allFileExist.visible? allFileExist.height:0);
                }
            }

            Keys.onReturnPressed: (event)=> {
                  if (event.modifiers & Qt.ControlModifier || event.modifiers & Qt.ShiftModifier){
                    event.accepted = false;
                  }else if((!conversationList.isEmptyConversation &&
                                            !conversationList.currentConversation.responseInProgress &&
                                            !conversationList.currentConversation.loadModelInProgress) ||
                                            conversationList.isEmptyConversation){
                      sendPrompt(inputTextBox.text)
                      if(conversationList.modelSelect)
                            inputTextBox.text = ""

                      if(speechToText.speechInProcess){
                          speechToText.stopRecording()
                          speechToText.text = ""
                      }
                }
            }

            onEditingFinished: {
                control.layer.enabled= false
            }
            onPressed: {
                control.layer.enabled= true
            }
        }
    }
}
