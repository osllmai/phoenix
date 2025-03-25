import QtQuick.Layouts
import "./components"

StackLayout {
    id: page
    currentIndex: 0

    SettingsTheme{id: settingsThemeId}

    SettingsSpeech{id: settingsSpeechId}

    SettingsTerms_of_Use{id: settingsTerms_of_UseId}

    SettingsPrivacy{id: settingsPrivacyId}

    SettingsAbout{id: settingsAboutId}

}

// Column{
//     MyComboBox {
//         id: themeList
//         model: ListModel {
//             ListElement { text: "Dark" }
//             ListElement { text: "Light" }
//             ListElement { text: "System Defualt" }
//         }
//         displayText: window.theme
//         onActivated: {
//             window.theme = themeList.currentText
//         }
//     }
//     MyComboBox {
//         id: fontFamilyList
//         model: availableFonts
//         displayText: window.font.family
//         onActivated: {
//             window.font.family = fontFamilyList.currentText
//         }
//     }
// }

