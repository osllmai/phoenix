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

    function calculationCellNumber(myWidth){
        if(myWidth >1650)
            return 5;
        else if(myWidth >1300)
            return 4;
        else if(myWidth >950)
            return 3;
        else if(myWidth >550)
            return 2;
        else
            return 1;
    }

    function calculationCellWidth(myWidth){
        if(myWidth >550)
            return myWidth/calculationCellNumber(myWidth);
        else
            return Math.max(myWidth,300);
    }

    Column {
        id: column
        width: flickable.width
        spacing: 5

        GridView {
            id: gridView2
            visible: gridView2.count !== 0
            width: parent.width
            height: gridView2.contentHeight

            interactive: false
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOff }

            cellWidth: flickable.calculationCellWidth(gridView2.width)
            cellHeight: 250
            clip: true

            model: huggingfaceModelList

            delegate: Loader {
                id: delegateLoader2
                width: gridView2.cellWidth
                height: gridView2.cellHeight
                asynchronous: true

                sourceComponent: HuggingfaceBoxDelegate {
                    id: realBox
                    anchors.fill: parent
                    anchors.margins: 18
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 12
                    color: "#00ffffff"
                    visible: delegateLoader2.status === Loader.Loading
                    Column {
                        anchors.centerIn: parent
                        spacing: 12

                        BusyIndicator {
                            running: true
                            width: 48; height: 48
                        }
                    }
                }
                onStatusChanged: {
                    if (status === Loader.Ready) {
                        // console.log("Delegate is ready!", realBox)
                        huggingfaceModelList.loadMore()
                    } else if (status === Loader.Loading) {
                        console.log("Delegate is loading...")
                    }
                }
            }

        }

        // GridView {
        //     id: gridView2
        //     visible: gridView2.count !== 0
        //     width: parent.width
        //     height: gridView2.contentHeight

        //     interactive: false
        //     boundsBehavior: Flickable.StopAtBounds
        //     ScrollBar.vertical: ScrollBar {
        //         policy: ScrollBar.AlwaysOff
        //     }

        //     cellWidth: flickable.calculationCellWidth(gridView2.width)
        //     cellHeight: 300

        //     clip: true

        //     model: huggingfaceModelList
        //     delegate: Loader {
        //         id: delegateLoader2

        //         sourceComponent: Item {
        //             width: gridView2.cellWidth
        //             height: 300

        //             HuggingfaceBoxDelegate {
        //                 anchors.fill: parent
        //                 anchors.margins: 18
        //                 Behavior on anchors.margins { NumberAnimation { duration: 200 } }
        //             }
        //         }
        //     }
        // }

        // Item{
        //     id: installButton
        //     width: parent.width - 40
        //     height: 45

        //     MyButton{
        //         id: openHistoryId
        //         myIcon: "qrc:/media/icon/add.svg"
        //         myTextToolTip: "Add More"
        //         myText: "Add More"
        //         bottonType: Style.RoleEnum.BottonType.Secondary
        //         anchors.horizontalCenter: parent.horizontalCenter
        //         Connections {
        //             target: openHistoryId
        //             function onClicked(){
        //                 huggingfaceModelList.loadMore()
        //             }
        //         }
        //     }
        // }
    }
}
