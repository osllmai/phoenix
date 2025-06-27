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

    // flags: Qt.Window | Qt.FramelessWindowHint
    flags: Qt.Window |
           Qt.CustomizeWindowHint |
           Qt.WindowMinimizeButtonHint |
           Qt.WindowMaximizeButtonHint |
           Qt.WindowContextHelpButtonHint
           // Qt.WindowStaysOnTopHint |
           // Qt.WindowTitleHint |
           // Qt.WindowActive |
           // Qt.WindowNoState |
           // Qt.CustomDashLine |
            // Qt.FramelessWindowHint
           // Qt.ElideLeft

    property int prevX: 0
    property int prevY: 0
    property int prevW: 0
    property int prevH: 0

    property string theme: "Defualt"
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
    title: qsTr("Phoenix v0.1.1")

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

    // MouseArea {
    //     id: tapEdge
    //     z: 10
    //     anchors.top: parent.top
    //     anchors.left: parent.left
    //     anchors.right: parent.right
    //     height: 6
    //     cursorShape: Qt.SizeVerCursor
    //     onPressed: mouse => window.startSystemResize(Qt.TopEdge)
    // }

    // MouseArea {
    //     id: bottomEdge
    //     z: 10
    //     anchors.bottom: parent.bottom
    //     anchors.left: parent.left
    //     anchors.right: parent.right
    //     height: 6
    //     cursorShape: Qt.SizeVerCursor
    //     onPressed: mouse => window.startSystemResize(Qt.BottomEdge)
    // }

    // MouseArea {
    //     id: leftEdge
    //     z: 10
    //     anchors.left: parent.left
    //     anchors.top: parent.top
    //     anchors.bottom: parent.bottom
    //     width: 6
    //     cursorShape: Qt.SizeHorCursor
    //     onPressed: mouse => window.startSystemResize(Qt.LeftEdge)
    // }

    // MouseArea {
    //     id: rightEdge
    //     z: 10
    //     anchors.right: parent.right
    //     anchors.top: parent.top
    //     anchors.bottom: parent.bottom
    //     width: 6
    //     cursorShape: Qt.SizeHorCursor
    //     onPressed: mouse => window.startSystemResize(Qt.RightEdge)
    // }

    // MouseArea {
    //     id: topRightCorner
    //     z: 100
    //     width: 12; height: 12
    //     anchors.top: parent.top
    //     anchors.left: parent.left
    //     cursorShape: Qt.SizeFDiagCursor
    //     onPressed: mouse => window.startSystemResize(Qt.BottomRightCorner)
    // }

    // MouseArea {
    //     id: topLeftCorner
    //     z: 100
    //     width: 12; height: 12
    //     anchors.top: parent.top
    //     anchors.right: parent.right
    //     cursorShape: Qt.SizeBDiagCursor
    //     onPressed: mouse =>{ window.startSystemResize(Qt.RightEdge); window.startSystemResize(Qt.TopEdge)}
    // }

    // MouseArea {
    //     id: bottomLeftCorner
    //     z: 100
    //     width: 12; height: 12
    //     anchors.bottom: parent.bottom
    //     anchors.left: parent.left
    //     cursorShape: Qt.SizeBDiagCursor
    //     onPressed: mouse => window.startSystemResize(Qt.TopLeftCorner)
    // }

    // MouseArea {
    //     id: bottomRightCorner
    //     z: 100
    //     width: 12; height: 12
    //     anchors.bottom: parent.bottom
    //     anchors.right: parent.right
    //     cursorShape: Qt.SizeFDiagCursor
    //     onPressed: mouse => window.startSystemResize(Qt.TopRightCorner)
    // }
}
