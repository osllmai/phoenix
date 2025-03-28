import QtQuick
import QtCore
import QtQuick.Controls.Basic
import QtTextToSpeech
import './component_library/style' as Style

ApplicationWindow {
    id: window
    width: 1700; height: 900
    minimumWidth: 1400; minimumHeight: 800
    color: Style.Colors.background

    property string theme: "Light"
    onThemeChanged: {
        console.log(theme)
        if((window.theme === "Dark") || (window.theme === "Light"))
            Style.Colors.theme = window.theme
        else if(isDarkTheme)
            Style.Colors.theme = "Dark"
        else
            Style.Colors.theme = "Light"
    }

    font.family: "Constantia"

    property double speechVolume: 0.8
    property double speechPitch: 0
    property double speechRate: 0

    Settings{
        category: "window"
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
        property alias theme: window.theme
        property alias fontFamily: window.font.family
        property alias speechVolume: window.speechVolume
        property alias speechPitch: window.speechPitch
        property alias speechRate: window.speechRate
    }


    TextToSpeech {
        id: textToSpeechId
        volume: 0.8
        pitch: 0
        rate: 0

        property int messageId: -1

        onStateChanged: function(state) { updateStateLabel(state); }

        function updateStateLabel(state)
        {
            switch (state) {
                case TextToSpeech.Ready:
                    console.log("Ready")
                    break
                case TextToSpeech.Speaking:
                    console.log("Speaking")
                    break
                case TextToSpeech.Paused:
                    console.log("Paused...")
                    break
                case TextToSpeech.Error:
                    console.log("Error!")
                    break
            }
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
}
