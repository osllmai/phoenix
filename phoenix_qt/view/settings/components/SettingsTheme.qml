import QtQuick 2.15
import QtQuick.Controls 2.15
import "../../component_library/button"
import '../../component_library/style' as Style

Item {
    Column {
        anchors.fill: parent
        anchors.topMargin: 60
        anchors.leftMargin: 20
        spacing: 20

        Row {
            Label {
                id: fontFamilyId
                text: "Font Family:"
                width: 100
                color: Style.Colors.textTitle
                font.pixelSize: 14
                anchors.verticalCenter: parent.verticalCenter
            }
            MyComboBox {
                id: fontFamilyList
                model: availableFonts
                displayText: window.font.family
                onActivated: {
                    window.font.family = fontFamilyList.currentText
                }
            }
        }

        Column {
            spacing: 10

            Label {
                id: themeId
                text: "Theme:"
                width: 100
                color: Style.Colors.textTitle
                font.pixelSize: 14
            }

            Row {
                spacing: 15

                ThemeOption {
                    id: defaultModeId
                    myIcon: "qrc:/media/icon/themeDefualt.png"
                    checked: true
                    autoExclusive: true
                    Connections {
                        target: defaultModeId
                        function onClicked(){
                        }
                    }
                }

                ThemeOption {
                    id: lightModeId
                    myIcon: "qrc:/media/icon/themeLight.png"
                    checked: false
                    autoExclusive: true
                    Connections {
                        target: lightModeId
                        function onClicked(){
                        }
                    }
                }

                ThemeOption {
                    id: darkModeId
                    myIcon: "qrc:/media/icon/themeDark.png"
                    checked: false
                    autoExclusive: true
                    Connections {
                        target: darkModeId
                        function onClicked(){
                        }
                    }
                }
            }
        }
    }
}
