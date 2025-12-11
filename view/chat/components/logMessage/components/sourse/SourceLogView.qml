import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../../component_library/style' as Style
import '../../../../../component_library/button'

Item {
    id: control
    anchors.fill: parent
    clip: true

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
        spacing: 10

        model: conversationListFilter
        delegate: Item{
           width: listView.width; height: indoxItem.height
           SourseLogDelegate {
               id: indoxItem
               width: listView.width;
           }
        }
    }

    Item{
        id:searchEmptyHistory
        visible: /*conversationList.count === 0 &&*/ listView.count === 0
        anchors.fill: parent
        MyIcon {
            id: notFoundModelIconId
            myIcon: "qrc:/media/icon/history.svg"
            iconType: Style.RoleEnum.IconType.Primary
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            enabled: false
            width: 80; height: 80
        }
    }
}
