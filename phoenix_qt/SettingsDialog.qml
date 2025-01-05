import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import 'style' as Style

Item {
    id : rootId

    function openDialog(){
        settingsDialog.open()
    }
    signal settingsDialogAccepted
    signal themeRequested1(var myTheme)
    signal fontSizeRequested1(var myFontSize)
    signal fontFamilyRequested1(var myFontFamily)

    Dialog {
        id: settingsDialog

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: (2*parent.width)/3
        height: (2*parent.height)/3
        font.family: Style.Theme.fontFamily
        parent: Overlay.overlay

        focus: true
        modal: true

        background: Rectangle{
            radius: 12
            color: Style.Theme.backgroungColor
            layer.enabled: true
            layer.effect: Glow {
                 samples: 50
                 color: Style.Theme.glowColor
                 spread: 0.4
                 transparentBorder: true
             }
        }
        Rectangle{
            id:settingsPage
            anchors.fill: parent
            color: Style.Theme.backgroungColor
            Rectangle{
                id: titleId
                width: parent.width
                height: 40
                color: "#00ffffff"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 10

                Text {
                    id: settingsTextId
                    text: qsTr("Settings")
                    color: Style.Theme.titleTextColor
                    verticalAlignment: Text.AlignVCenter
                    font.styleName: "Bold"
                    font.pointSize: 12
                    font.family: Style.Theme.fontFamily
                }
            }

            Rectangle{
                id: menuId
                color: "#00ffffff"
                width: 110
                anchors.top: titleId.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.topMargin: 0
                anchors.bottomMargin: 20
                Column{
                    id: culumnId
                    anchors.fill: parent
                    MyMenuSettings {
                        id: applicationButton
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                        myTextId: "Application"
                        checked: true
                        autoExclusive: true
                        Connections {
                            target: applicationButton
                            function onClicked(){settingsPageId.currentIndex = 0}
                        }
                    }
                }
            }


            StackLayout {
                id: settingsPageId
                anchors.left: menuId.right
                anchors.right: parent.right
                anchors.top: titleId.bottom
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 10
                anchors.topMargin: 0
                anchors.bottomMargin: 10
                currentIndex: 0

                Rectangle {
                    id: applicationSettingsPageBox
                    anchors.fill: settingsPageId
                    color: Style.Theme.backgroundPageColor
                    radius: 12
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    ApplicationSettingsPage{
                        id: applicationSettingsPageId
                        anchors.fill: parent

                        Connections{
                            target: applicationSettingsPageId
                            function onThemeRequested2(myTheme){
                                rootId.themeRequested1(myTheme)
                            }
                            function onFontSizeRequested2(myFontSize){
                                rootId.fontSizeRequested1(myFontSize)
                            }
                            function onFontFamilyRequested2(myFontFamily){
                                rootId.fontFamilyRequested1(myFontFamily)
                            }
                        }
                    }
                }
            }
        }
    }
}

