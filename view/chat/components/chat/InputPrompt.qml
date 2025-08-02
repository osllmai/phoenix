import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects
import '../../../component_library/style' as Style
import '../../../component_library/button'
import './components'

Rectangle{
    id: control
    height: 90 + (allFileExist.visible? allFileExist.height:0); width: Math.min(670, parent.width - 48)
    anchors.horizontalCenter: parent.horizontalCenter
    color: Style.Colors.boxNormalGradient0
    border.width: 1
    border.color: Style.Colors.boxBorder
    radius: 8

    function sendMessage(){
        sendIconId.clicked()
    }

    signal sendPrompt(var prompt)
    signal openModelIsLoaded()

    property string textInput: ""
    onTextInputChanged: {
        textInputId.setText(control.textInput)
    }

    function selectSendIcon(){
        if(!conversationList.isEmptyConversation && conversationList.currentConversation.responseInProgress){
            sendIconId.myTextToolTip = "Stop"
            if(sendIconId.hovered)
                return "qrc:/media/icon/stopFill.svg"
            else
                return "qrc:/media/icon/stop.svg"
        }else{
            sendIconId.myTextToolTip = "Send"
            if(sendIconId.hovered)
                return "qrc:/media/icon/sendFill.svg"
            else
                return "qrc:/media/icon/send.svg"
        }
    }

    function selectSpeechIcon(){
        if(speechToText.modelSelect){
            if(audioRecorder.isRecording)
                if(speechIconId.hovered)
                    return "qrc:/media/icon/stopFill.svg"
                else
                    return "qrc:/media/icon/stop.svg"
            else
                if(speechIconId.hovered)
                    return "qrc:/media/icon/microphoneOnFill.svg"
                else
                    return "qrc:/media/icon/microphoneOn.svg"
        }else{
            if(speechIconId.hovered)
                return "qrc:/media/icon/microphoneOn.svg"
            else
                return "qrc:/media/icon/microphoneOn.svg"
        }
    }

    Column{
        anchors.fill: parent
        anchors.margins: 10

        FileConverteInputPrompt{
            id: allFileExist
            visible: convertToMD.fileIsSelect
            onVisibleChanged: {
                if(allFileExist.visible)
                    control.height = control.height + allFileExist.height
                else
                    control.height = control.height - allFileExist.height
            }
            filePath: convertToMD.filePath
            textMD: convertToMD.textMD
            convertInProcess: convertToMD.convertInProcess
            isInputBox: true
            onCloseFile: {
                convertToMD.fileIsSelect = false
            }
        }

        TextInput{
            id: textInputId
            visible: !audioRecorder.isRecording
            width: parent.width
            height: parent.height - iconList.height - (allFileExist.visible? allFileExist.height:0)
        }

        AudioRecoderInput{
            id: audioRecorderInputId
            visible: audioRecorder.isRecording
            width: parent.width
            height: parent.height - iconList.height - (allFileExist.visible? allFileExist.height:0)
        }

        Item {
            id:iconList
            width: parent.width
            height: 32

            Row {
                anchors.left: parent.left
                spacing: 10

                MyIcon {
                    id: selectFileIconId
                    width: 32; height: 32
                    myIcon: "qrc:/media/icon/selectFile.svg"
                    iconType: Style.RoleEnum.IconType.Primary
                    onClicked: {
                        fileDialogId.open();
                    }
                }
                FileDialog {
                    id: fileDialogId
                    title: "Choose file"
                    fileMode: FileDialog.OpenFiles

                    nameFilters: [
                        "Supported files (*.docx *.pptx *.html *.htm *.jpg *.jpeg *.png *.pdf *.md *.csv *.xlsx *.xml *.json *.mp3 *.wav)",
                        "Word files (*.docx)",
                        "PowerPoint files (*.pptx)",
                        "HTML files (*.html *.htm)",
                        "Image files (*.jpg *.jpeg *.png)",
                        "PDF files (*.pdf)",
                        "AsciiDoc files (*.adoc *.asciidoc)",
                        "Markdown files (*.md)",
                        "CSV files (*.csv)",
                        "Excel files (*.xlsx)",
                        "XML files (*.xml)",
                        "JSON files (*.json)",
                        "Audio files (*.mp3 *.wav)",
                        "All files (*)"
                    ]

                    onAccepted: function() {
                        convertToMD.filePath = currentFile /*currentFile.toLocalFile();*/
                        convertToMD.startConvert()
                    }
                }

            }

            Row {
                anchors.right: parent.right
                spacing: 10

                Item{
                    id: speechIconId
                    width: 30; height: 30

                    Loader {
                        id: loadedSpeechModel
                        anchors.fill: parent
                        active: speechToText.modelInProcess
                        sourceComponent: BusyIndicator {
                            running: true
                            width: 30
                            height: 30

                            contentItem: Item {
                                implicitWidth: 30
                                implicitHeight: 30

                                Canvas {
                                    id: spinnerCanvas
                                    anchors.fill: parent
                                    onPaint: {
                                        var ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        ctx.beginPath()
                                        ctx.arc(width / 2, height / 2, width / 2 - 2, 0, Math.PI * 1.5)
                                        ctx.lineWidth = 2
                                        ctx.strokeStyle = Style.Colors.iconPrimaryHoverAndChecked;
                                        ctx.stroke()
                                    }
                                    Component.onCompleted: requestPaint()
                                }

                                RotationAnimator on rotation {
                                    from: 0
                                    to: 360
                                    duration: 1000
                                    loops: Animation.Infinite
                                    running: true
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        control.openModelIsLoaded()
                                    }
                                }
                            }
                        }
                    }
                    MyIcon {
                        visible: !speechToText.modelInProcess
                        anchors.fill: parent
                        myIcon: selectSpeechIcon()
                        iconType: Style.RoleEnum.IconType.Primary
                        enabled: !speechToText.modelInProcess

                        onClicked: {
                            audioRecorderInputId.recoderAction()
                            textInputId.setText("")
                        }
                    }
                }



                Item {
                    id: sendButtonArea
                    width: 30
                    height: 30

                    Loader {
                        id: loadedTextGenerationModel
                        anchors.fill: parent
                        active: !conversationList.isEmptyConversation && conversationList.currentConversation.loadModelInProgress
                        sourceComponent: BusyIndicator {
                            running: true
                            width: 30
                            height: 30

                            contentItem: Item {
                                implicitWidth: 30
                                implicitHeight: 30

                                Canvas {
                                    id: spinnerCanvasId
                                    anchors.fill: parent
                                    onPaint: {
                                        var ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        ctx.beginPath()
                                        ctx.arc(width / 2, height / 2, width / 2 - 2, 0, Math.PI * 1.5)
                                        ctx.lineWidth = 2
                                        ctx.strokeStyle = Style.Colors.iconPrimaryHoverAndChecked;
                                        ctx.stroke()
                                    }
                                    Component.onCompleted: requestPaint()
                                }

                                RotationAnimator on rotation {
                                    from: 0
                                    to: 360
                                    duration: 1000
                                    loops: Animation.Infinite
                                    running: true
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        control.openModelIsLoaded()
                                    }
                                }
                            }
                        }
                    }

                    MyIcon {
                        id: sendIconId
                        visible: conversationList.isEmptyConversation || (!conversationList.isEmptyConversation && !conversationList.currentConversation.loadModelInProgress)
                        anchors.fill: parent
                        myIcon: selectSendIcon()
                        iconType: Style.RoleEnum.IconType.Primary

                        enabled: !(convertToMD.convertInProcess || audioRecorder.isRecording || speechToText.modelInProcess)

                        onClicked: {
                            if (!conversationList.isEmptyConversation && conversationList.currentConversation.loadModelInProgress){
                                control.openModelIsLoaded()
                            } else if (!conversationList.isEmptyConversation && conversationList.currentConversation.responseInProgress) {
                                conversationList.currentConversation.stop()
                            } else if (
                                (!conversationList.isEmptyConversation &&
                                 !conversationList.currentConversation.responseInProgress &&
                                 !conversationList.currentConversation.loadModelInProgress) ||
                                 conversationList.isEmptyConversation)
                            {
                                control.sendPrompt(textInputId.inputValue)

                                if (conversationList.modelSelect)
                                    textInputId.inputValue = ""

                                if (speechToText.speechInProcess) {
                                    speechToText.stopRecording()
                                    speechToText.text = ""
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    layer.enabled: false
    layer.effect: Glow {
         samples: 40
         color:  Style.Colors.boxBorder
         spread: 0.1
         transparentBorder: true
     }
}
