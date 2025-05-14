import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

Item {

    Rectangle {
        id: instructionsBox
        anchors.fill: parent
        anchors.margins: 10
        color: Style.Colors.boxHover
        radius: 12
        ScrollView {
            id: scrollInstruction
            anchors.fill:parent; anchors.margins: 10
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            TextArea {
                id: instructionTextBox
                text: " # Create a model
    curl -X POST http://localhost:8080/api/models \
      -H \"Content-Type: application/json\" \
      -d '{\"name\":\"Whisper\", \"version\":\"1.5\"}'

    # List all models
    curl http://localhost:8080/api/models

    # Get model by ID
    curl http://localhost:8080/api/models/1

    # Update model
    curl -X PUT http://localhost:8080/api/models/1 \
      -H \"Content-Type: application/json\" \
      -d '{\"name\":\"Whisper\", \"version\":\"2.0\"}'

    # Delete model
    curl -X DELETE http://localhost:8080/api/models/1
    "
                visible: true
                color: Style.Colors.textInformation
                wrapMode: Text.Wrap
                placeholderText: qsTr("Eg. You are a helpful assistant")
                clip: true
                font.pointSize: 10
                hoverEnabled: true
                tabStopDistance: 80
                selectionColor: "white"
                persistentSelection: true
                placeholderTextColor: Style.Colors.textInformation
                background: null
                textFormat: TextEdit.PlainText
                onHeightChanged: {
                    if(instructionTextBox.height + 10>80 && instructionTextBox.text !== ""){
                        instructionsBox.height  = Math.min(instructionTextBox.height + 10,control.height - 10) ;
                    }
                }
                onTextChanged: {
                    if(control.existConversation){
                        conversationList.currentConversation.modelSettings.systemPrompt = instructionTextBox.text.replace(/\\n/g, "\n");
                    }
                }
            }
        }
    }
}
