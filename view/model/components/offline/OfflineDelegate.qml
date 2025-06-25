import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import '../../../component_library/style' as Style
import "../../../component_library/button"

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
                Row{
                    width: parent.width - logoModelId.width - likeIconId.width
                    anchors.verticalCenter: logoModelId.verticalCenter
                    Label {
                        id: titleId
                        text: model.name
                        color: Style.Colors.textTitle
                        font.pixelSize: 14
                        font.styleName: "Bold"
                        clip: true
                        elide: Label.ElideRight
                    }
                    MyCopyButton{
                        id: copyId
                        myText: TextArea{text: "localModel/"+model.modelName;}
                        anchors.verticalCenter: titleId.verticalCenter
                    }
                }

                MyIcon{
                    id: likeIconId
                    myIcon: model.isLike? "qrc:/media/icon/favorite.svg": "qrc:/media/icon/disFavorite.svg"
                    anchors.verticalCenter: logoModelId.verticalCenter
                    iconType: Style.RoleEnum.IconType.Like
                    isNeedAnimation: true
                    onClicked: {
                        offlineModelList.likeRequest(model.id, !model.isLike)
                        model.isLike = !model.isLike
                    }
                }
            }
            Label {
                id:informationId
                height: parent.height - headerId.height - downloadButtonId.height - informationAboutDownloadId.height - 30
                width: parent.width
                text: model.information
                color: Style.Colors.textInformation
                anchors.left: parent.left; anchors.right: parent.right
                font.pixelSize: 10
                horizontalAlignment: Text.AlignJustify
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
                elide: Label.ElideRight
                clip: true
                MouseArea {
                    id: infoMouseArea
                    anchors.fill: informationId
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
                        width: (parent.width/4)-8
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 5
                        Label {
                            id: fileSizeText
                            color: Style.Colors.textInformation
                            text: qsTr("File size")
                            font.styleName: "Bold"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pointSize: 8
                        }
                        Label {
                            id: fileSizeValue
                            color: Style.Colors.textInformation
                            text: model.fileSize + " GB"
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
                        width: (parent.width/4)+ 17
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 5
                        Label {
                            id: ramRequiredText
                            color: Style.Colors.textInformation
                            text: qsTr("RAM requierd")
                            font.styleName: "Bold"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pointSize: 8
                        }
                        Label {
                            id: ramRequiredValue
                            color: Style.Colors.textInformation
                            text: model.ramRamrequired + " GB"
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
                        width: (parent.width/4)
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 5
                        Label {
                            id: parameterersText
                            color: Style.Colors.textInformation
                            text: qsTr("Parameters")
                            font.styleName: "Bold"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pointSize: 8
                        }
                        Label {
                            id: parameterersValue
                            color: Style.Colors.textInformation
                            text: model.parameters
                            font.pointSize: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Rectangle{
                        id:line3
                        width: 1
                        height: parent.height
                        color: Style.Colors.boxBorder
                    }
                    Column{
                        id: quantBox
                        width: (parent.width/4)-20
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 5
                        Label {
                            id: quantText
                            color: Style.Colors.textInformation
                            text: qsTr("Quant")
                            font.styleName: "Bold"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pointSize: 8
                        }
                        Label {
                            id: quantValue
                            color: Style.Colors.textInformation
                            text: model.quant
                            font.pointSize: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            DownloadButton{
                id: downloadButtonId
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
