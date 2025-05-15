import QtQuick 2.15
import QtQuick.Controls.Basic
import './component_library/style' as Style
import './component_library/button'
import "./menu"

Rectangle{
    id: root
    width: 200
    anchors.top: parent.top; anchors.bottom: parent.bottom

    color: Style.Colors.menu

    Item{
        id: appInfoId
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 60
        ToolButton {
            id: phoenixIconId
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            background: null
            icon{
                source: "qrc:/media/icon/phoenix.svg"
                color: Style.Colors.menuHoverAndCheckedIcon;
                width:24; height:24
            }
        }
        Label {
            id: textId
            visible: root.width>100
            color: Style.Colors.textTitle
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: phoenixIconId.right
            anchors.leftMargin: 2
            text: "Phoenix"
            font.weight: 400
            font.pixelSize: 20
            font.styleName: "Bold"
            clip: true
        }
    }

    Column {
        id: columnId
        anchors.left: parent.left
        anchors.right:parent.right
        anchors.top: appInfoId.bottom
        anchors.topMargin: 0
        spacing: 5
        clip:true

        MyMenuButton {
            id: homeItemMenu
            myText: "Home"
            myToolTipText: "Home"
            myIcon: "qrc:/media/icon/home.svg"
            myFillIcon: "qrc:/media/icon/homeFill.svg"
            checked: true
            autoExclusive: true
            numberPage:0

            Connections {
                target: homeItemMenu
                function onClicked(){
                    appBodyId.currentIndex = 0
                }
            }
        }

        MyMenuButton {
            id: chatItemMenu
            myText: "Chat"
            myToolTipText: "Chat"
            myIcon: "qrc:/media/icon/chat.svg"
            myFillIcon: "qrc:/media/icon/chatFill.svg"
            autoExclusive: true
            numberPage:1

            Connections {
                target: chatItemMenu
                function onClicked(){
                    appBodyId.currentIndex = 1
                }
            }
        }

        MyMenuButton {
            id: modelsItemMenu
            myText: "Models"
            myToolTipText: "Models"
            myIcon: "qrc:/media/icon/model.svg"
            myFillIcon: "qrc:/media/icon/modelFill.svg"
            autoExclusive: true
            numberPage:2

            Connections {
                target: modelsItemMenu
                function onClicked(){
                    appBodyId.currentIndex = 2
                }
            }
        }
        MyMenuButton {
            id: devloperItemMenu
            myText: "Devloper"
            myToolTipText: "Devloper"
            myIcon: "qrc:/media/icon/developer.svg"
            myFillIcon: "qrc:/media/icon/developerFill.svg"
            autoExclusive: true
            numberPage:3

            Connections {
                target: devloperItemMenu
                function onClicked(){
                    appBodyId.currentIndex = 3
                }
            }
        }
    }

    Item{
        id: asettingsAndNameId
        anchors.left: parent.left; anchors.leftMargin: 10
        anchors.right: parent.right; anchors.rightMargin: 10
        anchors.bottom: parent.bottom;

        height: 80
        MyIcon {
            id: settingsIcon
            width: 36; height: 36
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            myIcon: settingsIcon.hovered? "qrc:/media/icon/settingsFill.svg": "qrc:/media/icon/settings.svg"
            myTextToolTip: "Settings"
            myWidthToolTip: 60
            toolTipInCenter: true
            iconType: Style.RoleEnum.IconType.Primary
            onClicked: { settingsDialogId.open(); }
        }
        Label {
            id: versionName
            visible: root.width>100
            color: Style.Colors.textTitle
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: settingsIcon.right
            anchors.leftMargin: 2
            text: "v0.1.1-2025.05.03"
            font.weight: 400
            font.pixelSize: 10
            font.styleName: "Bold"
            clip: true
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    aboutVersion.open()
                }
            }
        }
    }

    VerificationDialog {
        id: aboutVersion
        height: 230
        width: 365
        titleText: "Phoenix"
        about: "Version: 0.1.1 (user setup)
Commit: 5ab0775a1b6ff560452f041b2043c3d7d70fe1ba
Date: 2025.05.03
OS: Windows x64
"
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

    SettingsDialog{
        id:settingsDialogId
    }

    function setShowSelectMenu(){
        if(appBodyId.currentIndex === 0)
            return homeItemMenu.y + appInfoId.height
        if(appBodyId.currentIndex === 1)
            return chatItemMenu.y + appInfoId.height
        if(appBodyId.currentIndex === 2)
            return modelsItemMenu.y + appInfoId.height
        if(appBodyId.currentIndex === 3)
            return devloperItemMenu.y + appInfoId.height
        return homeItemMenu.y + appInfoId.height
    }

    Rectangle{
        id: showSelectMenuId
        color: Style.Colors.menuShowCheckedRectangle
        height: homeItemMenu.height
        width: 3
        anchors.left: parent.left
        anchors.leftMargin: 10
        radius: 300
        y: setShowSelectMenu()

        Behavior on y{
            NumberAnimation{
                duration: 200
            }
        }
    }
}

