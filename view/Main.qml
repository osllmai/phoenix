import QtQuick
import QtCore
import QtQuick.Controls.Basic
import QtTextToSpeech
import './component_library/style' as Style

ApplicationWindow {
    id: window
    width: 1700; height: 900
    minimumWidth: 400; minimumHeight: 600
    color: Style.Colors.background

    property string theme: "Defualt"
    onThemeChanged: {
        if ((window.theme === "Dark") || (window.theme === "Light"))
            Style.Colors.theme = window.theme
        else if (isDarkTheme)
            Style.Colors.theme = "Dark"
        else
            Style.Colors.theme = "Light"
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

        property real speechVolume: value("speechVolume", 0.8)
        property real speechPitch: value("speechPitch", 0.0)
        property real speechRate: value("speechRate", 0.0)

        property int modeTextlId: window.modeTextlId
        property alias modelTextIcon: window.modelTextIcon
        property alias modelTextName: window.modelTextName
        property alias modelPromptTemplate: window.modelPromptTemplate
        property alias modelSystemPrompt: window.modelSystemPrompt
        property bool modelTextSelect: window.modelTextSelect

        property alias modelSpeechPath: window.modelSpeechPath
        property bool modelSpeechSelect: window.modelSpeechSelect
    }


    function setModelText(){
        conversationList.setModelRequest(window.modeTextlId,
                                                                window,modelTextName,
                                                                window.modelTextIcon,
                                                                window.modelPromptTemplate,
                                                                window.modelSystemPrompt)
        conversationList.isEmptyConversation = window.modelTextSelect
    }

    property int modeTextlId: -1
    property string modelTextIcon: ""
    property string modelTextName: ""
    property string modelPromptTemplate: ""
    property string modelSystemPrompt: ""
    property bool modelTextSelect: false
    onModeTextlIdChanged: {
        window.setModelText()
    }
    onModelTextIconChanged: {
        window.setModelText()
    }
    onModelTextNameChanged: {
        window.setModelText()
    }
    onModelPromptTemplateChanged: {
        window.setModelText()
    }
    onModelSystemPromptChanged: {
        window.setModelText()
    }
    onModelTextSelectChanged: {
        window.setModelText()
    }


    function setModelSpeech(){
        speechToText.modelPath = window.modelSpeechPath
        speechToText.modelSelect = window.modelSpeechSelect
    }

    property string modelSpeechPath: ""
    property bool modelSpeechSelect: false
    onModelSpeechPathChanged: {
        window.setModelSpeech()
    }
    onModelSpeechSelectChanged: {
        window.setModelSpeech()
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

    property bool isDesktopSize: width >= 630;
    onIsDesktopSizeChanged: {
        appMenuApplicationId.close()
        if(window.isDesktopSize){
            window.isOpenMenu = true
        }
    }

    property bool isOpenMenu: true
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

    Item {
        anchors.fill: parent
        anchors.margins: 0

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
    }

    Rectangle {
        id: line
        width: parent.width
        height: 1
        color: Style.Colors.boxBorder
        anchors.top: parent.top
    }

    AppMenuDrawer{
        id: appMenuApplicationId
    }
}
