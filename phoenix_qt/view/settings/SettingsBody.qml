import QtQuick 2.15
import '../component_library/style' as Style
import '../component_library/button'

Column{
    MyComboBox {
        id: themeList
        height: 35
        width: 200

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
    MyComboBox {
        id: fontFamilyList
        height: 35
        width: 200

        model: availableFonts
        displayText: window.font.family
        onActivated: {
            window.font.family = fontFamilyList.currentText
        }
    }
}
