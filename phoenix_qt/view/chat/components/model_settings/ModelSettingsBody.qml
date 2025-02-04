import QtQuick.Layouts

StackLayout {
    id: page
    currentIndex: 0
    width: parent.width

    AssistantSettingsView{id: assistantSettingsId}

    ModelSettingsView{id: modelSettingsId}
}
