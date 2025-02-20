import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style

Item {
    id: control
    width: parent.width
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
           PromptDelegate{
               id: promptItem
               visible: true
               anchors.fill: parent; anchors.margins: promptItem.hovered? 8: 12
               Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
           }
           ResponseDelegate{
               id: responseItem
               visible: false
               anchors.fill: parent; anchors.margins: responseItem.hovered? 8: 12
               Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
           }
        }
    }
}
