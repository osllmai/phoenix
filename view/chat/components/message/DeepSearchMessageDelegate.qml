import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 6.6
import MyMessageTextProcessor 1.0
import '../../../component_library/style' as Style
import '../../../component_library/button'
import './components'

T.Button {
    id: control
    height: textId.height + newChatId.height + dateAndIconId.height + (allFileExist.visible? allFileExist.height: 0)  + 2
    width: Math.min(670, parent.width - 48)
    anchors.horizontalCenter: parent.horizontalCenter

    property bool generateProcess: (model.text === ""?true:false) &&
                                   !conversationList.isEmptyConversation &&
                                   (conversationList.currentConversation.loadModelInProgress || (conversationList.currentConversation.responseInProgress && model.text === "")) &&
                                   (index === listView.count - 1)

    background: null
     contentItem: Item {
         id: backgroundId
         anchors.fill: parent

         MessageTextProcessor {
             id: textProcessor
         }

         Connections {
             target: model
             function onTextChanged() {
                 textProcessor.setValue(model.text)
             }
         }

        Row {
            id: headerId
            width: parent.width

            LogoIconMessage{
                id: logoModelId
            }

            Column {
                spacing: 2
                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: 8

                FileConverteInputPrompt{
                    id: allFileExist
                    visible: (model.fileName !== "")? true: false
                    filePath: model.fileName
                    textMD: model.fileName
                    convertInProcess: false
                    isInputBox: false
                }

                Item {
                    id: loadingTextItem
                    visible: control.generateProcess
                    width: parent.width - logoModelId.width
                    height: 30

                    property int dotCount: 0

                    Timer {
                        interval: 500
                        running: loadingTextItem.visible
                        repeat: true
                        onTriggered: {
                            loadingTextItem.dotCount = (loadingTextItem.dotCount + 1) % 5
                        }
                    }

                    Label {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 12
                        color: Style.Colors.textInformation
                        text: conversationList.currentConversation.logState + ".".repeat(loadingTextItem.dotCount)
                    }
                }

                TextArea {
                    id: textId
                    visible: !control.generateProcess
                    color: Style.Colors.textTitle
                    selectionColor: Style.Colors.textSelection
                    placeholderTextColor: textId.text ===""? Style.Colors.menuNormalIcon: Style.Colors.textPlaceholder
                    width: parent.width - logoModelId.width
                    font.pixelSize: 14
                    focus: false
                    readOnly: true
                    wrapMode: TextEdit.WordWrap
                    textFormat: TextEdit.PlainText

                    cursorVisible: control.generateProcess ?
                                                                conversationList.currentConversation.responseInProgress: false
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
                        textProcessor.textDocument = textId.textDocument
                        textProcessor.setValue(model.text)
                    }
                }

                MyButton{
                    id: newChatId
                    visible: !conversationList.isEmptyConversation
                    myText: "Open"
                    myIcon: "qrc:/media/icon/add.svg"
                    myTextToolTip: "Open"
                    bottonType: Style.RoleEnum.BottonType.Primary
                    Connections {
                        target: newChatId
                        function onClicked(){
                            conversationList.currentConversation.readSourcesAndActivity(model.id)
                        }
                    }
                }

                DateAndIconsMessage{
                    id: dateAndIconId
                }
            }
        }
    }
}
