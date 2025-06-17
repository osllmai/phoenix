import QtQuick 2.15
import QtQuick.Controls 2.15
import "./components"
import "./components/button"
import '../style' as Style

Item {
    height: parent.height - headerId.height
    width: parent.width
    Flickable {
        anchors.fill: parent
        clip: true
        contentHeight: columnId.implicitHeight

        interactive: true
        boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
        Column{
            id: columnId
            anchors.fill: parent
            spacing: 10

            Rectangle{
                visible: modelSettingsId.apiPage
                width: parent.width ; height: apiSettingsMenu.height + (apiSettingsBody.visible?(apiSettingsBody.height+10):0) + 20
                border.width: apiSettingsBody.visible? 1: 0; border.color: Style.Colors.boxBorder
                color: Style.Colors.background
                radius: 8
                Column{
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10
                    ModelMenuSettings{
                        id: apiSettingsMenu
                        myText: qsTr("API Settings")
                        isOpen: apiSettingsBody.visible
                        Connections {
                            target: apiSettingsMenu
                            function onClicked(){
                                apiSettingsBody.visible = !apiSettingsBody.visible
                            }
                        }
                    }
                    APISettings{
                        id: apiSettingsBody
                        visible: true
                    }
                }
            }

            Rectangle{
                visible: modelSettingsId.socketPage
                width: parent.width ; height: socketSettingsMenu.height + (socketSettingsBody.visible?(socketSettingsBody.height+10):0) + 20
                border.width: socketSettingsBody.visible? 1: 0; border.color: Style.Colors.boxBorder
                color: Style.Colors.background
                radius: 8
                Column{
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10
                    ModelMenuSettings{
                        id: socketSettingsMenu
                        myText: qsTr("Socket Settings")
                        isOpen: socketSettingsBody.visible
                        Connections {
                            target: socketSettingsMenu
                            function onClicked(){
                                socketSettingsBody.visible = !socketSettingsBody.visible
                            }
                        }
                    }
                    SocketSettings{
                        id: socketSettingsBody
                        visible: true
                    }
                }
            }

            Rectangle{
                width: parent.width ; height: modelInferencesMenu.height + (modelInferencesBody.visible?(modelInferencesBody.height+10):0) + 20
                border.width: modelInferencesBody.visible? 1: 0; border.color: Style.Colors.boxBorder
                color: Style.Colors.background
                radius: 8
                Column{
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10
                    ModelMenuSettings{
                        id: modelInferencesMenu
                        myText: qsTr("Inference Settings")
                        isOpen: modelInferencesBody.visible
                        Connections {
                            target: modelInferencesMenu
                            function onClicked(){
                                modelInferencesBody.visible = !modelInferencesBody.visible
                            }
                        }
                    }
                    ModelInferencesSettings{
                        id: modelInferencesBody
                    }
                }
            }

            Rectangle{
                width: parent.width ; height: modelInformationMenu.height + (modelInformationBody.visible?(modelInformationBody.height+10):0) + 20
                border.width: modelInformationBody.visible? 1: 0; border.color: Style.Colors.boxBorder
                color: Style.Colors.background
                radius: 8
                Column{
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10
                    ModelMenuSettings{
                        id: modelInformationMenu
                        myText: qsTr("Model Settings")
                        isOpen: modelInformationBody.visible
                        Connections {
                            target: modelInformationMenu
                            function onClicked(){
                                modelInformationBody.visible = !modelInformationBody.visible
                            }
                        }
                    }
                    ModelInformationSettings{
                        id: modelInformationBody
                    }
                }
            }

            Rectangle{
                width: parent.width ; height: modelEnginMenu.height + (modelEnginBody.visible?(modelEnginBody.height+10):0) +  20
                border.width: modelEnginBody.visible? 1: 0; border.color: Style.Colors.boxBorder
                color: Style.Colors.background
                radius: 8
                Column{
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10
                    ModelMenuSettings{
                        id: modelEnginMenu
                        myText: qsTr("Engine Settings")
                        isOpen: modelEnginBody.visible
                        Connections {
                            target: modelEnginMenu
                            function onClicked(){
                                modelEnginBody.visible = !modelEnginBody.visible
                            }
                        }
                    }
                    ModelEngineSettings{
                        id: modelEnginBody
                    }
                }
            }

            Rectangle{
                width: parent.width  ; height: assistantMenu.height + (assistantBody.visible?(assistantBody.height+10):0) + 20
                border.width: assistantBody.visible? 1: 0; border.color: Style.Colors.boxBorder
                color: Style.Colors.background
                radius: 8
                Column{
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10
                    ModelMenuSettings{
                        id: assistantMenu
                        myText: qsTr("Assistant Settings")
                        isOpen: assistantBody.visible
                        Connections {
                            target: assistantMenu
                            function onClicked(){
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
    }
}
