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
            id: startChatButton
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
                if((model.type === "Speech") && (speechToText.modelPath === model.key)){
                    speechToText.modelPath = ""
                    speechToText.modelSelect = false
                }
                offlineModelList.deleteRequest(model.id)
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
