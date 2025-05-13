import QtQuick 2.15
import QtQuick.Controls 2.15
import "./components"
import '../../../component_library/style' as Style

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
                width: parent.width ; height: modelInferencesMenu.height + (modelInferencesBody.visible?(modelInferencesBody.height+10):0) + 20
                border.width: 1; border.color: Style.Colors.boxBorder
                color: Style.Colors.background
                radius: 8
                Column{
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10
                    ModelMenuSettingsDeveloper{
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
                    ModelInferencesSettingsDeveloper{
                        id: modelInferencesBody
                    }
                }
            }

            Rectangle{
                width: parent.width ; height: modelInformationMenu.height + (modelInformationBody.visible?(modelInformationBody.height+10):0) + 20
                border.width: 1; border.color: Style.Colors.boxBorder
                color: Style.Colors.background
                radius: 8
                Column{
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10
                    ModelMenuSettingsDeveloper{
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
                    ModelInformationSettingsDeveloper{
                        id: modelInformationBody
                    }
                }
            }

            Rectangle{
                width: parent.width ; height: modelEnginMenu.height + (modelEnginBody.visible?(modelEnginBody.height+10):0) +  20
                border.width: 1; border.color: Style.Colors.boxBorder
                color: Style.Colors.background
                radius: 8
                Column{
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10
                    ModelMenuSettingsDeveloper{
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
                    ModelEngineSettingsDeveloper{
                        id: modelEnginBody
                    }
                }
            }

            Rectangle{
                width: parent.width  ; height: assistantMenu.height + (assistantBody.visible?(assistantBody.height+10):0) + 20
                border.width: 1; border.color: Style.Colors.boxBorder
                color: Style.Colors.background
                radius: 8
                Column{
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10
                    ModelMenuSettingsDeveloper{
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
                    ModelAssistantSettingsDeveloper{
                        id: assistantBody
                    }
                }
            }
        }
    }
}
