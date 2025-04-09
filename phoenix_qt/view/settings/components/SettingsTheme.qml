import QtQuick 2.15
import QtQuick.Controls 2.15
import "../../component_library/button"
import '../../component_library/style' as Style

Item {
    Column {
        anchors.fill: parent
        anchors.topMargin: 10
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

            Flow {
                spacing: 15

                ThemeOption {
                    id: defaultModeId
                    myIcon: "qrc:/media/icon/themeDefualt.png"
                    checked: window.theme === "Defualt"
                    myText:"Auto"
                    autoExclusive: true
                    Connections {
                        target: defaultModeId
                        function onClicked(){
                            window.theme = "Defualt"
                            console.log(window.theme)
                        }
                    }
                }

                ThemeOption {
                    id: lightModeId
                    myIcon: "qrc:/media/icon/themeLight.png"
                    checked: window.theme === "Light"
                    autoExclusive: true
                    myText: "Light"
                    Connections {
                        target: lightModeId
                        function onClicked(){
                            window.theme = "Light"
                            console.log(window.theme)
                        }
                    }
                }

                ThemeOption {
                    id: darkModeId
                    myIcon: "qrc:/media/icon/themeDark.png"
                    checked: window.theme === "Dark"
                    myText: "Dark"
                    autoExclusive: true
                    Connections {
                        target: darkModeId
                        function onClicked(){
                            window.theme = "Dark"
                            console.log(window.theme)
                        }
                    }
                }
            }
        }
    }
}
