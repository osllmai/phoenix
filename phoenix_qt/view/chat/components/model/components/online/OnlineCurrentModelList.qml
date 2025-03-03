import QtQuick 2.15
import QtQuick.Controls 2.15

ListView {
    id: listView
    anchors.fill: parent
    cacheBuffer: Math.max(0, listView.contentHeight)

    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
    }
    clip: true

    model:onlineModelInstallFilter
    delegate: Item{
        width: listView.width; height: 40

        OnlineCurrentModelDelegate {
            id: indoxItem
           anchors.fill: parent; anchors.margins: indoxItem.hovered? 2: 4
           Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
           onHoveredChanged:{
               if(indoxItem.hovered)
                   onlineModelInformation.open()
               else
                   onlineModelInformation.close()
           }

           OnlineCurrentModelinformation{
               id: onlineModelInformation
               x: indoxItem.width + 20
               y: -onlineModelInformation.height/2 + indoxItem.height
           }
       }
    }
}
