import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import '../../../../../component_library/style' as Style
import "../../../../../component_library/button"

Item {
    id: control
    clip: true

    height: 35
    width: 200

    property int modelId: model.id || ""
    property string modelName: model.name || ""
    property string modelKey: model.key || ""
    property string modelType: model.type || ""
    property string modelIcon: model.icon || ""
    property string modelPromptTemplate: model.promptTemplate || ""
    property string modelSystemPrompt: model.systemPrompt || ""
    property bool modelIsDownloading: model.isDownloading || false
    property bool modelDownloadFinished: model.downloadFinished || false
    property double modelDownloadPercent: model.downloadPercent || 0

    property bool needAddModel: false

    Loader {
        id: modelButtonLoader
        anchors.right: parent.right
        sourceComponent: getSourceComponent()
    }

    function getSourceComponent() {
        if (!modelDownloadFinished && !modelIsDownloading) {
            return downloadComponent
        } else if (modelIsDownloading) {
            return downloadProgressComponent
        } else if (modelDownloadFinished) {
            return modelFinishedComponent
        }
        return null
    }

    Component {
        id: downloadComponent
        MyButton {
            myText: "Download"
            bottonType: Style.RoleEnum.BottonType.Primary
            onClicked: {
                folderDialogLoader.active = true
                folderDialogLoader.item.open()
            }
        }
    }

    Component {
        id: downloadProgressComponent
        MyButton {
            width: 100
            progressBarValue: modelDownloadPercent
            bottonType: Style.RoleEnum.BottonType.Progress
            onClicked: offlineModelList.cancelRequest(modelId)
        }
    }

    Component {
        id: modelFinishedComponent
        Row {
            spacing: 5
            width: deleteButton.width +
                   (rejectLoader.status === Loader.Ready ? rejectLoader.width + 5 : 0) +
                   startChatBox.width + 5
            MyButton {
                id: deleteButton
                myText: "Delete"
                bottonType: Style.RoleEnum.BottonType.Danger
                onClicked: {
                    deleteDialogLoader.active = true
                    deleteDialogLoader.item.open()
                }
            }
            Loader {
                id: rejectLoader
                active: (modelType === "Text Generation" && modelId === conversationList.modelId) ||
                        (modelType === "Speech" && speechToText.modelSelect && speechToText.modelPath === modelKey)
                visible: (modelType === "Text Generation" && modelId === conversationList.modelId) ||
                         (modelType === "Speech" && speechToText.modelSelect && speechToText.modelPath === modelKey)

                sourceComponent: MyButton {
                    id: rejectButton
                    myText: "Eject"
                    bottonType: Style.RoleEnum.BottonType.Secondary
                    onClicked: {
                        if (modelType === "Text Generation") {
                            conversationList.setModelRequest(-1, "", "", "", "")
                        } else if (modelType === "Speech") {
                            speechToText.modelPath = ""
                            speechToText.modelSelect = false
                        }
                    }
                }
            }
            MyButton {
                id: startChatBox
                myText: modelType === "Text Generation" ? "Start Chat" :
                        ((modelType === "Speech" && speechToText.modelSelect && speechToText.modelPath === modelKey) ? "Go to Chat" : "Set Model")
                bottonType: Style.RoleEnum.BottonType.Primary
                onClicked: {
                    if (modelType === "Text Generation") {
                        conversationList.setModelRequest(modelId, modelName, "qrc:/media/image_company/" + modelIcon, modelPromptTemplate, modelSystemPrompt)
                        conversationList.isEmptyConversation = true
                        appBodyId.currentIndex = 1
                    } else if (modelType === "Speech") {
                        if (speechToText.modelSelect && speechToText.modelPath === modelKey) {
                            appBodyId.currentIndex = 1
                        } else {
                            speechToText.modelPath = modelKey
                            console.log(modelKey)
                            speechToText.modelSelect = true
                        }
                    }
                }
            }
        }
    }

    Loader {
        id: deleteDialogLoader
        active: false
        sourceComponent: VerificationDialog {
            id: deleteModelVerificationId
            titleText: "Delete"
            about: "Do you really want to delete this Model?"
            textBotton1: "Cancel"
            textBotton2: "Delete"
            Connections {
                target: deleteModelVerificationId
                function onButtonAction1() { deleteModelVerificationId.close() }
                function onButtonAction2() {
                    if (modelType === "Speech" && speechToText.modelPath === modelKey) {
                        speechToText.modelPath = ""
                        speechToText.modelSelect = false
                    }
                    offlineModelList.deleteRequest(modelId)
                    deleteModelVerificationId.close()
                }
            }
        }
    }

    Loader {
        id: folderDialogLoader
        active: false
        sourceComponent: FolderDialog {
            id: folderDialogId
            title: "Choose Folder"
            currentFolder: window.lastFolder
            onAccepted: {
                if (folderDialogId.currentFolder.toString().startsWith("file:///C:/")) {
                    errorLoader.active = true
                    errorLoader.item.open()
                    return
                }

                window.lastFolder = folderDialogId.currentFolder

                if(needAddModel){
                    huggingfaceModelList.addModel(
                        huggingfaceModelList.hugginfaceInfo.id,
                        modelData.rfilename,
                        huggingfaceModelList.hugginfaceInfo.pipeline_tag,
                        huggingfaceModelList.hugginfaceInfo.icon,
                        currentFolder
                    )
                }else{
                    offlineModelList.downloadRequest(control.modelId, currentFolder)
                }
            }
            onRejected: console.log("Rejected")
        }
    }
    Loader {
        id: errorLoader
        active: false
        sourceComponent: VerificationDialog {
            id: driveC
            titleText: "Invalid Location"
            about: "You cannot store models on drive C. Please select another drive to save your downloaded models."
            textBotton1: "OK"
            typeBotton1: Style.RoleEnum.BottonType.Primary
            Connections {
                target: driveC
                function onButtonAction1() { driveC.close() }
            }
        }
    }
}
