import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Layouts
import '../../../../component_library/style' as Style
import "../../../../component_library/button"

T.Button {
    id: control
    width: 250
    height: 250

    background:null

    contentItem:Rectangle{
        id: backgroundId
        anchors.fill: parent
        radius: 10
        border.width: 1
        border.color: Style.Colors.boxBorder
        color: Style.Colors.boxHover

        Row{
            id: headerId
            visible: window.isDesktopSize
            width: 250
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            MyIcon {
                id: logoModelId
                myIcon: "qrc:/media/image_company/" + model.icon
                iconType: Style.RoleEnum.IconType.Image
                enabled: false
                width: 40; height: 40
            }
            Row{
                width: parent.width - logoModelId.width /*- likeIconId.width*/
                anchors.verticalCenter: parent.verticalCenter
                clip: true
                Label {
                    id: titleId
                    text: model.name
                    color: Style.Colors.textTitle
                    font.pixelSize: 14
                    font.styleName: "Bold"
                    clip: true
                    elide: Label.ElideRight
                    MouseArea {
                        id: infoMouseArea
                        anchors.fill: titleId
                        hoverEnabled: true

                        onPositionChanged: {
                            toolTip.x = mouseX
                            toolTip.y = mouseY
                        }

                        MyToolTip{
                            id: toolTip
                            toolTipText: model.information
                        }
                    }
                }
                MyCopyButton{
                    id: copyId
                    myText: TextArea{text: "localModel/"+model.modelName;}
                    anchors.verticalCenter: titleId.verticalCenter
                    clip: true
                }
            }
            // MyIcon{
            //     id: likeIconId
            //     myIcon: model.isLike? "qrc:/media/icon/favorite.svg": "qrc:/media/icon/disFavorite.svg"
            //     anchors.verticalCenter: logoModelId.verticalCenter
            //     iconType: Style.RoleEnum.IconType.Like
            //     isNeedAnimation: true
            //     onClicked: {
            //         offlineModelList.likeRequest(model.id, !model.isLike)
            //         model.isLike = !model.isLike
            //     }
            // }
        }

        Rectangle{
            id: informationAboutDownloadId
            visible: window.isDesktopSize && (2*(parent.width - informationAboutDownloadId.width - headerId.width - downloadButtonId.width - 20))/3 >20
            height: 45; width: 300
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: headerId.right
            anchors.leftMargin: (2*(parent.width - informationAboutDownloadId.width - headerId.width - downloadButtonId.width - 20))/3
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

        ApikeyButton{
            id: downloadButtonId
            visible: window.isDesktopSize
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            isFillWidthDownloadButton:false
        }

        Column{
            visible: !window.isDesktopSize
            anchors.fill: parent
            anchors.margins: 10
            Row{
                id: header2Id
                width: parent.width

                MyIcon {
                    id: logoModel2Id
                    myIcon: "qrc:/media/image_company/" + model.icon
                    iconType: Style.RoleEnum.IconType.Image
                    enabled: false
                    width: 40; height: 40
                }
                Row{
                    width: parent.width - logoModel2Id.width /*- likeIcon2Id.width*/
                    anchors.verticalCenter: parent.verticalCenter
                    clip: true
                    Label {
                        id: title2Id
                        text: model.name
                        color: Style.Colors.textTitle
                        font.pixelSize: 14
                        font.styleName: "Bold"
                        clip: true
                        elide: Label.ElideRight
                        MouseArea {
                            id: infoMouseArea2
                            anchors.fill: title2Id
                            hoverEnabled: true

                            onPositionChanged: {
                                toolTip.x = mouseX
                                toolTip.y = mouseY
                            }

                            MyToolTip{
                                id: toolTip2
                                toolTipText: model.information
                            }
                        }
                    }
                    MyCopyButton{
                        id: copy2Id
                        myText: TextArea{text: "localModel/"+model.modelName;}
                        anchors.verticalCenter: title2Id.verticalCenter
                        clip: true
                    }
                }
                // MyIcon{
                //     id: likeIcon2Id
                //     myIcon: model.isLike? "qrc:/media/icon/favorite.svg": "qrc:/media/icon/disFavorite.svg"
                //     anchors.verticalCenter: logoModelId.verticalCenter
                //     iconType: Style.RoleEnum.IconType.Like
                //     isNeedAnimation: true
                //     onClicked: {
                //         offlineModelList.likeRequest(model.id, !model.isLike)
                //         model.isLike = !model.isLike
                //     }
                // }
            }

            ApikeyButton{
                id: downloadButton2Id
                anchors.right: parent.right
                anchors.rightMargin: 10
                isFillWidthDownloadButton:false
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
