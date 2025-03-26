import QtQuick 2.15
import QtQuick.Controls 2.15
import "../../component_library/button"
import '../../component_library/style' as Style

Item{
    Column{
        anchors.fill: parent
        anchors.topMargin: 60
        anchors.leftMargin: 20
        spacing: 10
        Row{
            Label{
                id: themeId
                text: "Theme:"
                width: 100
                color: Style.Colors.textTitle
                font.pixelSize: 14
                anchors.verticalCenter: parent.verticalCenter
            }

            MyComboBox {
                id: themeList
                model: ListModel {
                    ListElement { text: "Dark" }
                    ListElement { text: "Light" }
                    ListElement { text: "System Defualt" }
                }
                displayText: window.theme
                onActivated: {
                    window.theme = themeList.currentText
                }
            }
        }

        Row{
            Label{
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
    }
}

