import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import './component_library/style' as Style
import './settings'

Dialog {
    id: dialogId
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: Math.min( 800 , parent.width-20)
    height: Math.min( 600 , parent.height-20)

    signal buttonAction1()
    signal buttonAction2()

    property var textBotton1
    property var textBotton2

    focus: true
    modal: true

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
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
            }

            Column{
                width: parent.width - settingsMenuId.width
                height: parent.height
                anchors.margins: 16
                // SettingsHeader{
                //     id:settingsHeaderId
                //     visible: false
                // }

                SettingsBody{
                    id: settingsBodyId
                    width: parent.width
                    height: parent.height/* - settingsHeaderId.height*/
                }
            }
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
