import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Phoenix
import Qt.labs.qmlmodels
import 'fields' as Fields

Page {
    id: root
    property bool isRunning: false

    component BlockItem : Pane {
        id: block

        property int blockIndex
        property WorkFlowStep step

        width: parent.width

        state: {
            if (!step.isReady)
                return "error"

            return blockIndex == runner.currentStep ? 'active' : 'normal'
        }

        background: Rectangle {
            border.color: 'gray'
            radius: 15
        }

        // BusyIndicator {
        //     anchors{
        //         right: parent.right
        //         top: parent.right

        //         topMargin: 10
        //         rightMargin: 10
        //     }
        //     visible: root.isRunning && block.blockIndex == runner.currentStep
        // }

        ColumnLayout {
            Label {
                font.pixelSize: 18
                text: block.step.name
            }

            Repeater {
                model: block.step.fields
                delegate: DelegateChooser{
                    role: 'typeAndDir'
                    DelegateChoice {
                        id: del
                        roleValue: 'String_Input'
                        delegate: Fields.StringInput {
                            isRunning: root.isRunning
                            field: modelData
                        }
                    }

                    DelegateChoice {
                        id: dels
                        property WorkFlowStepField field: modelData
                        roleValue: 'String_Output'
                        delegate: Fields.StringOutput {
                            isRunning: root.isRunning
                            field: modelData
                        }
                    }
                }
            }
        }
    }

    WorkFlowRunner {
        id: runner
    }

    ColumnLayout {
        anchors.fill: parent

        ListView {

            model: runner.steps

            spacing: 10

            Layout.fillWidth: true
            Layout.fillHeight: true

            delegate: BlockItem {
                step: modelData
                blockIndex: index
            }
        }

        ToolBar {

            Layout.preferredHeight: 60
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent

                Button {
                    enabled: runner.isReady
                    text: qsTr("Start") + " " + runner.isReady

                    onClicked: {
                        root.isRunning = true
                        runner.start()
                    }
                }

                Item { Layout.fillWidth: true }
            }
        }
    }
}
