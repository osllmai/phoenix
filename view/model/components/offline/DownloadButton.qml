import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import '../../../component_library/style' as Style
import "../../../component_library/button"

Item {
    id: control
    height: 35
    width: parent.width

    MyButton{
        id: dounloadButton
        anchors.right: parent.right
        anchors.left: parent.left
        visible: !model.downloadFinished && !model.isDownloading
        myText: "Download"
        bottonType: Style.RoleEnum.BottonType.Primary
        onClicked:{
            folderDialogId.open()
        }
    }

    MyButton{
        id: downloadPercentButton
        visible: model.isDownloading
        progressBarValue: model.downloadPercent
        bottonType: Style.RoleEnum.BottonType.Progress
        onClicked:{
            offlineModelList.cancelRequest(model.id)
        }
    }

    Row{
        spacing: 5
        visible: model.downloadFinished
        anchors.right: parent.right
        MyButton{
            id: deleteButton
            myText: "Delete"
            bottonType: Style.RoleEnum.BottonType.Danger
            onClicked:{
                deleteModelVerificationId.open()
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
        id: deleteModelVerificationId
        titleText: "Delete"
        about:"Do you really want to delete these Model?"
        textBotton1: "Cancel"
        textBotton2: "Delete"
        Connections{
            target:deleteModelVerificationId
            function onButtonAction1(){
                deleteModelVerificationId.close()
            }
            function onButtonAction2() {
                offlineModelList.deleteRequest(model.id)
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
                deleteModelVerificationId.close()
            }
        }
    }

    FolderDialog {
        id: folderDialogId
        title: "Choose Folder"

        onAccepted: {
            offlineModelList.downloadRequest(model.id, currentFolder)
            console.log(currentFolder)
        }
        onRejected: {
            console.log("Rejected");
        }
    }
}
