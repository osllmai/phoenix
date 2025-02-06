import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: control
    clip:true

    function calculationCellWidth(){
        if(gridView.width >1650)
            return gridView.width/5;
        else if(gridView.width >1300)
            return gridView.width/4;
        else if(gridView.width >950)
            return gridView.width/3;
        else if(gridView.width >550)
            return gridView.width/2;
        else
            return Math.max(gridView.width,300);
    }

    GridView {
        id: gridView
        anchors.fill: parent
        anchors.margins: 15
        cacheBuffer: Math.max(0, gridView.contentHeight)

        cellWidth: control.calculationCellWidth()
        cellHeight: 300

        interactive: contentHeight > height
        boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

        flickDeceleration: 500
        maximumFlickVelocity: 6000

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
        clip: true

        model:10
        delegate: Rectangle{
           width: gridView.cellWidth
           height: gridView.cellHeight
           color: "#00ffffff"

           OfflineDelegate {
               id: indoxItem
               anchors.fill: parent; anchors.margins: indoxItem.hovered? 18: 20
               Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
           }
        }
    }
}
