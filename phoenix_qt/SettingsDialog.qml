import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects


Item {
    id : rootId

    function openDialog(){
        settingsDialog.open()
    }
    signal settingsDialogAccepted
    signal themeRequested1(var myTheme)
    signal fontSizeRequested1(var myFontSize)
    signal fontFamilyRequested1(var myFontFamily)


    property color backgroundPageColor
    property color backgroungColor
    property color glowColor
    property color boxColor
    property color headerColor
    property color normalButtonColor
    property color selectButtonColor
    property color hoverButtonColor
    property color fillIconColor
    property color iconColor

    property color titleTextColor
    property color informationTextColor
    property color selectTextColor

    property var theme
    property var fontFamily

    Dialog {
        id: settingsDialog

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: (2*parent.width)/3
        height: (2*parent.height)/3
        font.family: rootId.fontFamily
        parent: Overlay.overlay

        focus: true
        modal: true

        background: Rectangle{
            radius: 12
            color: rootId.backgroungColor
            layer.enabled: true
            layer.effect: Glow {
                 samples: 50
                 color: rootId.glowColor
                 spread: 0.4
                 transparentBorder: true
             }
        }
        Rectangle{
            id:settingsPage
            anchors.fill: parent
            color: rootId.backgroungColor
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
                    color: rootId.titleTextColor
                    verticalAlignment: Text.AlignVCenter
                    font.styleName: "Bold"
                    font.pointSize: 12
                    font.family: rootId.fontFamily
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
                            onClicked: {settingsPageId.currentIndex = 0}
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
                    color: rootId.backgroundPageColor
                    radius: 12
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    ApplicationSettingsPage{
                        id: applicationSettingsPageId
                        anchors.fill: parent

                        backgroundPageColor: rootId.backgroundPageColor
                        backgroungColor: rootId.backgroungColor
                        glowColor: rootId.glowColor
                        boxColor: rootId.boxColor
                        headerColor: rootId.headerColor
                        normalButtonColor: rootId.normalButtonColor
                        selectButtonColor: rootId.selectButtonColor
                        hoverButtonColor: rootId.hoverButtonColor
                        fillIconColor: rootId.fillIconColor
                        iconColor: rootId.iconColor

                        titleTextColor: rootId.titleTextColor
                        informationTextColor: rootId.informationTextColor
                        selectTextColor: rootId.selectTextColor

                        theme: rootId.theme
                        fontFamily: rootId.fontFamily

                        Connections{
                            target: applicationSettingsPageId
                            function onThemeRequested2(myTheme){
                                themeRequested1(myTheme)
                            }
                            function onFontSizeRequested2(myFontSize){
                                fontSizeRequested1(myFontSize)
                            }
                            function onFontFamilyRequested2(myFontFamily){
                                fontFamilyRequested1(myFontFamily)
                            }
                        }
                    }
                }
            }
        }


    }
}

