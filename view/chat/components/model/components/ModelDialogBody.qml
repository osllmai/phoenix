import QtQuick.Layouts
import "./offline"
import "./online"

StackLayout {
    id: page
    currentIndex: 0

    OfflineCurrentView{id: offlineCurrentModelId}

    OnlineCurrentView{id: onlineCurrentModelId}
}
