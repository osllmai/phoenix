import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

Item {
    Rectangle {
        id: instructionsBox
        anchors.fill: parent
        anchors.margins: 10
        radius: 12
        color: Style.Colors.boxHover
        border.color: "#444"
        border.width: 1

        ScrollView {
            id: scrollInstruction
            anchors.fill: parent
            anchors.margins: 10
            clip: true

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn
                width: 6
                contentItem: Rectangle {
                    implicitWidth: 6
                    radius: 3
                    color: "#888"
                }
                background: Rectangle {
                    color: "#2e2e2e"
                }
            }

            TextArea {
                id: instructionTextBox
                text: "curl http://localhost:1234/v1/chat/completions \
  -H \"Content-Type: application/json\" \
  -d '{
    \"model\": \"deepseek-r1-distill-qwen-7b\",
    \"messages\": [
      { \"role\": \"system\", \"content\": \"Always answer in rhymes. Today is Thursday\" },
      { \"role\": \"user\", \"content\": \"What day is it today?\" }
    ],
    \"temperature\": 0.7,
    \"max_tokens\": -1,
    \"stream\": false
}'
    "
                readOnly: true
                wrapMode: Text.WrapAnywhere
                color: "#e0e0e0"
                font.family: "Courier New"
                font.pointSize: 10
                background: Rectangle {
                    color: "#1e1e1e"
                    radius: 8
                    border.color: "#444"
                }
                padding: 10
                cursorVisible: false
                persistentSelection: false

                onTextChanged: {
                    // Scroll to bottom when new log appears
                    instructionTextBox.cursorPosition = instructionTextBox.length
                }
            }
        }
    }
}
