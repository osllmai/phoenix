import QtQuick 2.15
import QtQuick.Layouts
import "./offline"
import "./online"

StackLayout {
    id: page
    currentIndex: 0

    Loader {
        id: offlineCurrentLoader
        active: page.currentIndex === 0 || item !== null
        visible: page.currentIndex === 0
        sourceComponent: OfflineCurrentView { id: offlineCurrentModelId }
    }

    Loader {
        id: onlineCurrentLoader
        active: page.currentIndex === 1 || item !== null
        visible: page.currentIndex === 1
        sourceComponent: OnlineCurrentView { id: onlineCurrentModelId }
    }
}
