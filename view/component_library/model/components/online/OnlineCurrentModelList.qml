import QtQuick 2.15
import QtQuick.Controls 2.15

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
       }
    }
}
