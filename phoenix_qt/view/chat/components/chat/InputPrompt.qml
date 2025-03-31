import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import '../../../component_library/style' as Style
import '../../../component_library/button'

Rectangle{
    id: controlId
    height: 60; width: Math.min(670, parent.width - 48)
    anchors.horizontalCenter: parent.horizontalCenter
    color: Style.Colors.boxNormalGradient0
    border.width: 1
    border.color: Style.Colors.boxBorder
    radius: 8

    signal sendPrompt(var prompt)

    function selectIcon(){
        if(conversationList.currentConversation.responseInProgress){
            if(iconId.hovered)
                return "qrc:/media/icon/stopFill.svg"
            else
                return "qrc:/media/icon/stop.svg"
        }else{
            if(iconId.hovered)
                return "qrc:/media/icon/sendFill.svg"
            else
                return "qrc:/media/icon/send.svg"
        }
    }

    Row{
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        ScrollView {
            id: scrollInput
            width: parent.width - iconId.width -10
            height: parent.height

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
                onHeightChanged: {
                    if(inputTextBox.height >controlId.height - 20 && inputTextBox.text !== ""){
                        controlId.height  = Math.min(inputTextBox.height + 20 , 180) ;
                    }if(inputTextBox.text === ""){
                        controlId.height = 60
                    }
                }

                Keys.onReturnPressed: (event)=> {
                  if (event.modifiers & Qt.ControlModifier || event.modifiers & Qt.ShiftModifier){
                    event.accepted = false;
                  }else {
                        sendPrompt(inputTextBox.text)
                        if(conversationList.modelSelect)
                              inputTextBox.text = ""
                  }
                }

                onEditingFinished: {
                    controlId.layer.enabled= false
                }
                onPressed: {
                    controlId.layer.enabled= true
                }
                onTextChanged: {
                    controlId.layer.enabled= true
                }
            }
        }
        MyIcon {
            id: iconId
            anchors.bottom: parent.bottom
            myIcon: selectIcon()
            iconType: Style.RoleEnum.IconType.Primary
            onClicked: {
                if(conversationList.currentConversation.responseInProgress){
                    conversationList.currentConversation.stop()
                }else{
                    sendPrompt(inputTextBox.text)
                    if(conversationList.modelSelect)
                          inputTextBox.text = ""
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
