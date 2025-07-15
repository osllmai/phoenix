import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects
import '../../../component_library/style' as Style
import '../../../component_library/button'

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

    Column{
        anchors.fill: parent
        anchors.margins: 10

        Item{
            id: allFileExist
            width: parent.width
            height: 60
            visible: false
            onVisibleChanged: {
                if(allFileExist.visible)
                    control.height = control.height + allFileExist.height
                else
                    control.height = control.height - allFileExist.height
            }

            MyIcon {
                id: pdfId
                width: 60; height: 60
                myIcon: "qrc:/media/icon/pdf.svg"
                iconType: Style.RoleEnum.IconType.Image
                onClicked: {
                }
            }
        }

        ScrollView {
            id: scrollInput
            width: parent.width
            height: parent.height - iconList.height - (allFileExist.visible? allFileExist.height:0)
            ScrollBar.vertical.interactive: true

            ScrollBar.vertical.policy: scrollInput.contentHeight > scrollInput.height
                                       ? ScrollBar.AlwaysOn
                                       : ScrollBar.AlwaysOff

            ScrollBar.vertical.active: (scrollInput.contentY > 0) &&
                            (scrollInput.contentY < scrollInput.contentHeight - scrollInput.height)

            TextArea {
                id: inputTextBox

                color: Style.Colors.textInformation
                background: null

                wrapMode: Text.Wrap
                placeholderText: qsTr("How can I help you?")

                Accessible.role: Accessible.EditableText
                Accessible.name: placeholderText
                Accessible.description: qsTr("Send prompts to the model")

                clip: false
                font.pointSize: 10
                hoverEnabled: true
                tabStopDistance: 80
                selectionColor: Style.Colors.boxNormalGradient1
                cursorVisible: false
                persistentSelection: true
                placeholderTextColor: Style.Colors.textInformation

                onTextChanged: {
                    control.layer.enabled = true
                    adjustHeight()
                }

                onContentHeightChanged: {
                    adjustHeight()
                }

                function adjustHeight() {
                    const newHeight = Math.max(40, inputTextBox.contentHeight);
                    if (inputTextBox.text === "") {
                        control.height =  90 + (allFileExist.visible? allFileExist.height:0);
                    } else {
                        control.height = Math.min(newHeight + 28, 180) + iconList.height + (allFileExist.visible? allFileExist.height:0);
                    }
                }

                Keys.onReturnPressed: (event)=> {
                      if (event.modifiers & Qt.ControlModifier || event.modifiers & Qt.ShiftModifier){
                        event.accepted = false;
                      }else if((!conversationList.isEmptyConversation &&
                                                !conversationList.currentConversation.responseInProgress &&
                                                !conversationList.currentConversation.loadModelInProgress) ||
                                                conversationList.isEmptyConversation){
                          sendPrompt(inputTextBox.text)
                          if(conversationList.modelSelect)
                                inputTextBox.text = ""

                          if(speechToText.speechInProcess){
                              speechToText.stopRecording()
                              speechToText.text = ""
                          }
                    }
                }

                onEditingFinished: {
                    control.layer.enabled= false
                }
                onPressed: {
                    control.layer.enabled= true
                }
            }
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
                FileDialog{
                    id: fileDialogId
                    title: "Choose file"
                    nameFilters: ["Text files (*.pdf)"]
                    fileMode: FileDialog.OpenFiles
                    onAccepted: function(){
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
                        if(speechToText.modelSelect){
                            if(speechToText.speechInProcess)
                                speechToText.stopRecording()
                            else
                                speechToText.startRecording()
                        }else{
                            selectSpeechModelVerificationId.open()
                        }
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
