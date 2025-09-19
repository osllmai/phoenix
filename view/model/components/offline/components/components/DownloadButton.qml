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

    Loader {
        id: modelButtonLoader
        anchors.right: parent.right
        sourceComponent: getSourceComponent()
    }

    function getSourceComponent() {
        if(!model.downloadFinished && !model.isDownloading) {
            return downloadComponent
        } else if(model.isDownloading) {
            return downloadProgressComponent
        } else if(model.downloadFinished) {
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
            progressBarValue: model.downloadPercent
            bottonType: Style.RoleEnum.BottonType.Progress
            onClicked: offlineModelList.cancelRequest(model.id)
        }
    }

    Component {
        id: modelFinishedComponent
        Row {
            spacing: 5
            width: deleteButton.width +
                   (rejectLoader.status === Loader.Ready?rejectLoader.width + 5: 0) +
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
                active: (model.type === "Text Generation" && model.id === conversationList.modelId) ||
                        (model.type === "Speech" && speechToText.modelPath === model.key)
                visible: (model.type === "Text Generation" && model.id === conversationList.modelId) ||
                         (model.type === "Speech" && speechToText.modelPath === model.key)

                sourceComponent: MyButton {
                    id: rejectButton
                    myText: "Eject"
                    bottonType: Style.RoleEnum.BottonType.Secondary
                    onClicked: {
                        if(model.type === "Text Generation") {
                            conversationList.setModelRequest(-1, "", "", "", "")
                        } else if(model.type === "Speech") {
                            speechToText.modelPath = ""
                            speechToText.modelSelect = false
                        }
                    }
                }
            }
            MyButton {
                id: startChatBox
                myText: model.type === "Text Generation" ? "Start Chat" :
                        ((model.type === "Speech" && speechToText.modelPath === model.key) ? "Go to Chat" : "Set Model")
                bottonType: Style.RoleEnum.BottonType.Primary
                onClicked: {
                    if(model.type === "Text Generation") {
                        conversationList.setModelRequest(model.id, model.name, "qrc:/media/image_company/" + model.icon, model.promptTemplate, model.systemPrompt)
                        conversationList.isEmptyConversation = true
                        appBodyId.currentIndex = 1
                    } else if(model.type === "Speech") {
                        if(speechToText.modelPath === model.key) {
                            appBodyId.currentIndex = 1
                        } else {
                            speechToText.modelPath = model.key
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
                    if (model.type === "Speech" && speechToText.modelPath === model.key) {
                        speechToText.modelPath = ""
                        speechToText.modelSelect = false
                    }
                    offlineModelList.deleteRequest(model.id)
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
            onAccepted: offlineModelList.downloadRequest(model.id, currentFolder)
            onRejected: console.log("Rejected")
        }
    }
}
