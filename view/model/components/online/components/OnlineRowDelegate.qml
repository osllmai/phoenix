import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Layouts
import '../../../../component_library/style' as Style
import "../../../../component_library/button"
import "./components"
import "../../../../component_library/model/components/online"

T.Button {
    id: control
    width: 250
    height: 250

    background: null

    contentItem: Rectangle {
        id: backgroundId
        anchors.fill: parent
        radius: 10
        border.width: 1
        border.color: Style.Colors.boxBorder
        color: Style.Colors.boxHover

        // -------------------- Desktop Loader --------------------
        Loader {
            id: desktopLoader
            active: window.isDesktopSize
            anchors.fill: parent

            sourceComponent: Item {
                anchors.fill: parent

                Row {
                    id: headerId
                    width: 150
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10

                    MyIcon {
                        id: logoModelId
                        myIcon: model.icon
                        iconType: Style.RoleEnum.IconType.Image
                        enabled: false
                        width: 32; height: 32
                    }

                    OnlineDelegateTitleAndCopyButton {
                        width: parent.width - logoModelId.width - likeIconId.width - aboutIcon.width
                        height: parent.height
                    }

                    MyIcon {
                        id: aboutIcon
                        width: 29; height: 29
                        myIcon: aboutIcon.hovered ? "qrc:/media/icon/aboutFill.svg" : "qrc:/media/icon/about.svg"
                        anchors.verticalCenter: logoModelId.verticalCenter
                        myTextToolTip: model.name
                    }

                    MyIcon {
                        id: likeIconId
                        width: 32; height: 32
                        myIcon: model.isLike ? "qrc:/media/icon/favorite.svg" : "qrc:/media/icon/disFavorite.svg"
                        anchors.verticalCenter: logoModelId.verticalCenter
                        iconType: Style.RoleEnum.IconType.Like
                        onClicked: {
                            onlineCompanyList.likeRequest(model.id, !model.isLike)
                            model.isLike = !model.isLike
                        }
                    }
                }

                OnlineModelListComboBox {
                    id: informationAboutDownloadId
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: headerId.right
                    anchors.leftMargin: (2*(parent.width - informationAboutDownloadId.width - headerId.width - downloadButtonId.width - 20))/3
                }

                ApikeyButton {
                    id: downloadButtonId
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    isFillWidthDownloadButton: false
                }
            }
        }

        // -------------------- Mobile Loader --------------------
        Loader {
            id: mobileLoader
            active: !window.isDesktopSize
            anchors.fill: parent

            sourceComponent: Column {
                anchors.fill: parent
                anchors.margins: 10

                Row {
                    id: header2Id
                    width: parent.width

                    MyIcon {
                        id: logoModel2Id
                        myIcon: model.icon
                        iconType: Style.RoleEnum.IconType.Image
                        enabled: false
                        width: 30; height: 30
                    }

                    OnlineDelegateTitleAndCopyButton {
                        width: parent.width - logoModel2Id.width - likeIcon2Id.width - about2Icon.width
                        height: parent.height
                    }

                    MyIcon {
                        id: about2Icon
                        width: 32; height: 32
                        myIcon: about2Icon.hovered ? "qrc:/media/icon/aboutFill.svg" : "qrc:/media/icon/about.svg"
                        anchors.verticalCenter: logoModel2Id.verticalCenter
                        myTextToolTip: model.name
                    }

                    MyIcon {
                        id: likeIcon2Id
                        width: 32; height: 32
                        myIcon: model.isLike ? "qrc:/media/icon/favorite.svg" : "qrc:/media/icon/disFavorite.svg"
                        anchors.verticalCenter: logoModel2Id.verticalCenter
                        iconType: Style.RoleEnum.IconType.Like
                        onClicked: {
                            onlineCompanyList.likeRequest(model.id, !model.isLike)
                            model.isLike = !model.isLike
                        }
                    }
                }

                ApikeyButton {
                    id: downloadButton2Id
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    isFillWidthDownloadButton: false
                }
            }
        }

        // -------------------- Hover Effect --------------------
        layer.enabled: control.hovered ? true : false
        layer.effect: Glow {
            samples: 40
            color: Style.Colors.boxBorder
            spread: 0.1
            transparentBorder: true
        }
    }
}
