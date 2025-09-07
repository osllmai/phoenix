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

    flickDeceleration: 200
    maximumFlickVelocity: 12000

    ScrollBar.vertical: ScrollBar {
        policy: flickable.contentHeight > flickable.height
                ? ScrollBar.AlwaysOn
                : ScrollBar.AlwaysOff
    }

    property bool showAllModels: false

    Column {
        id: column
        width: flickable.width
        spacing: 5

        // Label {
        //     id: availablemodelsId
        //     visible: offlineFinishedDownloadModelList.height>30
        //     text: "Recent Downloaded Model"
        //     color: Style.Colors.textTitle
        //     anchors.left: parent.left; anchors.leftMargin: 20
        //     elide: Text.ElideRight
        //     font.pixelSize: 14
        //     font.styleName: "Bold"
        //     clip: true
        // }

        // ListView {
        //     id: offlineFinishedDownloadModelList
        //     visible: offlineFinishedDownloadModelList.count !== 0

        //     height: offlineFinishedDownloadModelList.contentHeight
        //     width: parent.width

        //     clip: true

        //     model: huggingfaceModelList
        //     delegate: Item{
        //        id: delegateId
        //        visible: !flickable.showAllModels ? index < 3 : true
        //        width: offlineFinishedDownloadModelList.width
        //        height: delegateId.visible ? (window.isDesktopSize ? 65 : 90) : 0

        //        HuggingfaceRowDelegate {
        //            id: indoxItem
        //            anchors.fill: parent
        //            anchors.leftMargin: 10
        //            anchors.rightMargin: 10
        //            anchors.topMargin: 5
        //            anchors.bottomMargin: 5
        //        }
        //     }
        // }

        // MyButton{
        //     id: installButton
        //     visible: offlineModelListFinishedDownloadFilter.count > 3
        //     myText: flickable.showAllModels ? "Show Less" : "Show More"
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     bottonType: Style.RoleEnum.BottonType.Primary
        //     onClicked:{
        //         flickable.showAllModels = !flickable.showAllModels
        //     }
        // }

        // Row{
        //     id: installButton
        //     visible: offlineModelListFinishedDownloadFilter.count > 3
        //     width: parent.width - 40
        //     height: 30
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     Rectangle{
        //         width: parent.width - 30
        //         height: 1
        //         color: Style.Colors.boxBorder
        //         anchors.verticalCenter: parent.verticalCenter
        //     }
        //     MyIcon{
        //         id:iconId
        //         width: 30; height: 30
        //         myIcon: flickable.showAllModels ? "qrc:/media/icon/up.svg" : "qrc:/media/icon/down.svg"
        //         MouseArea {
        //             anchors.fill: parent
        //             onClicked: {
        //                 flickable.showAllModels = !flickable.showAllModels
        //             }
        //         }
        //     }
        // }

        // Label {
        //     id: textId
        //     text: "All Model"
        //     color: Style.Colors.textTitle
        //     anchors.left: parent.left; anchors.leftMargin: 20
        //     elide: Text.ElideRight
        //     font.pixelSize: 14
        //     font.styleName: "Bold"
        //     clip: true
        // }

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

            model: huggingfaceModelList
            delegate: Item{
               width: allModelList.width
               height: window.isDesktopSize? 65:90

               HuggingfaceRowDelegate {
                   id: indoxItem2
                   anchors.fill: parent
                   anchors.leftMargin: 10
                   anchors.rightMargin: 10
                   anchors.topMargin: 5
                   anchors.bottomMargin: 5
               }
            }
        }
        Item{
            id: installButton
            // visible: offlineModelListFinishedDownloadFilter.count > 3
            width: parent.width - 40
            height: 45
            // anchors.horizontalCenter: parent.horizontalCenter
            MyButton{
                id: openHistoryId
                myIcon: "qrc:/media/icon/add.svg"
                myTextToolTip: "Add More"
                myText: "Add More"
                bottonType: Style.RoleEnum.BottonType.Secondary
                anchors.horizontalCenter: parent.horizontalCenter
                Connections {
                    target: openHistoryId
                    function onClicked(){
                        huggingfaceModelList.loadMore()
                    }
                }
            }
            // Rectangle{
            //     width: parent.width - 30
            //     height: 1
            //     color: Style.Colors.boxBorder
            //     anchors.verticalCenter: parent.verticalCenter
            // }
            // MyIcon{
            //     id:iconId
            //     width: 30; height: 30
            //     myIcon: /*flickable.showAllModels ? "qrc:/media/icon/up.svg" :*/ "qrc:/media/icon/down.svg"
            //     MouseArea {
            //         anchors.fill: parent
            //         onClicked: {
            //             huggingfaceModelList.loadMore()
            //         }
            //     }
            // }
        }
        // MyButton{
        //     id: openHistoryId
        //     myIcon: "qrc:/media/icon/add.svg"
        //     myTextToolTip: "History"
        //     myText: "Add More"
        //     width: 30; height: 30
        //     bottonType: Style.RoleEnum.BottonType.Secondary
        //     Connections {
        //         target: openHistoryId
        //         function onClicked(){
        //             headerId.openHistoryDrawer()
        //         }
        //     }
        // }
    }
}
