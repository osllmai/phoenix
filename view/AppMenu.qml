import QtQuick 2.15
import QtQuick.Controls.Basic
import './component_library/style' as Style
import './component_library/button'
import "./menu"

Rectangle{
    id: root
    width: 200
    anchors.top: parent.top;
    anchors.bottom: parent.bottom;

    color: Style.Colors.menu

    property bool isDrawer: false

    Column {
        id: columnId
        anchors.left: parent.left
        anchors.right:parent.right
        anchors.top: /*appInfoId.bottom*/parent.top
        anchors.topMargin: 10
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
                    if(isDrawer && appBodyId.currentIndex !== 0){
                        drawerId.close()
                    }
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
                    if(isDrawer && appBodyId.currentIndex !== 1){
                        drawerId.close()
                    }
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
                    if(isDrawer && appBodyId.currentIndex !== 2){
                        drawerId.close()
                    }
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
                    if(isDrawer && appBodyId.currentIndex !== 3){
                        drawerId.close()
                    }
                    appBodyId.currentIndex = 3
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
            text: "v" + updateChecker.currentVersion + "-2025.08.04"
            font.weight: 400
            font.pixelSize: 10
            font.styleName: "Bold"
            clip: true
        }
    }

    SettingsDialog{
        id:settingsDialogId
    }

    function setShowSelectMenu(){
        if(appBodyId.currentIndex === 0)
            return homeItemMenu.y + 10 + 2
        if(appBodyId.currentIndex === 1)
            return chatItemMenu.y + 10 + 2
        if(appBodyId.currentIndex === 2)
            return modelsItemMenu.y + 10 + 2
        if(appBodyId.currentIndex === 3)
            return devloperItemMenu.y + 10 + 2
        return homeItemMenu.y + 10 + 2
    }

    Rectangle{
        id: showSelectMenuId
        color: Style.Colors.menuShowCheckedRectangle
        height: homeItemMenu.height - 5
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

