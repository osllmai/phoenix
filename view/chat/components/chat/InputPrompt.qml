import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import '../../../component_library/style' as Style
import '../../../component_library/button'

Rectangle{
    id: controlId
    height: 90; width: Math.min(670, parent.width - 48)
    anchors.horizontalCenter: parent.horizontalCenter
    color: Style.Colors.boxNormalGradient0
    border.width: 1
    border.color: Style.Colors.boxBorder
    radius: 8

    signal sendPrompt(var prompt)

    function selectSendIcon(){
        if(!conversationList.isEmptyConversation && conversationList.currentConversation.responseInProgress){
            if(sendIconId.hovered)
                return "qrc:/media/icon/stopFill.svg"
            else
                return "qrc:/media/icon/stop.svg"
        }else{
            if(sendIconId.hovered)
                return "qrc:/media/icon/sendFill.svg"
            else
                return "qrc:/media/icon/send.svg"
        }
    }

    function selectSpeechIcon(){
        if(!conversationList.isEmptyConversation && conversationList.currentConversation.responseInProgress){
            if(speechIconId.hovered)
                return "qrc:/media/icon/microphoneOffFill.svg"
            else
                return "qrc:/media/icon/microphoneOff.svg"
        }else{
            if(speechIconId.hovered)
                return "qrc:/media/icon/microphoneOnFill.svg"
            else
                return "qrc:/media/icon/microphoneOn.svg"
        }
    }

    Column{
        anchors.fill: parent
        anchors.margins: 10
        ScrollView {
            id: scrollInput
            width: parent.width
            height: parent.height - iconList.height

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
                selectionColor: Style.Colors.boxNormalGradient1
                cursorVisible: false
                persistentSelection: true
                placeholderTextColor: Style.Colors.textInformation

                onTextChanged: {
                    controlId.layer.enabled = true
                    adjustHeight()
                }

                onContentHeightChanged: {
                    adjustHeight()
                }

                function adjustHeight() {
                    const newHeight = Math.max(40, inputTextBox.contentHeight);
                    if (inputTextBox.text === "") {
                        controlId.height = 90;
                    } else {
                        controlId.height = Math.min(newHeight + 27, 180) + iconList.height ;
                    }
                }

                Keys.onReturnPressed: (event)=> {
                      if (event.modifiers & Qt.ControlModifier || event.modifiers & Qt.ShiftModifier){
                        event.accepted = false;
                      }else {
                          if(!conversationList.isEmptyConversation && conversationList.currentConversation.responseInProgress)
                              conversationList.currentConversation.stop()
                        else{
                          sendPrompt(inputTextBox.text)
                          if(conversationList.modelSelect)
                                inputTextBox.text = ""
                        }
                    }
                }

                onEditingFinished: {
                    controlId.layer.enabled= false
                }
                onPressed: {
                    controlId.layer.enabled= true
                }
            }
        }

        Item {
            id:iconList
            width: parent.width
            height: 30

            Row {
                anchors.right: parent.right
                spacing: 10

                MyIcon {
                    id: speechIconId
                    width: 30; height: 30
                    myIcon: selectSpeechIcon()
                    iconType: Style.RoleEnum.IconType.Primary
                    onClicked: {
                        speechToText.startRecording()
                    }
                }

                MyIcon {
                    id: sendIconId
                    width: 30; height: 30
                    myIcon: selectSendIcon()
                    iconType: Style.RoleEnum.IconType.Primary
                    onClicked: {
                        if (!conversationList.isEmptyConversation && conversationList.currentConversation.responseInProgress) {
                            conversationList.currentConversation.stop()
                        } else {
                            sendPrompt(inputTextBox.text)
                            if (conversationList.modelSelect)
                                inputTextBox.text = ""
                        }
                    }
                }
            }
        }
    }

    layer.enabled: false
    layer.effect: Glow {
         samples: 40
         color:  Style.Colors.boxBorder
         spread: 0.1
         transparentBorder: true
     }
}
