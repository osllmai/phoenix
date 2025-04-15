import QtQuick.Layouts
import "./components"

StackLayout {
    id: page
    currentIndex: 0

    SettingsTheme{id: settingsThemeId}

    SettingsSpeech{id: settingsSpeechId}

    SettingsTerms_of_Use {
        id: settingsTerms_of_UseId
        Layout.alignment: Qt.AlignHCenter
    }

    SettingsPrivacy {
        id: settingsPrivacyId
        Layout.alignment: Qt.AlignHCenter
    }

    SettingsAbout {
        id: settingsAboutId
        Layout.alignment: Qt.AlignHCenter
    }
}
