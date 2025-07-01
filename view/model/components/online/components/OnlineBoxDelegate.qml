import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import '../../../../component_library/style' as Style
import "../../../../component_library/button"
import "./components"

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

                OnlineDelegateTitleAndCopyButton{
                    width: parent.width - logoModelId.width - likeIconId.width
                    height: parent.height
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
            Label {
                id:informationId
                height: parent.height - headerId.height - apikeyButton.height - informationAboutDownloadId.height - 30
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

                    OnlineDelegateInfoBox{
                        id:typeBox
                        myText: qsTr("Type")
                        myValue: model.type
                        width: (parent.width/3)-2
                    }

                    Rectangle{
                        id:line1
                        width: 1
                        height: parent.height
                        color: Style.Colors.boxBorder
                    }

                    OnlineDelegateInfoBox{
                        id: contextWindowsBox
                        myText: qsTr("Context Windows")
                        myValue: model.contextWindows
                        width: (parent.width/3) + 12
                    }

                    Rectangle{
                        id:line2
                        width: 1
                        height: parent.height
                        color: Style.Colors.boxBorder
                    }

                    OnlineDelegateInfoBox{
                        id:outputBox
                        myText: qsTr("Output")
                        myValue: model.output
                        width: (parent.width/3) - 10
                    }
                }
            }
            ApikeyButton{
                id: apikeyButton
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
