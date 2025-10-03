import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import '../../../../../component_library/style' as Style
import "../../../../../component_library/button"

Item {
    id: control
    property bool isFillWidthDownloadButton: true

    property string modelId: ""
    property string modelName: ""
    // property string modelType: ""
    property string modelIcon: ""
    // property string modelPromptTemplate: ""
    property string modelSystemPrompt: ""
    property string modelKey: ""
    property bool installModel: false

    height: 35
    width: control.isFillWidthDownloadButton ? parent.width : 200

    // InputApikey (Fill Width)
    Loader {
        id: inputApikeyFillLoader
        active: isFillWidthDownloadButton && !installModel
        sourceComponent: InputApikey {
            id: inputApikeyFill
            width: control.width
            Connections {
                target: inputApikeyFill
                function onSaveAPIKey(apiKey) {
                    onlineCompanyList.saveAPIKey(modelId, apiKey)
                }
            }
        }
    }

    // InputApikey (Fixed Width)
    Loader {
        id: inputApikeyLoader
        active: !isFillWidthDownloadButton && !installModel
        sourceComponent: InputApikey {
            id: inputApikey
            width: control.width
            Connections {
                target: inputApikey
                function onSaveAPIKey(apiKey) {
                    onlineCompanyList.saveAPIKey(modelId, apiKey)
                }
            }
        }
    }

    // Row for Installed Model
    Loader {
        id: installRowLoader
        active: installModel
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
                active: modelId === conversationList.modelId
                visible: modelId === conversationList.modelId
                sourceComponent: MyButton {
                    id: rejectButton
                    myText: "Eject"
                    bottonType: Style.RoleEnum.BottonType.Secondary
                    onClicked: {
                        conversationList.setModelRequest(-1, "", "", "", "")
                    }
                }
            }

            MyButton {
                id: startChatButton
                myText: /*modelType === "Text Generation" ? */"Start Chat"/* : "Set Model"*/
                bottonType: Style.RoleEnum.BottonType.Primary
                onClicked: {
                    conversationList.setModelRequest(modelId,
                                                     modelName,
                                                     modelIcon,
                                                     modelPromptTemplate,
                                                     modelSystemPrompt)
                    appBodyId.currentIndex = 1
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
                    // if ((modelType === "Speech") && (speechToText.modelPath === modelKey)) {
                    //     speechToText.modelPath = ""
                    //     speechToText.modelSelect = false
                    // }
                    onlineCompanyList.deleteRequest(modelId)
                    deleteApikeylVerificationId.close()
                }
            }
        }
    }
}
