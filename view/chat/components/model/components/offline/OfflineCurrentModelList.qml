import QtQuick 2.15
import QtQuick.Controls 2.15

ListView {
    id: listView
    anchors.fill: parent
    cacheBuffer: Math.max(0, listView.contentHeight)

    interactive: contentHeight > height
    boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

    flickDeceleration: 500
    maximumFlickVelocity: 6000

    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
    }
    clip: true

    model:offlineModelListFinishedDownloadFilter
    delegate: Item{
        width: listView.width; height: 50

        OfflineCurrentModelDelegate {
            id: indoxItem
           anchors.fill: parent; anchors.margins: indoxItem.hovered? 2: 4
           Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
           onHoveredChanged:{
               if(indoxItem.hovered)
                   offlineModelInformation.open()
               else
                   offlineModelInformation.close()
           }

           OfflineCurrentModelinformation{
               id: offlineModelInformation
               x: indoxItem.width + 20
               y: -offlineModelInformation.height/2 + indoxItem.height
           }
       }
    }
}
