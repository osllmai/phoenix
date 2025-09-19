import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style
import '../../../../component_library/button'

Flickable {
    id: flickable
    anchors.fill: parent
    anchors.topMargin: 10

    contentHeight: column.implicitHeight
    clip: true

    interactive: flickable.contentHeight > flickable.height
    boundsBehavior: flickable.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

    flickDeceleration: 80
    maximumFlickVelocity: 30000

    ScrollBar.vertical: ScrollBar {
        policy: flickable.contentHeight > flickable.height
                ? ScrollBar.AlwaysOn
                : ScrollBar.AlwaysOff
    }

    property bool showAllModels: false

    Column {
        id: column
        width: flickable.width
        visible: allModelList.count !== 0
        spacing: 5

        ListView {
            id: allModelList
            visible: allModelList.count !== 0

            height: allModelList.contentHeight
            width: parent.width

            clip: true

            interactive: false
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOff
            }

            model: huggingfaceModelListFilter

            delegate: Item{/*Loader {*/
                id: delegateLoader2
                width: allModelList.width
                height: window.isDesktopSize? 65:90
               /* asynchronous: true

                sourceComponent:*/ HuggingfaceRowDelegate {
                    id: indoxItem2
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.topMargin: 5
                    anchors.bottomMargin: 5
                }

            //     Rectangle {
            //         anchors.fill: parent
            //         radius: 12
            //         color: "#00ffffff"
            //         visible: delegateLoader2.status === Loader.Loading
            //         Column {
            //             anchors.centerIn: parent
            //             spacing: 12

            //             BusyIndicator {
            //                 running: true
            //                 width: 48; height: 48
            //             }
            //         }
            //     }
            //     onStatusChanged: {
            //         if (status === Loader.Ready) {
            //             // console.log("Delegate is ready!", realBox)
            //             huggingfaceModelList.loadMore()
            //         } else if (status === Loader.Loading) {
            //             console.log("Delegate is loading...")
            //         }
            //     }

            }
        }
    }
    Item{
        id:searchEmptyHistory
        visible: allModelList.count === 0
        width: flickable.width
        height: flickable.height
        MyIcon {
            id: notFoundModelIconId
            myIcon: "qrc:/media/icon/search.svg"
            iconType: Style.RoleEnum.IconType.Primary
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            enabled: false
            width: 60; height: 60
        }
    }
}
