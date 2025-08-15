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

        Label {
            id: availablemodelsId
            visible: gridView.height>30
            text: "Recent Downloaded Model"
            color: Style.Colors.textTitle
            anchors.left: parent.left; anchors.leftMargin: 20
            elide: Text.ElideRight
            font.pixelSize: 14
            font.styleName: "Bold"
            clip: true
        }

        GridView {
            id: gridView
            visible: gridView.count !== 0
            width: parent.width
            height: flickable.showAllModels? gridView.contentHeight: 300

            interactive: false
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOff
            }

            cellWidth: control.calculationCellWidth()
            cellHeight: 300

            clip: true

            model: huggingfaceModelList
            delegate: Item{
                id: delegateId
                visible: !flickable.showAllModels ? index < control.calculationCellNumber() : true
                width: delegateId.visible ? gridView.cellWidth: 0
                height:  delegateId.visible ? gridView.cellHeight : 0

                HuggingfaceBoxDelegate {
                   id: indoxItem
                   anchors.fill: parent; anchors.margins: /*indoxItem.hovered? 18: 20*/18
                   Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
                }
            }
        }

        Row{
            id: installButton
            visible: offlineModelListFinishedDownloadFilter.count > 3
            width: parent.width - 40
            height: 30
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle{
                width: parent.width - 30
                height: 1
                color: Style.Colors.boxBorder
                anchors.verticalCenter: parent.verticalCenter
            }
            MyIcon{
                id:iconId
                width: 30; height: 30
                myIcon: flickable.showAllModels ? "qrc:/media/icon/up.svg" : "qrc:/media/icon/down.svg"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        flickable.showAllModels = !flickable.showAllModels
                    }
                }
            }
        }

        Label {
            id: textId
            text: "All Model"
            color: Style.Colors.textTitle
            anchors.left: parent.left; anchors.leftMargin: 20
            elide: Text.ElideRight
            font.pixelSize: 14
            font.styleName: "Bold"
            clip: true
        }

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
    }
}

