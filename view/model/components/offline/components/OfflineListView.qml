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
        visible: (allModelList.count !== 0) || (offlineFinishedDownloadModelList.count !== 0)
        spacing: 5

        Label {
            id: availablemodelsId
            visible: offlineFinishedDownloadModelList.height>30 && offlineFinishedDownloadModelList.count !== 0
            text: "Recent Downloaded Model"
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

            height: flickable.showAllModels? offlineFinishedDownloadModelList.contentHeight: (3*(window.isDesktopSize ? 65 : 90))
            width: parent.width

            clip: true

            interactive: false
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOff
            }

            model: offlineModelListFinishedDownloadFilter

            delegate:  /*Loader {
                id: delegateLoader
                active: !flickable.showAllModels ? index < 3 : true

                sourceComponent:*/ Item{
                   id: delegateId
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
            // }
        }

        Row{
            id: installButton
            visible: offlineModelListFinishedDownloadFilter.count > 3 && offlineFinishedDownloadModelList.count !== 0
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
            visible: allModelList.count !== 0
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

            clip: true

            interactive: false
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOff
            }

            model: offlineModelListFilter
            delegate: /*Loader {
                id: delegateLoader2

                sourceComponent:*/ Item{
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
            // }
        }
    }
    Item{
        id:searchEmptyHistory
        visible: (allModelList.count === 0) && (offlineFinishedDownloadModelList.count === 0)
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
