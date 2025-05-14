import QtQuick 2.15
import QtQuick.Controls 2.15

ListView {
    id: listView
    height: listView.contentHeight
    width: parent.width

    clip: true

    delegate: Item{
        width: listView.width; height: 45

        ModelDeveloperDelegate {
            id: indoxItem
           anchors.fill: parent; anchors.margins: indoxItem.hovered? 2: 4
           Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
           onHoveredChanged:{
               if(indoxItem.hovered)
                   offlineModelInformation.open()
               else
                   offlineModelInformation.close()
           }

           ModelDeveloperlinformation{
               id: offlineModelInformation
               x: indoxItem.width + 20
               y: -offlineModelInformation.height/2 + indoxItem.height
           }
       }
    }
}
