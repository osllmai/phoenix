import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style

ListView {
    id: listView
    visible: listView.count !== 0
    anchors.fill: parent

    interactive: listView.contentHeight > listView.height
    boundsBehavior: listView.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

    flickDeceleration: 80
    maximumFlickVelocity: 30000

    ScrollBar.vertical: ScrollBar {
        policy: listView.contentHeight > listView.height
                ? ScrollBar.AlwaysOn
                : ScrollBar.AlwaysOff
    }
    clip: true

    model: onlineCompanyList
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
