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

    property int numberOfLineShow: 1

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
            height: flickable.numberOfLineShow * 300

            interactive: false
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOff
            }

            cellWidth: flickable.calculationCellWidth(gridView2.width)
            cellHeight: 300

            clip: true

            model: huggingfaceModelList
            delegate: Loader {
                id: delegateLoader2
                active: index < flickable.calculationCellNumber(gridView2.width) * flickable.numberOfLineShow

                sourceComponent: Item {
                    width: gridView2.cellWidth
                    height: 300

                    HuggingfaceBoxDelegate {
                        anchors.fill: parent
                        anchors.margins: 18
                        Behavior on anchors.margins { NumberAnimation { duration: 200 } }
                    }
                }
            }
        }
        Item{
            id: installButton
            visible: huggingfaceModelList.count > (flickable.numberOfLineShow * flickable.calculationCellNumber(gridView2.width))
            width: parent.width - 40
            height: 45

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
                        flickable.numberOfLineShow = flickable.numberOfLineShow + 1
                        huggingfaceModelList.loadMore()
                    }
                }
            }
        }
    }
}
