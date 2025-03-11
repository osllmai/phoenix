import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style

Item {
    id: control
    width: parent.width
    clip: true
    visible: !conversationList.isEmptyConversation

    ListView {
        id: listView
        anchors.fill: parent
        visible: !conversationList.isEmptyConversation
        cacheBuffer: Math.max(0, listView.contentHeight)

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
        clip: true

        model: conversationList.currentConversation.messageList
        delegate: Item{
           width: listView.width; height: promptItem.height
           MessageDelegate{
               id: promptItem
               visible: true
           }
        }
    }
}
