import QtQuick 2.15
import QtQuick.Controls 2.15
import "./components"

Item {
    height: parent.height - headerId.height
    width: parent.width
    ScrollView{
        id: scrollViewSettingsId
        anchors.fill: parent

        Column{
            anchors.fill: parent
            spacing: 5

            ModelMenuSettings{
                id: modelInferencesMenu
                myText: qsTr("Inference Settings")
                isOpen: modelInferencesBody.visible
                Connections {
                    target: modelInferencesMenu
                    function onOpen(){
                        modelInferencesBody.visible = !modelInferencesBody.visible
                    }
                }
            }
            ModelInferencesSettings{
                id: modelInferencesBody
            }

            ModelMenuSettings{
                id: modelInformationMenu
                myText: qsTr("Model Settings")
                isOpen: modelInformationBody.visible
                Connections {
                    target: modelInformationMenu
                    function onOpen(){
                        modelInformationBody.visible = !modelInformationBody.visible
                    }
                }
            }
            ModelInformationSettings{
                id: modelInformationBody
            }

            ModelMenuSettings{
                id: modelEnginMenu
                myText: qsTr("Engine Settings")
                isOpen: modelEnginBody.visible
                Connections {
                    target: modelEnginMenu
                    function onOpen(){
                        modelEnginBody.visible = !modelEnginBody.visible
                    }
                }
            }
            ModelEngineSettings{
                id: modelEnginBody
            }
            ModelMenuSettings{
                id: assistantMenu
                myText: qsTr("Assistant Settings")
                isOpen: assistantBody.visible
                Connections {
                    target: assistantMenu
                    function onOpen(){
                        assistantBody.visible = !assistantBody.visible
                    }
                }
            }
            ModelAssistantSettings{
                id: assistantBody
            }
        }
    }
}
