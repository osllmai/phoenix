import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style

Item {
    id: control
    anchors.fill: parent
    clip: true

    ListView {
        id: listView
        visible: listView.count !== 0
        anchors.fill: parent
        cacheBuffer: Math.max(0, listView.contentHeight)

        interactive: contentHeight > height
        boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

        flickDeceleration: 500
        maximumFlickVelocity: 6000

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
        clip: true

        model: conversationListFilter
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
    Item{
        id:emptyHistory
        visible: listView.count === 0
        anchors.fill: parent
        Label {
            id: textId
            text: "History is empty."
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: Style.Colors.textInformation
            font.pixelSize: 14
            clip: true
        }
    }
}
