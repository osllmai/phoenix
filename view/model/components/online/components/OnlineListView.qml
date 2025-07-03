import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style

ListView {
    id: listView
    visible: listView.count !== 0
    anchors.fill: parent
    cacheBuffer: Math.max(0, listView.contentHeight)

    interactive: listView.contentHeight > listView.height
    boundsBehavior: listView.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

    flickDeceleration: 200
    maximumFlickVelocity: 12000

    ScrollBar.vertical: ScrollBar {
        policy: listView.contentHeight > listView.height
                ? ScrollBar.AlwaysOn
                : ScrollBar.AlwaysOff
    }
    clip: true

    model: onlineModelListFilter
    delegate: Item{
       width: listView.width
       height: window.isDesktopSize? 65:90

       OnlineRowDelegate {
           id: indoxItem
           anchors.fill: parent
           anchors.leftMargin: 10
           anchors.rightMargin: 10
           anchors.topMargin: 5
           anchors.bottomMargin: 5
       }
    }
}
