import QtQuick 2.15
import '../../../../component_library/style' as Style

Item {

    property int maxItems: levelView.width/5

    ListModel {
        id: levelModel
    }

    function recoderAction(){
        if(audioRecorder.isRecording){
            audioRecorder.stopRecording()
        }else{
            levelModel.clear()
            audioRecorder.startRecording()
            updateTimer.start()
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

}
