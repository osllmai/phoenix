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
        interactive: true
        policy: flickable.contentHeight > flickable.height
                ? ScrollBar.AlwaysOn
                : ScrollBar.AlwaysOff
        minimumSize: 0.1
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
        visible: /*conversationList.count === 0 &&*/ gridView2.count !== 0
        width: flickable.width
        spacing: 5

        GridView {
            id: gridView2
            visible: gridView2.count !== 0
            width: parent.width
            height: gridView2.contentHeight

            interactive: gridView2.contentHeight > gridView2.height
            boundsBehavior: gridView2.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

            cellWidth: flickable.calculationCellWidth(gridView2.width)
            cellHeight: 220
            clip: true

            model: huggingfaceModelListFilter

            delegate: Item{/*Loader {*/
                id: delegateLoader2
                width: gridView2.cellWidth
                height: gridView2.cellHeight
                /*asynchronous: true

                sourceComponent:*/ HuggingfaceBoxDelegate {
                    id: realBox
                    anchors.fill: parent
                    anchors.margins: 12
                }
            }
        }
    }
    Item{
        id:searchEmptyHistory
        visible: /*conversationList.count === 0 &&*/ gridView2.count === 0
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
