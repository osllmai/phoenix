import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import '../../../../../component_library/style' as Style
import "../../../../../component_library/button"

Item {
    id: control
    property bool isFillWidthDownloadButton: true

    height: 35
    width: control.isFillWidthDownloadButton ? parent.width : 200

    // InputApikey (Fill Width)
    Loader {
        id: inputApikeyFillLoader
        active: isFillWidthDownloadButton && !model.installModel
        sourceComponent: InputApikey {
            id: inputApikeyFill
            width: control.width
            Connections {
                target: inputApikeyFill
                function onSaveAPIKey(apiKey) {
                    onlineCompanyList.saveAPIKey(model.id, apiKey)
                }
            }
        }
    }

    // InputApikey (Fixed Width)
    Loader {
        id: inputApikeyLoader
        active: !isFillWidthDownloadButton && !model.installModel
        sourceComponent: InputApikey {
            id: inputApikey
            width: control.width
            Connections {
                target: inputApikey
                function onSaveAPIKey(apiKey) {
                    onlineCompanyList.saveAPIKey(model.id, apiKey)
                }
            }
        }
    }

    // Row for Installed Model
    Loader {
        id: installRowLoader
        active: model.installModel
        anchors.right: parent.right

        sourceComponent: Row {
            id: installRowId
            spacing: 5
            width: deleteButton.width +
                   (rejectButtonLoader.status === Loader.Ready?rejectButtonLoader.width + 5: 0) +
                   startChatButton.width + 5

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
                id: rejectButtonLoader
                active: model.id === conversationList.modelId
                visible: model.id === conversationList.modelId
                sourceComponent: MyButton {
                    id: rejectButton
                    myText: "Eject"
                    bottonType: Style.RoleEnum.BottonType.Secondary
                    onClicked: {
                        conversationList.setModelRequest(-1, "", "", "", "")
                        // if (model.type === "Text Generation") {
                        //     conversationList.setModelRequest(-1, "", "", "", "")
                        // } else if (model.type === "Speech") {
                        //     speechToText.modelPath = ""
                        //     speechToText.modelSelect = false
                        // } else {
                        //     console.log(model.type)
                        // }
                    }
                }
            }

            MyButton {
                id: startChatButton
                myText: model.type === "Text Generation" ? "Start Chat" : "Set Model"
                bottonType: Style.RoleEnum.BottonType.Primary
                onClicked: {
                    conversationList.setModelRequest(model.id,
                                                     model.name,
                                                     "qrc:/media/image_company/" + model.icon,
                                                     model.promptTemplate,
                                                     model.systemPrompt)
                    appBodyId.currentIndex = 1

                    // if (model.type === "Text Generation") {
                    //     conversationList.setModelRequest(
                    //         model.id, model.name, "qrc:/media/image_company/" + model.icon,
                    //         model.promptTemplate, model.systemPrompt
                    //     )
                    //     conversationList.isEmptyConversation = true
                    //     appBodyId.currentIndex = 1
                    // } else if (model.type === "Speech") {
                    //     speechToText.modelPath = model.key
                    //     speechToText.modelSelect = true
                    // } else {
                    //     console.log(model.type)
                    // }
                }
            }
        }
    }

    Loader {
        id: deleteDialogLoader
        active: false
        sourceComponent: VerificationDialog {
            id: deleteApikeylVerificationId
            titleText: "Delete"
            about: "Do you really want to delete these Api Key?"
            textBotton1: "Cancel"
            textBotton2: "Delete"
            Connections {
                target: deleteApikeylVerificationId
                function onButtonAction1() { deleteApikeylVerificationId.close() }
                function onButtonAction2() {
                    if ((model.type === "Speech") && (speechToText.modelPath === model.key)) {
                        speechToText.modelPath = ""
                        speechToText.modelSelect = false
                    }
                    onlineCompanyList.deleteRequest(model.id)
                    deleteApikeylVerificationId.close()
                }
            }
        }
    }
}
