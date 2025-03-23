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
            ListElement { text: "light" }
            ListElement { text: "System Defula" }

        }
        displayText: "Style.Theme.theme"
        onActivated: {
            // root.themeRequested2(themeList.currentText)
        }
    }
    MyComboBox {
        id: fontFamilyList
        height: 35
        width: 200

        model: availableFonts
        displayText: "Style.Theme.fontFamily"
        onActivated: {
            // root.fontFamilyRequested2(fontFamilyList.currentText)
        }
    }
}
