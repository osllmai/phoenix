import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import '../../../../../component_library/style' as Style
import "../../../../../component_library/button"

T.Popup {
    id: control
    width: 300
    height: 250

    background:null
    contentItem:Rectangle{
        id: backgroundId
        anchors.fill: parent
        radius: 10
        border.width: 1
        border.color: Style.Colors.boxBorder

        gradient: Gradient {
            GradientStop {
                position: 0
                color: control.hovered? Style.Colors.background: Style.Colors.background
            }

            GradientStop {
                position: 1
                color: control.hovered? Style.Colors.boxHover: Style.Colors.boxHover
            }
            orientation: Gradient.Vertical
        }

        Column{
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10
            Row{
                id: headerId
                width: parent.width
                MyIcon {
                    id: logoModelId
                    myIcon: "qrc:/media/image_company/" + model.icon
                    iconType: Style.RoleEnum.IconType.Image
                    enabled: false
                    width: 40; height: 40
                }
                Label {
                    id: titleId
                    width: parent.width - logoModelId.width - likeIconId.width
                    text: model.name
                    color: Style.Colors.textTitle
                    anchors.verticalCenter: logoModelId.verticalCenter
                    font.pixelSize: 14
                    font.styleName: "Bold"
                }
                MyIcon{
                    id: likeIconId
                    myIcon: model.isLike? "qrc:/media/icon/favorite.svg": "qrc:/media/icon/disFavorite.svg"
                    anchors.verticalCenter: logoModelId.verticalCenter
                    iconType: Style.RoleEnum.IconType.Like
                    isNeedAnimation: true
                    onClicked: {
                        onlineModelList.likeRequest(model.id, !model.isLike)
                        model.isLike = !model.isLike
                    }
                }
            }
            Item{
                id: aboutId
                height: parent.height - headerId.height - informationAboutDownloadId.height - 20
                width: parent.width
                clip: true
                Label {
                    id:informationId
                    text: model.information
                    color: Style.Colors.textInformation
                    anchors.left: parent.left; anchors.right: parent.right
                    font.pixelSize: 10
                    horizontalAlignment: Text.AlignJustify
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                    elide: Label.ElideRight
                    clip: true
                }
            }
            Rectangle{
                id: informationAboutDownloadId
                height: 45; width: parent.width
                radius: 10
                border.color: Style.Colors.boxBorder
                border.width: 1
                color: "#00ffffff"
                Row{
                    anchors.fill: parent
                    Column{
                        id:fileSizeBox
                        width: (parent.width/3)-2
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 5
                        Label {
                            id: fileSizeText
                            color: Style.Colors.textInformation
                            text: qsTr("Type")
                            font.styleName: "Bold"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pointSize: 8
                        }
                        Label {
                            id: fileSizeValue
                            color: Style.Colors.textInformation
                            text: model.type
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pointSize: 8
                        }
                    }
                    Rectangle{
                        id:line1
                        width: 1
                        height: parent.height
                        color: Style.Colors.boxBorder
                    }
                    Column{
                        id: ramRequiredBox
                        width: (parent.width/3) + 12
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 5
                        Label {
                            id: ramRequiredText
                            color: Style.Colors.textInformation
                            text: qsTr("Context Windows")
                            font.styleName: "Bold"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pointSize: 8
                        }
                        Label {
                            id: ramRequiredValue
                            color: Style.Colors.textInformation
                            text: model.contextWindows
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pointSize: 8
                        }
                    }
                    Rectangle{
                        id:line2
                        width: 1
                        height: parent.height
                        color: Style.Colors.boxBorder
                    }
                    Column{
                        id: parameterersBox
                        width: (parent.width/3) - 10
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 5
                        Label {
                            id: parameterersText
                            color: Style.Colors.textInformation
                            text: qsTr("Output")
                            font.styleName: "Bold"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pointSize: 8
                        }
                        Label {
                            id: parameterersValue
                            color: Style.Colors.textInformation
                            text: model.output
                            font.pointSize: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
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
