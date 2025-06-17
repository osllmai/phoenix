import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import './../../style' as Style
import "./button"

Item {
    id: control
    width: parent.width
    height: runId.height + portChange.height +10
    visible: false

    Column{
        id: inferenceSettingsInformationId
        anchors.left: parent.left
        anchors.right: parent.right; anchors.rightMargin: 16
        spacing: 5

        ModelSettingsSwitch{
            id:runId
            myTextName: "Run"
            myValue: modelSettingsId.isRunningSocket
            onMyValueChanged: {
                modelSettingsId.updateIsRunningSocket(runId.myValue)
            }
        }

        ModelTextEdit{
            id: portChange
            myText: modelSettingsId.socket
            myValue: modelSettingsId.portSocket
            Connections{
                target: portChange
                function onSendValue(value){
                    modelSettingsId.updatePortSocket(value)
                }
            }
        }

        // ModelTextCopyBox{
        //     id: chatSocketId
        //     myText: "ws://127.0.0.1:"+ codeDeveloperList.portSocket
        // }
    }
}
