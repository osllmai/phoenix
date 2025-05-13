import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

Item {
    Column {
        spacing: 2
        width: parent.width

        TextArea {
            id: textId
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
            color: Style.Colors.textTitle
            selectionColor: "blue"
            selectedTextColor: "white"
            // width: parent.width - logoModelId.width
            font.pixelSize: 14
            focus: false
            readOnly: true
            wrapMode: TextEdit.WordWrap
            textFormat: TextEdit.PlainText

            cursorVisible: (!conversationList.isEmptyConversation && conversationList.currentConversation.responseInProgress) ? conversationList.currentConversation.responseInProgress: false
            cursorPosition: text.length

            selectByMouse: true
            background: null

            Accessible.role: Accessible.Button
            Accessible.name: text
            Accessible.description: qsTr("Select the current chat or edit the chat when in edit mode")

            onLinkActivated: function(url) {
                Qt.openUrlExternally(url)
            }

            Component.onCompleted: {
                // textProcessor.textDocument = textId.textDocument
                // textProcessor.setValue(model.text)
            }
        }

        Row {
            id: dateAndIconId
            width: dateId.width + copyId.width
            height: Math.max(dateId.height, copyId.height)
            anchors.left: parent.left
            anchors.leftMargin: 10
            property bool checkCopy: false

            MyIcon {
                id: copyId
                // visible: control.hovered
                myIcon: copyId.selectIcon()
                iconType: Style.RoleEnum.IconType.Primary
                width: 26; height: 26
                Connections{
                    target: copyId
                    function onClicked(){
                        textId.selectAll()
                        textId.copy()
                        textId.deselect()
                        dateAndIconId.checkCopy= true
                        successTimer.start();
                    }
                }
                function selectIcon(){
                    if(dateAndIconId.checkCopy === false){
                        return copyId.hovered? "qrc:/media/icon/copyFill.svg": "qrc:/media/icon/copy.svg"
                    }else{
                        return copyId.hovered? "qrc:/media/icon/copySuccessFill.svg": "qrc:/media/icon/copySuccess.svg"
                    }
                }
            }
        }
    }
}
