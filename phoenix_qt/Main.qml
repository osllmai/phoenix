import QtQuick 6.7
import QtCore
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects

import QtQuick.Layouts
import Phoenix 
import 'style' as Style


ApplicationWindow {
    id: window

    width: 1229
    height: 685
    minimumWidth: 450
    minimumHeight: 600

    property int pixelSizeText1: 10
    property int pixelSizeText2: 12
    property int pixelSizeText3: 14
    property int pixelSizeText4: 16

    property var theme: Style.Theme.theme

    onThemeChanged:{
        systemMonitorIcon.normalColor = Style.Theme.menuIconColor
        systemMonitorText.color=Style.Theme.informationTextColor
    }

    visible: true
    title: qsTr("Phoenix")

    Settings{
        category: "window"
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
        // property alias theme: Style.Theme.theme
        // property alias fontFamily: Style.Theme.fontFamily
    }

    PhoenixController{
        id: phoenixController
    }

    Rectangle {
        id: phoenix
        anchors.fill: parent
        color: Style.Theme.backgroungColor

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
                    menuIconColor: Style.Theme.fillIconColor
                    iconColor: Style.Theme.menuIconColor
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
                    menuIconColor: Style.Theme.fillIconColor
                    iconColor: Style.Theme.menuIconColor
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
                    menuIconColor: Style.Theme.fillIconColor
                    iconColor: Style.Theme.menuIconColor
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
                    myTextId: Style.Theme.theme === "light"? "Dark": "Light"
                    myLable: Style.Theme.theme === "light"? "Dark": "Light"
                    myIconId: Style.Theme.theme === "light"? "images/moonIcon.svg" : "images/sunIcon.svg"
                    myFillIconId: Style.Theme.theme === "light"?  "images/fillMoonIcon.svg": "images/fillSunIcon.svg"
                    menuIconColor: Style.Theme.fillIconColor
                    iconColor: Style.Theme.menuIconColor
                    Connections {
                        target: lightDarkItemMenu
                        function onClicked(){
                            if(Style.Theme.theme === "light"){
                                Style.Theme.theme = "dark"
                            }else{
                                Style.Theme.theme = "light"
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
                    menuIconColor: Style.Theme.fillIconColor
                    iconColor: Style.Theme.menuIconColor
                    Connections {
                        target: settingsItemMenu
                        function onClicked() {
                            settingsId.openDialog()
                        }
                    }

                    SettingsDialog {
                        id: settingsId
                        onSettingsDialogAccepted: page.currentIndex = 2

                        Connections{
                            target: settingsId
                            function onThemeRequested1(myTheme){
                                Style.Theme.theme = myTheme
                            }
                            function onFontSizeRequested1(myFontSize){

                            }
                            function onFontFamilyRequested1(myFontFamily){
                                Style.Theme.fontFamily = myFontFamily
                            }
                        }
                    }
                }
            }

            Rectangle{
                id: showSelectMenuId
                color: Style.Theme.fillIconColor
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
                color: Style.Theme.backgroundPageColor

                HomePage {
                    id: homePageId

                    height: parent.height
                    width: parent.width

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
                color: Style.Theme.backgroundPageColor

                ChatPage {
                    id: chatPageId

                    height: parent.height
                    width: parent.width
                    chatListModel: phoenixController.chatListModel
                    currentChat: phoenixController.chatListModel.currentChat
                    chatModel: phoenixController.chatListModel.currentChat.chatModel
                    modelListModel: phoenixController.modelList.currentModelList

                    Connections{
                        target: chatPageId
                        function onGoToModelPage(){
                            modelsItemMenu.clicked()
                            modelsItemMenu.checked = true
                        }
                        function onLoadModelInCurrentChat(index){
                            phoenixController.addModelToCurrentChat(index)
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
                color: Style.Theme.backgroundPageColor

                ModelsPage {
                    id:modelsPageId
                    height: parent.height
                    width: parent.width
                    modelListModel: phoenixController.modelList
                }
            }
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
                normalColor: Style.Theme.menuIconColor
                hoverColor:Style.Theme.fillIconColor
                xPopup: -18
                yPopup: -40
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
                normalColor:Style.Theme.menuIconColor
                hoverColor:Style.Theme.fillIconColor
                xPopup: -15
                yPopup: -40
                Connections {
                    target: githubIcon
                    function onActionClicked(){
                        Qt.openUrlExternally("https://github.com/osllmai")
                    }
                }
            }

            Rectangle {
                id: systemMonitorId
                width: window.width> 700? systemMonitorIcon.width + systemMonitorText.width + 10 : systemMonitorIcon.width
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
                    myIconId: "images/systemMonitorIcon.svg"
                    myFillIconId: "images/systemMonitorIcon.svg"
                    heightSource: 19
                    widthSource: 19
                    normalColor:Style.Theme.menuIconColor
                    hoverColor:Style.Theme.fillIconColor
                    havePupup: false
                }
                Text {
                    id: systemMonitorText
                    text: qsTr("System Monitor")
                    color: Style.Theme.informationTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    font.family: Style.Theme.fontFamily
                    visible: window.width> 700?true:false
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onHoveredChanged: function(){
                        if(containsMouse){
                            phoenixController.setIsSystemMonitor(true)
                            systemMonitorPupup.open()
                            systemMonitorIcon.normalColor = Style.Theme.fillIconColor
                            systemMonitorText.color= Style.Theme.fillIconColor
                        }else{
                            phoenixController.setIsSystemMonitor(false)
                            systemMonitorPupup.close()
                            systemMonitorIcon.normalColor = Style.Theme.menuIconColor
                            systemMonitorText.color=Style.Theme.informationTextColor
                        }
                    }
                }
            }

            Popup {
                id: systemMonitorPupup
                width: 180
                height: 70
                x: systemMonitorId.x -50
                y: systemMonitorId.y-80

                background:Rectangle{
                    color: Style.Theme.backgroungColor
                    radius: 4
                    anchors.fill: parent

                    Rectangle{
                        id:systemMonitorRec
                        anchors.fill: parent
                        color: "#ffffff"
                        radius: 4
                        border.color: "#cbcbcb"

                        Rectangle {
                            id: cpuRec
                            height: 30
                            color: "#00ffffff"
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: 7
                            anchors.topMargin: 2

                            Text {
                                id: cpuText
                                text: qsTr("CPU")
                                width: memoryText.width
                                color: "black"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 0
                                font.pointSize: 9
                                font.family: Style.Theme.fontFamily
                            }
                            ProgressBar {
                                id: progressBarCPU
                                width: 100
                                height: 6
                                value: phoenixController.cpuInfo/100
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: cpuText.right
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
                                        width: progressBarCPU.visualPosition * parent.width
                                        height: 6
                                        radius: 2
                                        color: "#047eff"
                                        border.color: "#047eff"
                                        border.width: 2
                                    }
                                }
                            }
                            Text {
                                id: progressBarTextCPU
                                text: "%" + phoenixController.cpuInfo
                                color: "black"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: progressBarCPU.right
                                anchors.leftMargin: 5
                                font.pixelSize: 9
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.family: Style.Theme.fontFamily
                            }
                        }
                        Rectangle {
                            id: memoryRec
                            height: 30
                            color: "#00ffffff"
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.leftMargin: 7
                            anchors.bottomMargin: 2

                            Text {
                                id: memoryText
                                text: qsTr("Memory")
                                color: "black"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 0
                                font.pointSize: 9
                                font.family: Style.Theme.fontFamily
                            }
                            ProgressBar {
                                id: progressBarMemory
                                width: 100
                                height: 6
                                value: phoenixController.memoryInfo /100
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: memoryText.right
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
                                        width: progressBarMemory.visualPosition * parent.width
                                        height: 6
                                        radius: 2
                                        color: "#047eff"
                                        border.color: "#047eff"
                                        border.width: 2
                                    }
                                }
                            }
                            Text {
                                id: progressBarTextMemory
                                text: "%" + phoenixController.memoryInfo
                                color: "black"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: progressBarMemory.right
                                anchors.leftMargin: 5
                                font.pixelSize: 9
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.family: Style.Theme.fontFamily
                            }
                        }
                        layer.enabled: true
                        layer.effect: Glow {
                             samples: 30
                             color: "#cbcbcb"
                             spread: 0.3
                             transparentBorder: true
                         }
                    }
                }
            }

            Rectangle {
                id: executionTimeId
                width: 130
                color: "#00ffffff"
                anchors.left: aboutDownloadId.visible === true? aboutDownloadId.right: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                visible:phoenixController.chatListModel.currentChat.responseInProgress

                Text {
                    id: executionTimeText
                    text: qsTr("Execution time: ")
                    color: Style.Theme.informationTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    font.pointSize: 8
                    font.family: Style.Theme.fontFamily
                }
                Text {
                    id: executionTimeValue
                    text: phoenixController.chatListModel.currentChat.valueTimer + "s"
                    color: Style.Theme.informationTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: executionTimeText.right
                    anchors.leftMargin: 3
                    font.pointSize: 8
                    font.family: Style.Theme.fontFamily
                }
            }

            Rectangle {
                id: aboutDownloadId
                width: downloadIcon.width+(window.width> 700?currentDownloadText.width:0)+progressBarDownload.width+ progressBarTextDownload.width + 15
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
                    normalColor:Style.Theme.menuIconColor
                    hoverColor:Style.Theme.menuIconColor
                    havePupup: false
                    Connections {
                        target: downloadIcon
                        function onActionClicked() {}
                    }
                }
                Text {
                    id: currentDownloadText
                    text: qsTr("Downloading model")
                    color: Style.Theme.informationTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: progressBarDownload.left
                    anchors.rightMargin: 5
                    font.pointSize: 8
                    font.family: Style.Theme.fontFamily
                    visible: window.width> 700?true:false
                }
                ProgressBar {
                    id: progressBarDownload
                    width: 100
                    height: 6
                    value: phoenixController.modelList.downloadProgress/100
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: progressBarTextDownload.left
                    anchors.rightMargin: 5
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
                            width: progressBarDownload.visualPosition * parent.width
                            height: 6
                            radius: 2
                            color: "#047eff"
                            border.color: "#047eff"
                            border.width: 2
                        }
                    }
                }
                property int downloadValue: (progressBarDownload.value * 100)
                Text {
                    id: progressBarTextDownload
                    text: "%" + aboutDownloadId.downloadValue
                    color: Style.Theme.informationTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    font.pixelSize: 8
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: Style.Theme.fontFamily
                }
            }
        }
    }

}
