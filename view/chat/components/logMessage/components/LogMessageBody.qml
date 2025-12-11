import QtQuick 2.15
import QtQuick.Layouts
import "./activity"
import "./sourse"

StackLayout {
    id: page
    currentIndex: 0

    Loader {
        id: offlineCurrentLoader
        active: page.currentIndex === 0 || item !== null
        visible: page.currentIndex === 0
        sourceComponent: ActivityLogView { id: offlineCurrentModelId }
    }

    Loader {
        id: onlineCurrentLoader
        active: page.currentIndex === 1 || item !== null
        visible: page.currentIndex === 1
        sourceComponent: SourceLogView { id: onlineCurrentModelId }
    }
}
