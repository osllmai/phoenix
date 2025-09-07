import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import './component_library/style' as Style
import './settings'

Dialog {
    id: settingsDialogId
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: Math.min( 800 , parent.width-40)
    height: Math.min( 600 , parent.height-40)

    property bool isDesktopSize: width >= 630;
    onIsDesktopSizeChanged: {
        settingsMenuDerawerId.close()
        if(settingsDialogId.isDesktopSize){
            settingsDialogId.isOpenMenu = true
        }
    }

    property bool isOpenMenu: true
    onIsOpenMenuChanged: {
        if(settingsDialogId.isOpenMenu){
            if(settingsDialogId.isDesktopSize){
                settingsMenuId.width = 200
            }else{
                settingsMenuDerawerId.open()
            }
        }else{
            if(settingsDialogId.isDesktopSize){
                settingsMenuId.width = 60
            }else{
                settingsMenuDerawerId.open()
            }
        }
    }

    focus: true
    modal: true

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        width: window.width
        height: window.height - 40
        y: 40
        color: Style.Colors.overlayDrawer
    }

    background: null
    contentItem:Rectangle{
        id: backgroundId
        anchors.fill: parent

        radius: 10
        border.width: 1
        border.color: Style.Colors.boxBorder
        color: Style.Colors.background
        Row{
            anchors.fill: parent
            SettingsMenu{
                id: settingsMenuId
                visible: settingsDialogId.isDesktopSize
                clip: true
            }

            Column{
                width: parent.width - (settingsDialogId.isDesktopSize? settingsMenuId.width: 0)
                height: parent.height
                anchors.margins: 16

                SettingsHeader{
                    id:settingsHeaderId
                }
                SettingsBody{
                    id: settingsBodyId
                    width: parent.width
                    height: parent.height - settingsHeaderId.height
                }
            }
        }

        SettingsMenuDrawer{
            id: settingsMenuDerawerId
        }

        layer.enabled: true
        layer.effect: Glow {
             samples: 40
             color:  Style.Colors.boxBorder
             spread: 0.1
             transparentBorder: true
         }
    }

}
