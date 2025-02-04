import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style

Item {
    id: control
    anchors.fill: parent
    clip: true

    ListView {
        id: listView
        anchors.fill: parent
        cacheBuffer: Math.max(0, listView.contentHeight)

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
        clip: true

        model:10
        delegate: Item{
           width: listView.width; height: 122
           Rectangle{
               id:lineTopId
               width: parent.width; height: 1
               anchors.top: parent.top
               color: Style.Colors.boxBorder
           }
           HistoryDelegate {
               id: indoxItem
               anchors.fill: parent; anchors.margins: indoxItem.hovered? 8: 12
               Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
           }
        }
    }
}
