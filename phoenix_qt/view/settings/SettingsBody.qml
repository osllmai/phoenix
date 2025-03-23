import QtQuick 2.15
import '../component_library/style' as Style
import '../component_library/button'

Column{
    MyComboBox {
        id: themeList
        height: 35
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 10
        anchors.topMargin: 10
        width: 200

        model: ListModel {
            ListElement { text: "Dark" }
            ListElement { text: "light" }
        }
        displayText: Style.Theme.theme
        onActivated: {
            root.themeRequested2(themeList.currentText)
        }
    }
    MyComboBox {
        id: fontFamilyList
        height: 35
        anchors.right: parent.right
        anchors.top: fontSizeList.bottom
        anchors.rightMargin: 10
        anchors.topMargin: 10
        width: 200

        model: ListModel {
            ListElement { text: "Times New Roman" }
            ListElement { text: "Arial" }
            ListElement { text: "Courier" }
            ListElement { text: "DM Sans 9pt" }
            ListElement { text: "Tahoma" }
            ListElement { text: "Verdana" }
        }
        displayText: Style.Theme.fontFamily
        onActivated: {
            root.fontFamilyRequested2(fontFamilyList.currentText)
        }
    }
}
