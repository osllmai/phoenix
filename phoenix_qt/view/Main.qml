import QtQuick
import QtCore
import QtQuick.Controls.Basic
import QtTextToSpeech
import './component_library/style' as Style

ApplicationWindow {
    id: window
    width: 1700; height: 900
    minimumWidth: 400; minimumHeight: 400
    color: Style.Colors.background

    property string theme: "Light"
    onThemeChanged: {
        Style.Colors.theme = window.theme
    }

    font.family: "Times New Roman"

    Settings{
        category: "window"
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
        property alias theme: window.theme
        property alias fontFamily: window.font.family
    }

    TextToSpeech {
        id: textToSpeechId
        volume: 0.8
        pitch: 0
        rate: 0

        onStateChanged: (state) => {
            switch (state) {
                case TextToSpeech.Ready:
                    console.log("TTS Ready")
                    break
                case TextToSpeech.Speaking:
                    console.log("TTS Speaking")
                    break
                case TextToSpeech.Paused:
                    console.log("TTS Paused")
                    break
                case TextToSpeech.Error:
                    console.log("TTS Error!")
                    break
            }
        }


        // onStateChanged: updateStateLabel(state)

        // function updateStateLabel(state)
        // {
        //     switch (state) {
        //         case TextToSpeech.Ready:
        //             statusLabel.text = qsTr("Ready")
        //             break
        //         case TextToSpeech.Speaking:
        //             statusLabel.text = qsTr("Speaking")
        //             break
        //         case TextToSpeech.Paused:
        //             statusLabel.text = qsTr("Paused...")
        //             break
        //         case TextToSpeech.Error:
        //             statusLabel.text = qsTr("Error!")
        //             break
        //     }
        // }
        onSayingWord: (word, id, start, length)=> {
            input.select(start, start + length)
        }
    }

    visible: true
    title: qsTr("Phoenix")    

    function isDesktopSize(){
        if(width<550)
            return false;
        return true;
    }

    Item{
        anchors.fill:parent
        anchors.margins: 0
        AppMenu{
            id:appMenuDesktopId
            visible: window.isDesktopSize()
            clip:true
            Behavior on width {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }
        }
        Column{
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: window.isDesktopSize()? appMenuDesktopId.right: parent.left
            anchors.right: parent.right
            AppBody{
                id:appBodyId
                width: parent.width; height: parent.height -appFooter.height
                clip:true
            }
            AppFooter{
                id: appFooter
            }
        }
    }
    Rectangle{
        id:line
        width: parent.width; height: 1
        color: Style.Colors.boxBorder
        anchors.top: parent.top
    }

    // footer: Label {
    //     id: statusLabel
    // }

    // Component.onCompleted: {
    //     // enginesComboBox.currentIndex = tts.availableEngines().indexOf(tts.engine)
    //     // some engines initialize asynchronously
    //     if (textToSpeechId.state === TextToSpeech.Ready) {
    //         // engineReady()
    //     } else {
    //         textToSpeechId.stateChanged.connect(root.engineReady)
    //     }

    //     textToSpeechId.updateStateLabel(textToSpeechId.state)
    // }

    // function engineReady() {
    //     tts.stateChanged.disconnect(root.engineReady)
    //     if (tts.state !== TextToSpeech.Ready) {
    //         tts.updateStateLabel(tts.state)
    //         return;
    //     }
    //     updateLocales()
    //     updateVoices()
    // }

    // function updateLocales() {
    //     let allLocales = tts.availableLocales().map((locale) => locale.nativeLanguageName)
    //     let currentLocaleIndex = allLocales.indexOf(tts.locale.nativeLanguageName)
    //     localesComboBox.model = allLocales
    //     localesComboBox.currentIndex = currentLocaleIndex
    // }

    // function updateVoices() {
    //     voicesComboBox.model = tts.availableVoices().map((voice) => voice.name)
    //     let indexOfVoice = tts.availableVoices().indexOf(tts.voice)
    //     voicesComboBox.currentIndex = indexOfVoice
    // }

    Component.onCompleted: {
        let voices = textToSpeechId.availableVoices()
        if (voices.length === 0) {
            console.log("Error: No available voices in Component.onCompleted!")
        } else {
            console.log("Available voices:", voices)
        }
    }

}
