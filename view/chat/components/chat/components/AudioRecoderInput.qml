import QtQuick 2.15
import '../../../../component_library/style' as Style
import '../../../../component_library/button'

Item {
    property int maxItems: levelView.width/5

    ListModel {
        id: levelModel
    }

    function recoderAction(){
        if(speechToText.modelSelect){
            if(audioRecorder.isRecording){
                audioRecorder.stopRecording()
                speechToText.start()
            }else{
                levelModel.clear()
                audioRecorder.startRecording()
                updateTimer.start()
            }
        }else{
            selectSpeechModelVerificationId.open()
        }
    }

    Timer {
        id: updateTimer
        interval: 85
        repeat: true
        running: false
        onTriggered: {
            if (audioRecorder.isRecording) {
                levelModel.append({ level: audioRecorder.level })
                if (levelModel.count > maxItems)
                    levelModel.remove(0)
            }
        }
    }

    ListView {
        id: levelView
        width: parent.width - 10
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 1
        orientation: ListView.Horizontal
        model: levelModel
        clip: true

        delegate: Item{
            width: 4
            height: levelView.height
            Rectangle {
                radius: 50
                width: parent.width
                height: Math.min(Math.max(4, 180* model.level), (levelView.height))
                color: Style.Colors.buttonPrimaryNormal
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        onCountChanged: {
            if (levelView.count > 0)
                levelView.positionViewAtEnd()
        }
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
