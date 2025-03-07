import QtQuick.Layouts

StackLayout {
    id: page
    currentIndex: 0

    AssistantSettingsView{id: assistantSettingsId}

    ModelSettingsView{id: modelSettingsId}
}
