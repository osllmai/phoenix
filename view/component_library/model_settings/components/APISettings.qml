import QtQuick 2.15
import "./button"

Item {
    id: control
    width: parent.width
    height: runId.height + portChange.height + chatAPIId.height + modelAPIId.height +20
    visible: false

    Column{
        id: inferenceSettingsInformationId
        anchors.left: parent.left
        anchors.right: parent.right; anchors.rightMargin: 16
        spacing: 5

        ModelSettingsSwitch{
            id:runId
            myTextName: "Run"
            myValue: modelSettingsId.isRunningAPI
            onMyValueChanged: {
                modelSettingsId.updateIsRunningAPI(runId.myValue)
            }
        }

        ModelTextEdit{
            id: portChange
            myText: modelSettingsId.api
            myValue: modelSettingsId.portAPI
            needCopy: true
            Connections{
                target: portChange
                function onSendValue(value){
                    modelSettingsId.updatePortAPI(value)
                }
            }
        }

        ModelTextCopyBox{
            id: chatAPIId
            myText: modelSettingsId.chatAPI
        }

        ModelTextCopyBox{
            id: modelAPIId
            myText: modelSettingsId.modelsAPI
        }
    }
}
