import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'


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
        id:searchEmptyHistory
        visible: conversationList.count === 0 && listView.count === 0
        anchors.fill: parent
        MyIcon {
            id: notFoundModelIconId
            myIcon: "qrc:/media/icon/history.svg"
            iconType: Style.RoleEnum.IconType.Primary
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            enabled: false
            width: 120; height: 120
        }
    }
    Item{
        id:emptyHistory
        visible: conversationList.count !== 0 && listView.count === 0
        anchors.fill: parent
        MyIcon {
            id: searchNotFoundModelIconId
            myIcon: "qrc:/media/icon/notFoundHistory.svg"
            iconType: Style.RoleEnum.IconType.Image
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            enabled: false
            width: 80; height: 80
        }
    }
}
