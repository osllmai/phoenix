import QtQuick.Layouts
import "./offline"
import "./online"

StackLayout {
    id: page
    currentIndex: 0
    width: parent.width

    OnlineCurrentView{id: onlineCurrentModelId}

    OfflineCurrentView{id: offlineCurrentModelId}
}
