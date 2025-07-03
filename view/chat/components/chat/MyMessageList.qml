import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style

Item {
    id: control
    width: parent.width
    height: parent.height - inputBoxId.height - 20
    clip: true

    ListView {
        id: listView
        anchors.fill: parent
        cacheBuffer: Math.max(0, listView.contentHeight)

        interactive: contentHeight > height
        boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

        flickDeceleration: 200
        maximumFlickVelocity: 12000

        ScrollBar.vertical: ScrollBar {
            policy: listView.contentHeight > listView.height
                    ? ScrollBar.AlwaysOn
                    : ScrollBar.AlwaysOff
        }
        clip: true

        model: conversationList.currentConversation ? conversationList.currentConversation.messageList : []

        delegate: Item{
           width: listView.width; height: promptItem.height
           MessageDelegate{
               id: promptItem
           }
        }

        onContentHeightChanged: {
            if (listView.atYEnd) {
                listView.positionViewAtEnd();
            }
        }
    }
}
