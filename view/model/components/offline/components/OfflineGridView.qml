import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style

GridView {
    id: gridView
    visible: gridView.count !== 0
    anchors.fill: parent
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

    model: offlineModelListFilter
    delegate: Item{
       width: gridView.cellWidth
       height: gridView.cellHeight

       OfflineBoxDelegate {
           id: indoxItem
           anchors.fill: parent; anchors.margins: /*indoxItem.hovered? 18: 20*/18
           Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
       }
    }
}
