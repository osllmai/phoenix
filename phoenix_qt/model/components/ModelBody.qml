import QtQuick.Layouts
import "./offline"
import "./online"

StackLayout {
    id: page
    currentIndex: 0

    OfflineModelView{id: offlineModel}

    OnlineModelView{id: onlineModel}
}
