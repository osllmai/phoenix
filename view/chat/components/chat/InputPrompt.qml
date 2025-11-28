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

    signal sendPrompt(var prompt, string converstationType)
    signal openModelIsLoaded()

    property string textInput: ""
    onTextInputChanged: {
        textInputId.setText(control.textInput)
        textInputId.inputValue = control.textInput
    }

    property string currentTextConverstation: !conversationList.isEmptyConversation ?
                                             conversationList.currentConversation.type : ""

    property string currentIconConverstation: getIconForText(currentTextConverstation)

    ListModel {
        id: modeList
        ListElement { title: "Add photos & files"; icon:"qrc:/media/icon/selectFile.svg" }
        ListElement { title: "Create image"; icon:"qrc:/media/icon/imageEditor.svg" }
        ListElement { title: "Thinking"; icon:"qrc:/media/icon/indoxJudge.svg" }
        ListElement { title: "Deep research"; icon:"qrc:/media/icon/deepSearch.svg" }
        ListElement { title: "Study and Learn"; icon:"qrc:/media/icon/indoxJudge.svg" }
        ListElement { title: "Web Search"; icon:"qrc:/media/icon/indoxGen.svg" }
        ListElement { title: "Canvas"; icon:"qrc:/media/icon/developer.svg" }
    }

    function getIconForText(text) {
        for (var i = 0; i < modeList.count; ++i) {
            if (modeList.get(i).title === text) {
                return modeList.get(i).icon
            }
        }
        return ""
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

            Row{
                anchors.left: parent.left
                spacing: 10
                AddFileAndMore{}
                MyButton{
                    id: currentChatMode
                    visible: control.currentTextConverstation === ""? false: true
                    bottonType: Style.RoleEnum.BottonType.Secondary
                    myText: control.currentTextConverstation
                    myIcon: (conversationList.isEmptyConversation && currentChatMode.hovered )? "qrc:/media/icon/close.svg": control.currentIconConverstation
                    onClicked: {
                        control.currentTextConverstation = ""
                        control.currentIconConverstation = ""
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
                                control.sendPrompt(textInputId.inputValue, control.currentTextConverstation)
                                // textInputId.setText("")

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
