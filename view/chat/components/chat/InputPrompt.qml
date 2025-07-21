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

    property string textInput: speechToText.text
    onTextInputChanged: {
        if(textInput != "")
            inputTextBox.text  = control.textInput
    }

    function requestEmptyTheInput(){
        inputTextBox.text = ""
    }

    function sendMessage(){
        sendIconId.clicked()
    }

    signal sendPrompt(var prompt)
    signal openModelIsLoaded()

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
            if(speechToText.speechInProcess)
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

    function iconForFile(fileUrl) {
        let ext = fileUrl.split('.').pop().toLowerCase();
        switch (ext) {
        case "docx": return "qrc:/media/icon/fileDocx.svg"
        case "pptx": return "qrc:/media/icon/filePptx.svg"
        case "html":
        case "htm": return "qrc:/media/icon/fileHtml.svg"
        case "jpg":
        case "jpeg": return "qrc:/media/icon/fileJpg.svg"
        case "png": return "qrc:/media/icon/filePng.svg"
        case "pdf": return "qrc:/media/icon/filePdf.svg"
        case "md": return "qrc:/media/icon/fileMd.svg"
        case "csv": return "qrc:/media/icon/fileCsv.svg"
        case "xlsx": return "qrc:/media/icon/fileXlsx.svg"
        case "xml": return "qrc:/media/icon/fileXml.svg"
        case "json": return "qrc:/media/icon/fileJson.svg"
        case "mp3": return "qrc:/media/icon/fileMp3Audio.svg"
        case "wav": return "qrc:/media/icon/fileWav.svg"
        default: return "qrc:/media/icon/filePdf.svg"
        }
    }


    Column{
        anchors.fill: parent
        anchors.margins: 10

        FileConverteInputPrompt{
            id: allFileExist
            visible: false
            onVisibleChanged: {
                if(allFileExist.visible)
                    control.height = control.height + allFileExist.height
                else
                    control.height = control.height - allFileExist.height
            }
        }

        TextInput{
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
                        convertToMD.filePath = currentFile
                        convertToMD.startConvert()
                        allFileExist.iconSource = iconForFile(currentFile)
                        allFileExist.visible = true
                    }
                }

            }

            Row {
                anchors.right: parent.right
                spacing: 10

                MyIcon {
                    id: speechIconId
                    width: 30; height: 30
                    myIcon: selectSpeechIcon()
                    iconType: Style.RoleEnum.IconType.Primary
                    onClicked: {
                        // if(speechToText.modelSelect){
                        //     if(speechToText.speechInProcess)
                        //         speechToText.stopRecording()
                        //     else
                        //         speechToText.startRecording()
                        // }else{
                        //     selectSpeechModelVerificationId.open()
                        // }

                        audioRecorderInputId.recoderAction()
                    }
                }

                Item {
                    id: sendButtonArea
                    width: 30
                    height: 30

                    Loader {
                        id: loadedImage
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
                                    id: spinnerCanvas
                                    anchors.fill: parent
                                    onPaint: {
                                        var ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        ctx.beginPath()
                                        ctx.arc(width / 2, height / 2, width / 2 - 2, 0, Math.PI * 1.5)
                                        ctx.lineWidth = 3
                                        ctx.strokeStyle = Style.Colors.iconPrimaryNormal;
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
                                sendPrompt(inputTextBox.text)

                                if (conversationList.modelSelect)
                                    inputTextBox.text = ""

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

    VerificationDialog {
        id: selectSpeechModelVerificationId
        titleText: "Select Speech Model"
        about: "Are you sure you want to leave this page and select a new speech model?"
        textBotton1: "Cancel"
        textBotton2: "Select Model"
        typeBotton1: Style.RoleEnum.BottonType.Secondary
        typeBotton2: Style.RoleEnum.BottonType.Primary
        Connections{
            target:selectSpeechModelVerificationId
            function onButtonAction1(){
                selectSpeechModelVerificationId.close()
            }
            function onButtonAction2() {
                selectSpeechModelVerificationId.close()
                appBodyId.currentIndex = 2
                window.setModelPages("offline", "Speech")
            }
        }
    }
}
