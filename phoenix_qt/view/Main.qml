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
        if ((window.theme === "Dark") || (window.theme === "Light"))
            Style.Colors.theme = window.theme
        else if (isDarkTheme)
            Style.Colors.theme = "Dark"
        else
            Style.Colors.theme = "Light"
    }

    font.family: "Constantia"

    Settings {
        id: appSettings
        category: "window"

        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
        property alias theme: window.theme
        property alias fontFamily: window.font.family

        property real speechVolume: value("speechVolume", 0.8)
        property real speechPitch: value("speechPitch", 0.0)
        property real speechRate: value("speechRate", 0.0)
    }

    TextToSpeech {
        id: textToSpeechId
        volume: appSettings.speechVolume
        pitch: appSettings.speechPitch
        rate: appSettings.speechRate

        property int messageId: -1
    }

    visible: true
    title: qsTr("Phoenix")

    function isDesktopSize() {
        return width >= 550;
    }

    Item {
        anchors.fill: parent
        anchors.margins: 0

        AppMenu {
            id: appMenuDesktopId
            visible: window.isDesktopSize()
            clip: true
        }

        Column {
            anchors.fill: parent
            anchors.leftMargin: window.isDesktopSize() ? appMenuDesktopId.width : 0

            AppBody {
                id: appBodyId
                width: parent.width
                height: parent.height - appFooter.height
                clip: true
            }

            AppFooter {
                id: appFooter
            }
        }
    }

    Rectangle {
        id: line
        width: parent.width
        height: 1
        color: Style.Colors.boxBorder
        anchors.top: parent.top
    }
}
