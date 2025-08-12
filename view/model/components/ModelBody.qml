import QtQuick.Layouts
import "./offline"
import "./online"
import "./huggingface"

StackLayout {
    id: page
    currentIndex: 0

    function setFilter(page, filter){
        if(page === "offline"){
            offlineModel.setFilter(filter)
        }else if(page === "online"){
            onlineModel.setFilter(filter)
        }
    }

    OfflineModelView{id: offlineModel}

    OnlineModelView{id: onlineModel}

    HuggingfaceModelView{id: huggingfaceModel}
}
