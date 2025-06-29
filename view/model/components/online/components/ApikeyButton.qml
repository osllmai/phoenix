import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import '../../../../component_library/style' as Style
import "../../../../component_library/button"

Item {
    id: control
    property bool isFillWidthDownloadButton: true

    height: 35
    width: control.isFillWidthDownloadButton? parent.width: Math.max(inputApikey.width, installRowId.width)

    InputApikey{
        id: inputApikeyFill
        visible: isFillWidthDownloadButton && !model.installModel
        Connections{
            target: inputApikeyFill
            function onSaveAPIKey(apiKey){
                onlineModelList.saveAPIKey(model.id, apiKey)
            }
        }
    }

    InputApikey{
        id: inputApikey
        width: 200
        visible: !isFillWidthDownloadButton && !model.installModel
        Connections{
            target: inputApikey
            function onSaveAPIKey(apiKey){
                onlineModelList.saveAPIKey(model.id, apiKey)
            }
        }
    }

    Row{
        id: installRowId
        spacing: 5
        visible: model.installModel
        anchors.right: parent.right
        MyButton{
            id: deleteButton
            myText: "Delete"
            bottonType: Style.RoleEnum.BottonType.Danger
            onClicked:{
                deleteApikeylVerificationId.open()
            }
        }
        MyButton{
            id: rejectButton
            visible: model.id === conversationList.modelId? true: false
            width: 60
            myText: "Eject"
            bottonType: Style.RoleEnum.BottonType.Secondary
            onClicked:{
                if(model.type === "Text Generation"){

                    conversationList.setModelRequest(-1, "", "", "", "")

                }else if(model.type === "Speech"){

                    speechToText.modelPath = ""
                    speechToText.modelSelect = false

                }else{
                    console.log(model.type)
                }
            }
        }
        MyButton{
            id: startChatFillButton
            visible: isFillWidthDownloadButton
            width: control.width - deleteButton.width - (rejectButton.visible? (rejectButton.width +5): 0) - 5
            myText: model.type === "Text Generation"? ("Start Chat"): ("Set Model")
            bottonType: Style.RoleEnum.BottonType.Primary
            onClicked:{
                if(model.type === "Text Generation"){

                        conversationList.setModelRequest(model.id, model.name, "qrc:/media/image_company/" + model.icon , model.promptTemplate, model.systemPrompt)
                        conversationList.isEmptyConversation = true
                        appBodyId.currentIndex = 1

                }else if(model.type === "Speech"){

                        speechToText.modelPath = model.key
                        speechToText.modelSelect = true

                }else{
                    console.log(model.type)
                }
            }
        }
        MyButton{
            id: startChatButton
            visible: !isFillWidthDownloadButton
            myText: model.type === "Text Generation"? ("Start Chat"): ("Set Model")
            bottonType: Style.RoleEnum.BottonType.Primary
            onClicked:{
                if(model.type === "Text Generation"){

                        conversationList.setModelRequest(model.id, model.name, "qrc:/media/image_company/" + model.icon , model.promptTemplate, model.systemPrompt)
                        conversationList.isEmptyConversation = true
                        appBodyId.currentIndex = 1

                }else if(model.type === "Speech"){

                        speechToText.modelPath = model.key
                        speechToText.modelSelect = true

                }else{
                    console.log(model.type)
                }
            }
        }
    }

    VerificationDialog{
        id: deleteApikeylVerificationId
        titleText: "Delete"
        about:"Do you really want to delete these Api Key?"
        textBotton1: "Cancel"
        textBotton2: "Delete"
        Connections{
            target:deleteApikeylVerificationId
            function onButtonAction1(){
                deleteApikeylVerificationId.close()
            }
            function onButtonAction2() {
                if((model.type === "Speech") && (speechToText.modelPath === model.key)){
                    speechToText.modelPath = ""
                    speechToText.modelSelect = false
                }
                onlineModelList.deleteRequest(model.id)
                deleteApikeylVerificationId.close()
            }
        }
    }
}
