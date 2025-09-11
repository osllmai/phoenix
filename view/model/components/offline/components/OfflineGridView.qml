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
    property bool showAllDownloadModels: false


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
            height: flickable.showAllDownloadModels? gridView.contentHeight: 300

            interactive: false
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOff
            }

            cellWidth: flickable.calculationCellWidth(gridView.width)
            cellHeight: 300

            clip: true

            model: offlineModelListFinishedDownloadFilter
            delegate: Loader {
                id: delegateLoader
                active: !flickable.showAllDownloadModels
                        ? index < flickable.calculationCellNumber(gridView.width)
                        : true

                sourceComponent: Item {
                    width: gridView.cellWidth
                    height: 300

                    OfflineBoxDelegate {
                        anchors.fill: parent
                        anchors.margins: 18
                        Behavior on anchors.margins { NumberAnimation { duration: 200 } }
                    }
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
                myIcon: flickable.showAllDownloadModels ? "qrc:/media/icon/up.svg" : "qrc:/media/icon/down.svg"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        flickable.showAllDownloadModels = !flickable.showAllDownloadModels
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
            height: flickable.numberOfLineShow * 300

            interactive: false
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOff
            }

            cellWidth: flickable.calculationCellWidth(gridView2.width)
            cellHeight: 300

            clip: true

            model: offlineModelListFilter
            delegate: Loader {
                id: delegateLoader2
                active: index < flickable.calculationCellNumber(gridView2.width) * flickable.numberOfLineShow

                sourceComponent: Item {
                    width: gridView2.cellWidth
                    height: 300

                    OfflineBoxDelegate {
                        anchors.fill: parent
                        anchors.margins: 18
                        Behavior on anchors.margins { NumberAnimation { duration: 200 } }
                    }
                }
            }
        }

        Item{
            id: installButton2
            visible: offlineModelListFilter.count > (flickable.numberOfLineShow * flickable.calculationCellNumber(gridView2.width))
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
                    }
                }
            }
        }
    }
}
