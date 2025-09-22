import QtQuick 2.15
import QtQuick.Controls.Basic
import '../component_library/style' as Style
import '../component_library/button'
import "./components"

Rectangle {
    id: root
    width: 200
    anchors.top: parent.top; anchors.bottom: parent.bottom
    color: window.isDesktopSize? "#00ffffff": Style.Colors.background

    Item{
        id: appInfoId
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 60
        Label {
            id: textId
            visible: root.width>100
            color: Style.Colors.textTitle
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 15
            text: "Settings"
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

         SettingsMenuButton{
            id: themeItemMenu
            myText: "Theme"
            myToolTipText: "Theme"
            myIcon: "qrc:/media/icon/colorPalette.svg"
            myFillIcon: "qrc:/media/icon/colorPaletteFill.svg"
            checked: true
            autoExclusive: true
            numberPage:0

            Connections {
                target: themeItemMenu
                function onClicked(){
                    settingsBodyId.currentIndex = 0
                }
            }
        }

        SettingsMenuButton {
            id: speechItemMenu
            myText: "Speech"
            myToolTipText: "Speech"
            myIcon: "qrc:/media/icon/speaker.svg"
            myFillIcon: "qrc:/media/icon/speakerFill.svg"
            autoExclusive: true
            numberPage:1

            Connections {
                target: speechItemMenu
                function onClicked(){
                    settingsBodyId.currentIndex = 1
                }
            }
        }

        SettingsMenuButton {
            id: terms_of_UseItemMenu
            myText: "Terms of Use"
            myToolTipText: "Terms_of_Use"
            myIcon: "qrc:/media/icon/terms_of_Use.svg"
            myFillIcon: "qrc:/media/icon/terms_of_UseFill.svg"
            autoExclusive: true
            numberPage:2

            Connections {
                target: terms_of_UseItemMenu
                function onClicked(){
                    settingsBodyId.currentIndex = 2
                }
            }
        }

        SettingsMenuButton {
            id: privacyItemMenu
            myText: "Privacy"
            myToolTipText: "Privacy"
            myIcon: "qrc:/media/icon/privacy.svg"
            myFillIcon: "qrc:/media/icon/privacyFill.svg"
            autoExclusive: true
            numberPage:3

            Connections {
                target: privacyItemMenu
                function onClicked(){
                    settingsBodyId.currentIndex = 3
                }
            }
        }

        SettingsMenuButton {
            id: aboutItemMenu
            myText: "About"
            myToolTipText: "About"
            myIcon: "qrc:/media/icon/about.svg"
            myFillIcon: "qrc:/media/icon/aboutFill.svg"
            autoExclusive: true
            numberPage:4

            Connections {
                target: aboutItemMenu
                function onClicked(){
                    settingsBodyId.currentIndex = 4
                }
            }
        }
    }

    Item{
        id: asettingsAndNameId
        anchors.left: parent.left; anchors.leftMargin: 10
        anchors.right: parent.right; anchors.rightMargin: 10
        anchors.bottom: parent.bottom; anchors.bottomMargin: 10

        height: 40
        MyIcon {
            id: settingsIcon
            width: 30; height: 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            myIcon: "qrc:/media/icon/log.svg"
            myTextToolTip: "Log"
            myWidthToolTip: 60
            toolTipInCenter: true
            iconType: Style.RoleEnum.IconType.Primary
            onClicked: {
                Qt.openUrlExternally("file:///" + Logger.logDir)
            }
        }
    }

    Rectangle{
        id:line
        width: 1; height: parent.height
        color: Style.Colors.boxBorder
        anchors.right: parent.right
    }

    function setShowSelectMenu(){
        if(settingsBodyId.currentIndex === 0)
            return themeItemMenu.y + appInfoId.height
        if(settingsBodyId.currentIndex === 1)
            return speechItemMenu.y + appInfoId.height
        if(settingsBodyId.currentIndex === 2)
            return terms_of_UseItemMenu.y + appInfoId.height
        if(settingsBodyId.currentIndex === 3)
            return privacyItemMenu.y + appInfoId.height
        if(settingsBodyId.currentIndex === 4)
            return aboutItemMenu.y + appInfoId.height
        return homeItemMenu.y + appInfoId.height
    }

    Rectangle{
        id: showSelectMenuId
        color: Style.Colors.menuShowCheckedRectangle
        height: themeItemMenu.height
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
