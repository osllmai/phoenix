import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style
import '../../../../component_library/button'

Flickable {
    id: flickable
    anchors.fill: parent

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
        spacing: 10

        Label {
            id: availablemodelsId
            visible: offlineFinishedDownloadModelList.height>30
            text: "Available Models"
            color: Style.Colors.textTitle
            anchors.left: parent.left; anchors.leftMargin: 20
            elide: Text.ElideRight
            font.pixelSize: 14
            font.styleName: "Bold"
            clip: true
        }

        ListView {
            id: offlineFinishedDownloadModelList
            visible: offlineFinishedDownloadModelList.count !== 0

            height: offlineFinishedDownloadModelList.contentHeight
            width: parent.width

            interactive: offlineFinishedDownloadModelList.contentHeight > offlineFinishedDownloadModelList.height
            boundsBehavior: offlineFinishedDownloadModelList.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

            clip: true

            model: offlineModelListFinishedDownloadFilter
            delegate: Item{
               id: delegateId
               visible: !flickable.showAllModels ? index < 3 : true
               width: offlineFinishedDownloadModelList.width
               height: delegateId.visible ? (window.isDesktopSize ? 65 : 90) : 0

               OfflineRowDelegate {
                   id: indoxItem
                   anchors.fill: parent
                   anchors.leftMargin: 10
                   anchors.rightMargin: 10
                   anchors.topMargin: 5
                   anchors.bottomMargin: 5
               }
            }
        }

        MyButton{
            id: installButton
            visible: offlineModelListFinishedDownloadFilter.count > 3
            myText: flickable.showAllModels ? "Show Less" : "Show More"
            anchors.horizontalCenter: parent.horizontalCenter
            bottonType: Style.RoleEnum.BottonType.Primary
            onClicked:{
                flickable.showAllModels = !flickable.showAllModels
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

        ListView {
            id: allModelList
            visible: allModelList.count !== 0

            height: allModelList.contentHeight
            width: parent.width

            interactive: allModelList.contentHeight > allModelList.height
            boundsBehavior: allModelList.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

            clip: true

            model: offlineModelListFilter
            delegate: Item{
               width: allModelList.width
               height: window.isDesktopSize? 65:90

               OfflineRowDelegate {
                   id: indoxItem2
                   anchors.fill: parent
                   anchors.leftMargin: 10
                   anchors.rightMargin: 10
                   anchors.topMargin: 5
                   anchors.bottomMargin: 5
               }
            }
        }
    }
}
