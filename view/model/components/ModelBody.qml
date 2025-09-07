import QtQuick 2.15
import QtQuick.Layouts
import "./offline"
import "./online"
import "./huggingface"

StackLayout {
    id: page
    currentIndex: 0

    function setFilter(pageName, filter){
        if(pageName === "offline" && offlineLoader.item)
            offlineLoader.item.setFilter(filter)
        else if(pageName === "online" && onlineLoader.item)
            onlineLoader.item.setFilter(filter)
        else if(pageName === "huggingface" && huggingfaceLoader.item)
            huggingfaceLoader.item.setFilter(filter)
    }

    Loader {
        id: offlineLoader
        active: page.currentIndex === 0 || item !== null
        visible: page.currentIndex === 0
        sourceComponent: OfflineModelView { id: offlineModel }
    }

    Loader {
        id: onlineLoader
        active: page.currentIndex === 1 || item !== null
        visible: page.currentIndex === 1
        sourceComponent: OnlineModelView { id: onlineModel }
    }

    Loader {
        id: huggingfaceLoader
        active: page.currentIndex === 2 || item !== null
        visible: page.currentIndex === 2
        sourceComponent: HuggingfaceModelView { id: huggingfaceModel }
    }
}
