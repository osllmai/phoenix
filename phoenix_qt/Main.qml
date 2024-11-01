import QtQuick 6.7
import QtCore
import QtQuick.Controls.Basic

// import QtQuick.Controls 6.7
import QtQuick.Layouts
import Phoenix


Window {
    id: window

    width: 1229
    height: 685

    property var theme: "light"

    //dark theme
    property color darkBackgroundPage: "#242424"
    property color darkBackgroung: "#1f1f1f"
    property color darkGlow: /*"#d7d7d7"*/  "#1f1f1f"
    property color darkBox: /*"#1f1f1f"*/  "#333333"
    property color darkHeader: "#333333"
    property color darkNormalButton:/* "#242424"*/ "#333333"
    property color darkSelectButton:/* "#57b9fc"*/ "#1f1f1f"
    property color darkHoverButton: "#5f5f5f"
    property color darkFillIcon:  "#5b5fc7" /* "#57b9fc"*/
    property color darkMenuIcon:/* "#57b9fc"*/  "#ffffff"
    property color darkIcon: "#ffffff"

    property color darkInformationText: "#ffffff"
    property color darkTitleText: "#cbcdff"
    property color darkSelectText: "#000000"


    //dark theme for chat page
    property color darkChatBackgroung: "#242424"
    property color darkChatBackgroungConverstation: "#333333"
    property color darkChatMessageBackgroung:"#333333"
    property color darkChatMessageTitleText: "#cbcdff"
    property color darkChatMessageInformationText: "#ffffff"
    property bool darkChatMessageIsGlow: true


    //light theme
    property color lightBackgroundPage: "#ffffff"
    property color lightBackgroung: "#ebebeb"
    property color lightGlow: "#d7d7d7"
    property color lightBox: /*"#ebebeb"*/  "#f5f5f5"
    property color lightHeader: "#f5f5f5"
    property color lightNormalButton: "#f5f5f5"
    property color lightSelectButton: "#ffffff"
    property color lightHoverButton: "#ffffff"
    property color lightFillIcon: "#5b5fc7"
    property color lightMenuIcon: "#747474"
    property color lightIcon: "#5b5fc7"

    property color lightTitleText: "#000000"
    property color lightInformationText: "#474747"
    property color lightSelectText: "#000000"


    //light theme for chat page
    property color lightChatBackgroung: "#f5f5f5"
    property color lightChatBackgroungConverstation: "#ffffff"
    property color lightChatMessageBackgroung: "#ebebeb"
    property color lightChatMessageTitleText: "#474747"
    property color lightChatMessageInformationText: "#000000"
    property bool lightChatMessageIsGlow: false


    //general
    property color backgroundPageColor: theme == "light"? lightBackgroundPage: darkBackgroundPage
    property color backgroungColor: theme == "light"? lightBackgroung: darkBackgroung
    property color glowColor: theme == "light"? lightGlow: darkGlow
    property color boxColor: theme == "light"? lightBox: darkBox
    property color headerColor: theme == "light"? lightHeader: darkHeader
    property color normalButtonColor: theme == "light"? lightNormalButton: darkNormalButton
    property color selectButtonColor: theme == "light"? lightSelectButton: darkSelectButton
    property color hoverButtonColor: theme == "light"? lightHoverButton: darkHoverButton
    property color fillIconColor: theme == "light"? lightFillIcon: darkFillIcon
    property color menuIconColor: theme == "light"? lightMenuIcon: darkMenuIcon
    property color iconColor: theme == "light"? lightIcon: darkIcon

    property color titleTextColor: theme == "light"? lightTitleText: darkTitleText
    property color informationTextColor: theme == "light"? lightInformationText: darkInformationText
    property color selectTextColor: theme == "light"? lightSelectText: darkSelectText

    //theme for chat page
    property color chatBackgroungColor: theme == "light"? lightChatBackgroung: darkChatBackgroung
    property color chatBackgroungConverstationColor: theme == "light"? lightChatBackgroungConverstation: darkChatBackgroungConverstation
    property color chatMessageBackgroungColor: theme == "light"? lightChatMessageBackgroung: darkChatMessageBackgroung
    property color chatMessageTitleTextColor: theme == "light"? lightChatMessageTitleText: darkChatMessageTitleText
    property color chatMessageInformationTextColor: theme == "light"? lightChatMessageInformationText: darkChatMessageInformationText
    property bool chatMessageIsGlow: theme == "light"?lightChatMessageIsGlow: darkChatMessageIsGlow


    property int pixelSizeText1: 10
    property int pixelSizeText2: 12
    property int pixelSizeText3: 14
    property int pixelSizeText4: 16

    property var fontFamily: "Times New Roman"


    visible: true
    title: qsTr("Phoenix")


    Settings{
        category: "window"
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
        property alias theme: window.theme
        property alias fontFamily: window.fontFamily
    }

    PhoenixController{
        id: phoenixController
    }

    Rectangle {
        id: phoenix
        anchors.fill: parent
        color: window.backgroungColor

        Rectangle {
            id: menuId
            width: 70
            height: phoenix.height
            color: "#00ffffff"

            Column {
                id: column
                anchors.fill: parent

                MyMenuItem {
                    id: homeItemMenue
                    anchors.top: parent.top
                    anchors.topMargin: 24
                    anchors.horizontalCenter: parent.horizontalCenter
                    myTextId: "Home"
                    myLable: "Home"
                    myIconId: "images/homeIcon.svg"
                    myFillIconId: "images/fillHomeIcon.svg"
                    fontFamily: window.fontFamily
                    menuIconColor: window.fillIconColor
                    iconColor: window.menuIconColor
                    checked: true
                    autoExclusive: true

                    Connections {
                        target: homeItemMenue
                        function onClicked(){
                            page.currentIndex = 0
                            showSelectMenuId.y = homeItemMenue.y -5
                        }
                    }
                }

                MyMenuItem {
                    id: chatItemMenue
                    anchors.top: homeItemMenue.bottom
                    anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    myTextId: "Chat"
                    myLable: "Chat"
                    myIconId: "images/chatIcon.svg"
                    myFillIconId: "images/fillChatIcon.svg"
                    fontFamily: window.fontFamily
                    menuIconColor: window.fillIconColor
                    iconColor: window.menuIconColor
                    autoExclusive: true

                    Connections {
                        target: chatItemMenue
                        function onClicked(){
                            page.currentIndex = 1
                            showSelectMenuId.y = chatItemMenue.y -5
                        }
                    }
                }

                MyMenuItem {
                    id: modelsItemMenu
                    anchors.top: chatItemMenue.bottom
                    anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    myTextId: "Models"
                    myLable: "Models"
                    myIconId: "images/modelIcon.svg"
                    myFillIconId: "images/fillModelIcon.svg"
                    fontFamily: window.fontFamily
                    menuIconColor: window.fillIconColor
                    iconColor: window.menuIconColor
                    autoExclusive: true

                    Connections {
                        target: modelsItemMenu
                        function onClicked(){
                            page.currentIndex = 2
                            showSelectMenuId.y = modelsItemMenu.y -5
                        }
                    }
                }

                MyMenuButtonItem {
                    id: lightDarkItemMenu
                    anchors.bottom: settingsItemMenu.top
                    anchors.bottomMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    myTextId: window.theme === "light"? "Dark": "Light"
                    myLable: window.theme === "light"? "Dark": "Light"
                    myIconId: window.theme === "light"? "images/moonIcon.svg" : "images/sunIcon.svg"
                    myFillIconId: window.theme === "light"?  "images/fillMoonIcon.svg": "images/fillSunIcon.svg"
                    fontFamily: window.fontFamily
                    menuIconColor: window.fillIconColor
                    iconColor: window.menuIconColor
                    Connections {
                        target: lightDarkItemMenu
                        function onClicked(){
                            if(window.theme === "light"){
                                window.theme = "dark"
                            }else{
                                window.theme = "light"
                            }
                        }
                    }
                }

                MyMenuButtonItem {
                    id: settingsItemMenu
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 24
                    anchors.horizontalCenter: parent.horizontalCenter
                    myTextId: "Settings"
                    myLable: "Settings"
                    myIconId: "images/settingsIcon.svg"
                    myFillIconId: "images/fillSettingsIcon.svg"
                    fontFamily: window.fontFamily
                    menuIconColor: window.fillIconColor
                    iconColor: window.menuIconColor
                    Connections {
                        target: settingsItemMenu
                        function onClicked() {
                            settingsId.openDialog()
                        }
                    }

                    SettingsDialog {
                        id: settingsId
                        onSettingsDialogAccepted: page.currentIndex = 2

                        theme: window.theme

                        backgroundPageColor: window.backgroundPageColor
                        backgroungColor: window.backgroungColor
                        glowColor: window.glowColor
                        boxColor: window.boxColor
                        headerColor: window.headerColor
                        normalButtonColor: window.normalButtonColor
                        selectButtonColor: window.selectButtonColor
                        hoverButtonColor: window.hoverButtonColor
                        fillIconColor: window.fillIconColor
                        iconColor: window.iconColor

                        titleTextColor: window.titleTextColor
                        informationTextColor: window.informationTextColor
                        selectTextColor: window.selectTextColor

                        fontFamily: window.fontFamily

                        Connections{
                            target: settingsId
                            function onThemeRequested1(myTheme){
                                window.theme = myTheme
                            }
                            function onFontSizeRequested1(myFontSize){

                            }
                            function onFontFamilyRequested1(myFontFamily){
                                window.fontFamily = myFontFamily
                            }
                        }
                    }
                }
            }

            Rectangle{
                id: showSelectMenuId
                color: window.fillIconColor
                height: 48
                width: 2
                anchors.left: parent.left
                anchors.leftMargin: 2
                y: homeItemMenue.y -5

                Behavior on y{
                    NumberAnimation{
                        duration: 200
                    }
                }
            }
        }
        StackLayout {
            id: page
            anchors.left: menuId.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.rightMargin: 30
            anchors.topMargin: 30
            anchors.bottomMargin: 30
            currentIndex: 0

            Rectangle {
                id: homePage
                width: page.width
                height: page.width
                radius: 4
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: window.backgroundPageColor

                HomePage {
                    id: homePageId

                    height: parent.height
                    width: parent.width

                    backgroundPageColor: window.backgroundPageColor
                    backgroungColor: window.backgroungColor
                    glowColor: window.glowColor
                    boxColor: window.boxColor
                    headerColor: window.headerColor
                    normalButtonColor: window.normalButtonColor
                    selectButtonColor: window.selectButtonColor
                    hoverButtonColor: window.hoverButtonColor
                    fillIconColor: window.fillIconColor
                    iconColor: window.iconColor

                    titleTextColor: window.titleTextColor
                    informationTextColor: window.informationTextColor
                    selectTextColor: window.selectTextColor

                    fontFamily: window.fontFamily

                    Connections{
                        target: homePageId
                        function onChatViewRequested1() {
                            chatItemMenue.clicked()
                            chatItemMenue.checked = true
                        }
                    }
                }
            }

            Rectangle {
                id: chatPage
                width: page.width
                height: page.width
                radius: 4
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: window.backgroundPageColor

                ChatPage {
                    id: chatPageId

                    height: parent.height
                    width: parent.width
                    chatListModel: phoenixController.chatListModel
                    currentChat: phoenixController.chatListModel.currentChat
                    chatModel: phoenixController.chatListModel.currentChat.chatModel
                    modelListModel: phoenixController.modelList.currentModelList

                    backgroungColor: window.backgroungColor
                    glowColor: window.glowColor
                    boxColor: window.boxColor
                    normalButtonColor: window.normalButtonColor
                    selectButtonColor: window.selectButtonColor
                    hoverButtonColor: window.hoverButtonColor
                    fillIconColor: window.fillIconColor
                    iconColor: window.iconColor

                    chatBackgroungColor: window.chatBackgroungColor
                    chatBackgroungConverstationColor: window.chatBackgroungConverstationColor
                    chatMessageBackgroungColor: window.chatMessageBackgroungColor
                    chatMessageTitleTextColor: window.chatMessageTitleTextColor
                    chatMessageInformationTextColor: window.chatMessageInformationTextColor
                    chatMessageIsGlow: window.chatMessageIsGlow

                    titleTextColor: window.titleTextColor
                    informationTextColor: window.informationTextColor
                    selectTextColor: window.selectTextColor

                    fontFamily: window.fontFamily

                }
            }

            Rectangle {
                id: modelsPage
                width: page.width
                height: page.width
                radius: 4
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: window.backgroundPageColor

                ModelsPage {
                    id:modelsPageId
                    height: parent.height
                    width: parent.width
                    modelListModel: phoenixController.modelList

                    backgroundPageColor: window.backgroundPageColor
                    backgroungColor: window.backgroungColor
                    glowColor: window.glowColor
                    boxColor: window.boxColor
                    headerColor: window.headerColor
                    normalButtonColor: window.normalButtonColor
                    selectButtonColor: window.selectButtonColor
                    hoverButtonColor: window.hoverButtonColor
                    fillIconColor: window.fillIconColor
                    iconColor: window.iconColor

                    titleTextColor: window.titleTextColor
                    informationTextColor: window.informationTextColor
                    selectTextColor: window.selectTextColor

                    fontFamily: window.fontFamily
                }
            }
        }

        states: [
            State {
                name: "clicked"
            }
        ]

        Rectangle{
            id: topRecId
            color: parent.color
            anchors.left: menuId.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: page.top
        }
        Rectangle{
            id: bottomRecId
            color: parent.color
            anchors.left: menuId.right
            anchors.right: parent.right
            anchors.top: page.bottom
            anchors.bottom: parent.bottom
            MyIcon {
                id: discordIcon
                visible: true
                width: 30
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 30
                anchors.topMargin: 0
                myIconId: "images/discordIcon.svg"
                myFillIconId: "images/discordIcon.svg"
                heightSource: 22
                widthSource: 22
                normalColor: window.menuIconColor
                hoverColor:window.fillIconColor
                Connections {
                    target: discordIcon
                    onClicked: function () {}
                }
            }
            MyIcon {
                id: githubIcon
                visible: true
                width: 30
                anchors.right: discordIcon.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 0
                anchors.topMargin: 0
                myIconId: "images./githubIcon.svg"
                myFillIconId: "images./githubIcon.svg"
                heightSource: 18
                widthSource: 18
                normalColor:window.menuIconColor
                hoverColor:window.fillIconColor
                Connections {
                    target: githubIcon
                    onClicked: function () {}
                }
            }
        }
    }
}
