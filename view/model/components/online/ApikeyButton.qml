import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import '../../../component_library/style' as Style
import "../../../component_library/button"

Item {
    id: control
    height: 35
    width: parent.width

    InputApikey{
        id: inputApikey
        visible: !model.installModel
        Connections{
            target: inputApikey
            function onSaveAPIKey(apiKey){
                onlineModelList.saveAPIKey(model.id, apiKey)
            }
        }
    }

    Row{
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
            id: startChatButton
            width: control.width - deleteButton.width - 5
            myText: model.type === "Text Generation"? "Start Chat": "Set Model"
            bottonType: Style.RoleEnum.BottonType.Primary
            onClicked:{
                if(model.type === "Text Generation"){
                    window.modeTextlId = model.id
                    window.modelTextIcon = "qrc:/media/image_company/" + model.icon
                    window.modelTextName = model.name
                    window.modelPromptTemplate = model.promptTemplate
                    window.modelSystemPrompt = model.systemPrompt
                    window.modelTextSelect = true
                    appBodyId.currentIndex = 1
                }else if(model.type === "Speech"){
                    window.modelSpeechPath = model.key
                    window.modelSpeechSelect = true
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
                onlineModelList.deleteRequest(model.id)
                if(model.type === "Text Generation"){
                    if(window.modeTextlId === model.id){
                        window.modeTextlId = -1
                        window.modelTextIcon = ""
                        window.modelTextName = ""
                        window.modelPromptTemplate = ""
                        window.modelSystemPrompt = ""
                        window.modelTextSelect = false
                    }else if(model.type === "Speech"){
                        window.modelSpeechPath = ""
                        window.modelSpeechSelect = false
                    }
                }
                deleteApikeylVerificationId.close()
            }
        }
    }
}
