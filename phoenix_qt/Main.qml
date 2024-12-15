import QtQuick 6.7
import QtCore
import QtQuick.Controls.Basic

// import QtQuick.Controls 6.7
import QtQuick.Layouts
import Phoenix
import 'workflow' as Workflow

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

    property bool isTheme

    function onIsThemeChanged(){
        console.log(" pl pl plp")
    }


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

            ColumnLayout {
                id: column
                anchors{
                    topMargin: 10
                    fill: parent
                }

                MyMenuItem {
                    id: homeItemMenue
                    myTextId: "Home"
                    myLable: "Home"
                    myIconId: "images/homeIcon.svg"
                    myFillIconId: "images/fillHomeIcon.svg"
                    fontFamily: window.fontFamily
                    menuIconColor: window.fillIconColor
                    iconColor: window.menuIconColor
                    checked: true
                    autoExclusive: true

                    Layout.fillWidth: true
                    Layout.preferredHeight: width

                    Connections {
                        target: homeItemMenue
                        function onClicked(){
                            page.currentIndex = 0
                            showSelectMenuId.selectedButton = homeItemMenue
                        }
                    }
                }

                MyMenuItem {
                    id: chatItemMenue
                    myTextId: "Chat"
                    myLable: "Chat"
                    myIconId: "images/chatIcon.svg"
                    myFillIconId: "images/fillChatIcon.svg"
                    fontFamily: window.fontFamily
                    menuIconColor: window.fillIconColor
                    iconColor: window.menuIconColor
                    autoExclusive: true

                    Layout.fillWidth: true
                    Layout.preferredHeight: width

                    Connections {
                        target: chatItemMenue
                        function onClicked(){
                            page.currentIndex = 1
                            showSelectMenuId.selectedButton = chatItemMenue
                        }
                    }
                }

                MyMenuItem {
                    id: modelsItemMenu
                    myTextId: "Models"
                    myLable: "Models"
                    myIconId: "images/modelIcon.svg"
                    myFillIconId: "images/fillModelIcon.svg"
                    fontFamily: window.fontFamily
                    menuIconColor: window.fillIconColor
                    iconColor: window.menuIconColor
                    autoExclusive: true

                    Layout.fillWidth: true
                    Layout.preferredHeight: width

                    Connections {
                        target: modelsItemMenu
                        function onClicked(){
                            page.currentIndex = 2
                            showSelectMenuId.selectedButton = modelsItemMenu
                        }
                    }
                }

                MyMenuItem {
                    myTextId: "Workflow"
                    myLable: "Workflow"
                    myIconId: "images/modelIcon.svg"
                    myFillIconId: "images/fillModelIcon.svg"
                    fontFamily: window.fontFamily
                    menuIconColor: window.fillIconColor
                    iconColor: window.menuIconColor
                    autoExclusive: true

                    Layout.fillWidth: true
                    Layout.preferredHeight: width

                    onClicked: {
                        page.currentIndex = 3
                        showSelectMenuId.selectedButton = this
                    }
                }

                Item { Layout.fillHeight: true }

                MyMenuButtonItem {
                    id: lightDarkItemMenu

                    myTextId: window.theme === "light"? "Dark": "Light"
                    myLable: window.theme === "light"? "Dark": "Light"
                    myIconId: window.theme === "light"? "images/moonIcon.svg" : "images/sunIcon.svg"
                    myFillIconId: window.theme === "light"?  "images/fillMoonIcon.svg": "images/fillSunIcon.svg"
                    fontFamily: window.fontFamily
                    menuIconColor: window.fillIconColor
                    iconColor: window.menuIconColor

                    Layout.fillWidth: true
                    Layout.preferredHeight: width

                    Connections {
                        target: lightDarkItemMenu
                        function onClicked(){
                            if(window.theme === "light"){
                                window.theme = "dark"
                                window.isTheme = true
                            }else{
                                window.theme = "light"
                                window.isTheme = false
                            }
                        }
                    }
                }

                MyMenuButtonItem {
                    id: settingsItemMenu
                    myTextId: "Settings"
                    myLable: "Settings"
                    myIconId: "images/settingsIcon.svg"
                    myFillIconId: "images/fillSettingsIcon.svg"
                    fontFamily: window.fontFamily
                    menuIconColor: window.fillIconColor
                    iconColor: window.menuIconColor

                    Layout.fillWidth: true
                    Layout.preferredHeight: width

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
                height: selectedButton.height
                width: 2
                anchors.left: parent.left
                anchors.leftMargin: 2

                visible: selectedButton !== null
                y: selectedButton ? selectedButton.y : 0

                property Item selectedButton: selectedButton

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

                    // isTheme: window.isTheme
                    Connections{
                        target: chatPageId
                        function onGoToModelPage(){
                            console.log(" hi dear");
                            modelsItemMenu.clicked()
                            modelsItemMenu.checked = true
                        }
                    }
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

            Workflow.WorkFlowsPartPage {}
        }

        states: [
            State {
                name: "clicked"
            }
        ]

        Rectangle{
            id: rightRecId
            color: parent.color
            anchors.left: page.right
            anchors.right: parent.right
            anchors.top: topRecId.bottom
            anchors.bottom: bottomRecId.top
        }

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
                myLable: "Discord"
                heightSource: 22
                widthSource: 22
                normalColor: window.menuIconColor
                hoverColor:window.fillIconColor
                xPopup: -18
                yPopup: -30
                Connections {
                    target: discordIcon
                    function onActionClicked(){
                        Qt.openUrlExternally("https://discord.gg/pufX5Aua2g")
                    }
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
                myLable: "Github"
                heightSource: 18
                widthSource: 18
                normalColor:window.menuIconColor
                hoverColor:window.fillIconColor
                xPopup: -15
                yPopup: -30
                Connections {
                    target: githubIcon
                    function onActionClicked(){
                        Qt.openUrlExternally("https://github.com/osllmai")
                    }
                }
            }

            Rectangle {
                id: systemMonitorId
                width: 130
                color: "#00ffffff"
                anchors.right: githubIcon.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0

                MyIcon {
                    id: systemMonitorIcon
                    visible: true
                    width: 30
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 0
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                    myIconId: "images./githubIcon.svg"
                    myFillIconId: "images./githubIcon.svg"
                    heightSource: 18
                    widthSource: 18
                    normalColor:window.menuIconColor
                    hoverColor:window.fillIconColor
                    havePupup: false
                }
                Text {
                    id: systemMonitorText
                    text: qsTr("System Monitor")
                    color: window.informationTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: systemMonitorIcon.right
                    anchors.leftMargin: 0
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onHoveredChanged: function(){
                        // if(containsMouse){
                        //     systemMonitorPupup.open()
                        //     systemMonitorIcon.normalColor = window.fillIconColor
                        //     systemMonitorText.color= window.fillIconColor
                        // }else{
                        //     systemMonitorPupup.close()
                        //     systemMonitorIcon.normalColor = window.menuIconColor
                        //     systemMonitorText.color=window.informationTextColor
                        // }
                    }
                }
            }

            Popup {
                id: systemMonitorPupup
                width: 350
                height: 180
                x: systemMonitorId.x -200
                y: systemMonitorId.y-180

                background:Rectangle{
                    color: "#00ffffff" // Background color of tooltip
                    radius: 4
                    anchors.fill: parent
                    Rectangle{
                        radius: 4
                        anchors.fill: parent
                        gradient: Gradient {
                            GradientStop {
                                position: 0
                                color: "#d4afff"
                            }

                            GradientStop {
                                position: 1
                                color: "#fbc2eb"
                            }
                            orientation: Gradient.Vertical
                        }
                        SpeedDisplay {
                            anchors.top: parent.top
                            anchors.left:parent.left
                            anchors.topMargin: 20
                            anchors.leftMargin: 20
                            kplDisplay: 100
                            kphDisplay: 50
                            kphFrame: 110
                        }
                        SpeedDisplay {
                            anchors.top: parent.top
                            anchors.right:parent.right
                            anchors.topMargin: 20
                            anchors.rightMargin: 20
                            kplDisplay: 100
                            kphDisplay: 50
                            kphFrame: 110
                        }
                    }
                }
            }


            Rectangle {
                id: executionTimeId
                width: 130
                color: "#00ffffff"
                anchors.left: numberOfTokenId.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0

                Text {
                    id: executionTimeText
                    text: qsTr("Execution time: ")
                    color: window.informationTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    font.pointSize: 8
                }
                Text {
                    id: executionTimeValue
                    text: phoenixController.chatListModel.currentChat.valueTimer
                    color: window.informationTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: executionTimeText.right
                    anchors.leftMargin: 3
                    font.pointSize: 8
                }
            }

            Rectangle {
                id: numberOfTokenId
                width: 130
                color: "#00ffffff"
                anchors.left: currentDownloadId.visible === true? currentDownloadId.right: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0

                Text {
                    id: numberOfTokenText
                    text: qsTr("Number of tokens: ")
                    color: window.informationTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    font.pointSize: 8
                }
                Text {
                    id: numberOfTokenValue
                    text: qsTr("50")
                    color: window.informationTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: numberOfTokenText.right
                    anchors.leftMargin: 3
                    font.pointSize: 8
                }
            }

            Rectangle {
                id: currentDownloadId
                width: 290
                color: "#00ffffff"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                visible: (phoenixController.modelList.downloadProgress === 0)? false: true

                MyIcon {
                    id: downloadIcon
                    visible: true
                    width: 30
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 0
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                    myIconId: "images/downloadIcon.svg"
                    myFillIconId: "images/downloadIcon.svg"
                    heightSource: 18
                    widthSource: 18
                    normalColor:window.menuIconColor
                    hoverColor:window.menuIconColor
                    havePupup: false
                    Connections {
                        target: downloadIcon
                        function onActionClicked() {}
                    }
                }
                Text {
                    id: currentDownloadText
                    text: qsTr("Downloading model")
                    color: window.informationTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: downloadIcon.right
                    anchors.leftMargin: 0
                    font.pointSize: 8
                }
                ProgressBar {
                    id: progressBar
                    width: 100
                    height: 6
                    value: phoenixController.modelList.downloadProgress/100
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: currentDownloadText.right
                    anchors.leftMargin: 5
                    background: Rectangle {
                        color: "#c0c0c0"
                        implicitHeight: 6
                        radius: 2
                        border.color: "#c0c0c0"
                        border.width: 2
                    }

                    contentItem: Item {
                        implicitHeight: 6
                        Rectangle {
                            width: progressBar.visualPosition * parent.width
                            height: 6
                            radius: 2
                            color: "#047eff"
                            border.color: "#047eff"
                            border.width: 2
                        }
                    }
                }
                Text {
                    id: cancleText
                    text: "%" + (progressBar.value * 100)
                    color: window.informationTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: progressBar.right
                    anchors.leftMargin: 5
                    font.pixelSize: fontSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: fontFamily
                }
            }


        }
    }
}
