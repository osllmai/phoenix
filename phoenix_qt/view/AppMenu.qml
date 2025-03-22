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
        height: 80
        ToolButton {
            id: phoenixIconId
            visible: root.width>80
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
            color: Style.Colors.textColor
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: phoenixIconId.right
            anchors.leftMargin: 2
            text: "Phoenix"
            font.weight: 400
            font.pixelSize: 20
            font.styleName: "Bold"
            clip: true
        }
        ToolButton {
            id: iconId
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.leftMargin: 2
            background: null
            function myIcon(){
                if(root.width>100)
                    if(!iconId.hovered)
                        return "qrc:/media/icon/alignLeft.svg"
                    else
                        return "qrc:/media/icon/alignLeftFill.svg"
                else
                    if(!iconId.hovered)
                        return "qrc:/media/icon/alignRight.svg"
                    else
                        return "qrc:/media/icon/alignRightFill.svg"
            }

            icon{
                source: iconId.myIcon()
                color: Style.Colors.menuHoverAndCheckedIcon;
                width:18; height:18
            }
            onClicked: function() {
                if(root.width<100)
                    root.width = 200
                else
                    root.width = 60
            }
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
    }

    MyIcon{
        id: settingsIcon
        width: 36; height: 36
        myIcon: settingsIcon.hovered? "qrc:/media/icon/settingsFill.svg": "qrc:/media/icon/settings.svg"
        myTextToolTip: "Settings"
        iconType: Style.RoleEnum.IconType.Primary
        anchors.left: parent.left; anchors.leftMargin: 10
        anchors.bottom: parent.bottom; anchors.bottomMargin: 10
        onClicked: { settingsDialogId.open() }
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
