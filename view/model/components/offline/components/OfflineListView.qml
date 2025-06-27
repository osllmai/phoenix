import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style

ListView {
    id: gridView
    visible: gridView.count !== 0
    anchors.fill: parent
    cacheBuffer: Math.max(0, gridView.contentHeight)

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
       width: gridView.width
       height: window.isDesktopSize? 100:135

       OfflineRowDelegate {
           id: indoxItem
           anchors.fill: parent; anchors.margins: /*indoxItem.hovered? 18: 20*/18
           Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
       }
    }
}
