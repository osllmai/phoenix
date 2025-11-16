import QtQuick
import QtCore
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt.labs.platform
import QtTextToSpeech
import QtQuick.Dialogs
import './component_library/style' as Style
import './component_library/button'

ApplicationWindow {
    id: window
    width: 1200; height: 800
    minimumWidth: 700; minimumHeight: 700

    color: Style.Colors.background
    visible: true
    flags: Qt.Window |
           Qt.CustomizeWindowHint |
           Qt.WindowMinimizeButtonHint |
           Qt.WindowMaximizeButtonHint |
           Qt.WindowContextHelpButtonHint

    property int prevX: 0
    property int prevY: 0
    property int prevW: 0
    property int prevH: 0

    property string lastFolder: "file:///" + Logger.logDir

    property string theme: "Default"
    onThemeChanged: {
        if ((window.theme === "Dark") || (window.theme === "Light"))
            Style.Colors.theme = window.theme
        else if (isDarkTheme)
            Style.Colors.theme = "Dark"
        else
            Style.Colors.theme = "Light"

        codeColors.defaultColor = Style.Colors.textInformation
        codeColors.keywordColor = Style.Colors.textTagInfo
        codeColors.functionColor = Style.Colors.textTagWarning
        codeColors.functionCallColor = Style.Colors.textTagError
        codeColors.commentColor = Style.Colors.textTitle
        codeColors.stringColor = Style.Colors.textTagInfo
        codeColors.numberColor = Style.Colors.textTitle
        codeColors.headerColor = Style.Colors.boxNormalGradient1
        codeColors.backgroundColor = Style.Colors.boxNormalGradient0

        if(!conversationList.isEmptyConversation){
            conversationList.currentConversation.messageList.updateAllTextMessage()
        }
    }

    property string modelPageView: "gridView"
    function setModelPages(page, filter){
        appBodyId.setModelPages(page, filter)
    }

    Component.onCompleted: {
        codeColors.defaultColor = Style.Colors.textInformation
        codeColors.keywordColor = Style.Colors.textTagInfo
        codeColors.functionColor = Style.Colors.textTagWarning
        codeColors.functionCallColor = Style.Colors.textTagError
        codeColors.commentColor = Style.Colors.textTitle
        codeColors.stringColor = Style.Colors.textTagInfo
        codeColors.numberColor = Style.Colors.textTitle
        codeColors.headerColor = Style.Colors.boxNormalGradient1
        codeColors.backgroundColor = Style.Colors.boxNormalGradient0
    }

    font.family: "DM Sans"

    Settings {
        id: appSettings
        category: "window"

        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
        property alias theme: window.theme
        property alias fontFamily: window.font.family
        property alias modelPageView: window.modelPageView
        property alias isOpenMenu: window.isOpenMenu

        property real speechVolume: value("speechVolume", 0.8)
        property real speechPitch: value("speechPitch", 0.0)
        property real speechRate: value("speechRate", 0.0)

        property alias lastFolder: window.lastFolder
    }

    // ------------------ System Tray ------------------
    SystemTrayIcon {
        id: systemTrayIcon
        property bool shouldClose: false
        visible: !shouldClose
        icon.source: "qrc:/media/image_company/phoenix.svg"

        function restore() {
            window.show()
            window.raise()
            window.requestActivate()
        }

        onActivated: function(reason) {
            if (reason === SystemTrayIcon.Context && Qt.platform.os !== "osx")
                menu.open()
            else if (reason === SystemTrayIcon.Trigger)
                restore()
        }

        menu: Menu {
            MenuItem {
                text: qsTr("Restore")
                onTriggered: systemTrayIcon.restore()
            }
            MenuItem {
                text: qsTr("Quit")
                onTriggered: {
                    systemTrayIcon.restore()
                    systemTrayIcon.shouldClose = true
                    window.shouldClose = true
                }
            }
        }
    }

    // ------------------ TextToSpeech ------------------
    TextToSpeech {
        id: textToSpeechId
        volume: appSettings.speechVolume
        pitch: appSettings.speechPitch
        rate: appSettings.speechRate
        property int messageId: -1
    }

    title: qsTr("Phoenix v" + updateChecker.currentVersion + " Beta")

    property bool isDesktopSize: width >= 850
    onIsDesktopSizeChanged: {
        appMenuApplicationId.close()
        if(window.isDesktopSize){
            if(window.isOpenMenu){
                appMenuDesktopId.width = 200
            }else{
                appMenuDesktopId.width = 60
            }
        }
    }

    property bool isOpenMenu: false
    onIsOpenMenuChanged: {
        if(window.isOpenMenu){
            if(window.isDesktopSize){
                appMenuDesktopId.width = 200
            }else{
                appMenuApplicationId.open()
            }
        }else{
            if(window.isDesktopSize){
                appMenuDesktopId.width = 60
            }else{
                appMenuApplicationId.open()
            }
        }
    }

    // ------------------ Main Layout ------------------
    Column{
        anchors.fill: parent
        anchors.margins: 0
        AppHeader{
            id: appHeader
        }
        Item {
            width: parent.width
            height: parent.height - appHeader.height

            AppMenu {
                id: appMenuDesktopId
                visible: window.isDesktopSize
                clip: true
            }

            Column {
                anchors.fill: parent
                anchors.leftMargin: window.isDesktopSize ? appMenuDesktopId.width : 0

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
            AppMenuDrawer{
                id: appMenuApplicationId
            }
        }
    }

    // ------------------ About Version Dialog ------------------
    VerificationDialog {
        id: aboutVersion
        height: 230
        width: 365
        titleText: "Phoenix"
        about: "Version: "  + updateChecker.currentVersion + " (user setup)\nCommit: 5ab0775a1b6ff560452f041b2043c3d7d70fe1ba\nDate: "+ updateChecker.currentDate +"\nOS: "+ systemType
        textBotton1: "Copy"
        textBotton2: "OK"
        typeBotton1: Style.RoleEnum.BottonType.Secondary
        typeBotton2: Style.RoleEnum.BottonType.Primary
        locationText: Text.AlignLeft
        Connections{
            target:aboutVersion
            function onButtonAction1(){
                Clipboard.copyText(aboutVersion.about)
            }
            function onButtonAction2() {
                aboutVersion.close()
            }
        }
    }

    // ------------------ Update Checker ------------------
    Timer {
        id: updateTimer
        interval: 3000
        running: true
        repeat: false
        onTriggered: {
            updateChecker.checkForUpdatesAsync()
        }
    }

    UpdateAvailable{
        id: updateDialog
        visible: false
    }

    // ------------------ Window Closing Logic ------------------
    property bool shouldClose: false

    onClosing: function(close) {
        if (systemTrayIcon.visible) {
            window.visible = false
            close.accepted = false
            return
        }

        if (window.shouldClose)
            return

        window.shouldClose = true
        close.accepted = false
    }
}
