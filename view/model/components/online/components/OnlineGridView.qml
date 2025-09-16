import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style

GridView {
    id: gridView
    visible: gridView.count !== 0
    anchors.fill: parent
    cacheBuffer: Math.max(0, gridView.contentHeight)

    cellWidth: control.calculationCellWidth()
    cellHeight: 200

    interactive: gridView.contentHeight > gridView.height
    boundsBehavior: gridView.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

    flickDeceleration: 200
    maximumFlickVelocity: 12000

    ScrollBar.vertical: ScrollBar {
        policy: gridView.contentHeight > gridView.height
                ? ScrollBar.AlwaysOn
                : ScrollBar.AlwaysOff
    }
    clip: true

    model: onlineCompanyList

    // delegate: Loader {
    //     id: delegateLoader
    //     width: gridView.cellWidth
    //     height: gridView.cellHeight
    //     asynchronous: true

    //     sourceComponent: OnlineBoxDelegate {
    //         id: realBox
    //         anchors.fill: parent
    //         anchors.margins: 18
    //     }

    //     Rectangle {
    //         anchors.fill: parent
    //         radius: 12
    //         color: "#00ffffff"
    //         visible: delegateLoader.status === Loader.Loading
    //         Column {
    //             anchors.centerIn: parent
    //             spacing: 12

    //             BusyIndicator {
    //                 running: true
    //                 width: 48; height: 48
    //             }
    //         }
    //     }
    // }

    delegate: Item{
       width: gridView.cellWidth
       height: gridView.cellHeight

       OnlineBoxDelegate {
           id: indoxItem
           anchors.fill: parent; anchors.margins: /*indoxItem.hovered? 18: 20*/18
           Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
       }
    }
}
