import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Layouts
import '../../../../component_library/style' as Style
import "../../../../component_library/button"
import "./components"

T.Button {
    id: control
    width: 250
    height: 250

    background:null

    focusPolicy: Qt.NoFocus

    contentItem:Rectangle{
        id: backgroundId
        anchors.fill: parent
        radius: 10
        border.width: 1
        border.color: Style.Colors.boxBorder
        color: Style.Colors.boxHover

        Loader {
            id: desktopLoader
            active: window.isDesktopSize
            anchors.fill: parent

            sourceComponent: Item {
                anchors.fill: parent

                Row {
                    id: headerId
                    width: 300
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10

                    MyIcon {
                        id: logoModelId
                        myIcon: "qrc:/media/image_company/" + model.icon
                        iconType: Style.RoleEnum.IconType.Image
                        enabled: false
                        width: 32; height: 32
                    }

                    OfflineDelegateTitleAndCopyButton {
                        width: parent.width - logoModelId.width - likeIconId.width - aboutIcon.width
                        height: parent.height
                    }

                    MyIcon {
                        id: aboutIcon
                        width: 29; height: 29
                        myIcon: aboutIcon.hovered ? "qrc:/media/icon/aboutFill.svg" : "qrc:/media/icon/about.svg"
                        anchors.verticalCenter: logoModelId.verticalCenter
                        myTextToolTip: model.information
                    }

                    MyIcon {
                        id: likeIconId
                        width: 32; height: 32
                        myIcon: model.isLike ? "qrc:/media/icon/favorite.svg" : "qrc:/media/icon/disFavorite.svg"
                        anchors.verticalCenter: logoModelId.verticalCenter
                        iconType: Style.RoleEnum.IconType.Like
                        onClicked: {
                            offlineModelList.likeRequest(model.id, !model.isLike)
                            model.isLike = !model.isLike
                        }
                    }
                }

                Rectangle {
                    id: informationAboutDownloadId
                    visible: (2*(parent.width - informationAboutDownloadId.width - headerId.width - downloadButtonId.width - 20))/3 > 20
                    height: 40; width: 300
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: headerId.right
                    anchors.leftMargin: (2*(parent.width - informationAboutDownloadId.width - headerId.width - downloadButtonId.width - 20))/3
                    radius: 10
                    border.color: Style.Colors.boxBorder
                    border.width: 1
                    color: "#00ffffff"
                    OfflineInformationModel {}
                }

                DownloadButton {
                    id: downloadButtonId
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                }
            }
        }

        Loader {
            id: mobileLoader
            active: !window.isDesktopSize
            anchors.fill: parent

            sourceComponent: Column {
                anchors.fill: parent
                anchors.margins: 5

                Row {
                    id: header2Id
                    width: parent.width

                    MyIcon {
                        id: logoModel2Id
                        myIcon: "qrc:/media/image_company/" + model.icon
                        iconType: Style.RoleEnum.IconType.Image
                        enabled: false
                        width: 30; height: 30
                    }

                    OfflineDelegateTitleAndCopyButton {
                        width: parent.width - logoModel2Id.width - likeIcon2Id.width - about2Icon.width
                        height: parent.height
                    }

                    MyIcon {
                        id: about2Icon
                        width: 32; height: 32
                        myIcon: about2Icon.hovered ? "qrc:/media/icon/aboutFill.svg" : "qrc:/media/icon/about.svg"
                        anchors.verticalCenter: logoModel2Id.verticalCenter
                        myTextToolTip: model.information
                    }

                    MyIcon {
                        id: likeIcon2Id
                        width: 32; height: 32
                        myIcon: model.isLike ? "qrc:/media/icon/favorite.svg" : "qrc:/media/icon/disFavorite.svg"
                        anchors.verticalCenter: logoModel2Id.verticalCenter
                        iconType: Style.RoleEnum.IconType.Like
                        onClicked: {
                            offlineModelList.likeRequest(model.id, !model.isLike)
                            model.isLike = !model.isLike
                        }
                    }
                }

                DownloadButton {
                    id: downloadButton2Id
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                }
            }
        }

        layer.enabled: control.hovered? true: false
        layer.effect: Glow {
             samples: 40
             color:  Style.Colors.boxBorder
             spread: 0.1
             transparentBorder: true
         }
    }
}
