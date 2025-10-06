import QtQuick 2.15
import QtQuick.Controls 2.15
import "./components"

ListView {
    id: listView

    height: listView.contentHeight
    width: parent.width

    interactive: listView.contentHeight > listView.height
    boundsBehavior: listView.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

    delegate: Item{
        width: listView.width; height: 45

        OnlineCurrentModelDelegate {
            id: indoxItem
           anchors.fill: parent; anchors.margins: indoxItem.hovered? 2: 4
           Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
           onHoveredChanged:{
               if(indoxItem.hovered){
                      offlineModelInformation.close()
                      if(model.name !== "Indox Router"){
                            offlineModelInformation.open()
                      }else
                            onlineIndoxRouter.open()
                      offlineModelInformation.myModel = onlineModelList
                      offlineModelInformation.x = indoxItem.width + 20
                      offlineModelInformation.y = /*-offlineModelInformation.height/2 +*/ indoxItem.y
               }/*else{
                      if(model.name !== "Indox Router")
                            offlineModelInformation.close()
                      else
                            onlineIndoxRouter.close()
               }*/
           }
       }
    }
    OnlineCurrentCompanyListModel{
        id: offlineModelInformation
    }
    OnlineCurrentIndoxRouterCompanyyList{
        id: onlineIndoxRouter
        x: listView.width + 20
        y: -onlineIndoxRouter.height/2 + listView.height
    }
}
