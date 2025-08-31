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

        GridView {
            id: gridView2
            visible: gridView2.count !== 0
            width: parent.width
            height: gridView2.contentHeight

            cellWidth: control.calculationCellWidth()
            cellHeight: 300

            clip: true

            model: huggingfaceModelList
            delegate: Item{
               width: gridView2.cellWidth
               height: gridView2.cellHeight

               HuggingfaceBoxDelegate {
                   id: indoxItem2
                   anchors.fill: parent; anchors.margins: /*indoxItem.hovered? 18: 20*/18
                   Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
               }
            }
        }
        Row{
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
        }
    }
}
