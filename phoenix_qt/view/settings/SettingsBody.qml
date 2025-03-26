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
