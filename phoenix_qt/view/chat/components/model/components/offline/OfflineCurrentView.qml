import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: control
    clip:true

    ListView {
        id: gridView
        anchors.fill: parent
        anchors.margins: 15
        cacheBuffer: Math.max(0, gridView.contentHeight)

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
        clip: true

        model:10
        delegate: Rectangle{
           width: gridView.width
           height: indoxItem.height
           color: "#00ffffff"

           OfflineCurrentDelegate {
               id: indoxItem
               anchors.fill: parent; anchors.margins: indoxItem.hovered? 18: 20
               Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
           }
        }
    }
}
