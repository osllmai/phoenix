import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style

GridView {
    id: gridView
    visible: gridView.count !== 0
    anchors.fill: parent
    cacheBuffer: Math.max(0, gridView.contentHeight)

    cellWidth: control.calculationCellWidth()
    cellHeight: 200

    interactive: gridView.contentHeight > gridView.height
    boundsBehavior: gridView.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

    flickDeceleration: 200
    maximumFlickVelocity: 12000

    ScrollBar.vertical: ScrollBar {
        policy: gridView.contentHeight > gridView.height
                ? ScrollBar.AlwaysOn
                : ScrollBar.AlwaysOff
    }
    clip: true

    model: onlineCompanyList
    delegate: Item{
       width: gridView.cellWidth
       height: gridView.cellHeight

       OnlineBoxDelegate {
           id: indoxItem
           anchors.fill: parent; anchors.margins: /*indoxItem.hovered? 18: 20*/18
           Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
       }
    }
}
