import QtQuick 2.15

Column{
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
    MyComboBox {
        id: fontFamilyList
        model: availableFonts
        displayText: window.font.family
        onActivated: {
            window.font.family = fontFamilyList.currentText
        }
    }
}

