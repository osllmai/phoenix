import QtQuick 2.15
import QtQuick.Controls 2.15

ListView {
    id: gridView
    // anchors.fill: parent
    // anchors.margins: 15
    width: gridView.width
    height: 300
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

       OfflineCurrentModelDelegate {
           id: indoxItem
           myText: "ModelName"
           anchors.fill: parent; anchors.margins: /*indoxItem.hovered? 18:*/ 20
           Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
       }
    }
}
