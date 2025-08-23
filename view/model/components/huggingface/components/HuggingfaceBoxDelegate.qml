import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Layouts
import '../../../../component_library/style' as Style
import "../../../../component_library/button"
import "./components"
import "../../offline/components/components"

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
                height: Math.max(logoModelId.height, likeIconId.height)
                MyIcon {
                    id: logoModelId
                    myIcon:model.icon
                    iconType: Style.RoleEnum.IconType.Image
                    enabled: false
                    width: 40; height: 40
                }

                HuggingfaceDelegateTitleAndCopyButton{
                    width: parent.width - logoModelId.width - likeIconId.width - aboutIcon.width
                    height: parent.height
                }

                MyIcon{
                    id: aboutIcon
                    width: 29; height: 29
                    myIcon: aboutIcon.hovered? "qrc:/media/icon/aboutFill.svg": "qrc:/media/icon/about.svg"
                    anchors.verticalCenter: logoModelId.verticalCenter
                    myTextToolTip:model.idModel
                }

                MyIcon{
                    id: likeIconId
                    myIcon: /*model.isLike? */"qrc:/media/icon/favorite.svg" /*: "qrc:/media/icon/disFavorite.svg"*/
                    anchors.verticalCenter: logoModelId.verticalCenter
                    iconType: Style.RoleEnum.IconType.Like

                    Label {
                        text: model.likes
                        color: Style.Colors.textTagError
                        anchors.top: likeIconId.bottom
                        anchors.topMargin: -5
                        anchors.horizontalCenter: likeIconId.horizontalCenter
                        font.pixelSize: 10
                        clip: true
                        elide: Label.ElideRight
                    }
                }
            }

            Item {
                id: tagsContainer
                width: parent.width
                height: parent.height - headerId.height - downloadButtonId.height - informationAboutDownloadId.height - createdAtText.height - 40
                clip: true

                Flow {
                    id: tagsFlow
                    anchors.fill: parent
                    anchors.topMargin: 4
                    spacing: 4
                    flow: Flow.LeftToRight
                    Repeater {
                        model: tags
                        MyButton {
                            myText: modelData !== undefined && modelData !== null ? modelData.toString() : ""
                            myIcon: ""
                            bottonType: Style.RoleEnum.BottonType.Secondary
                            isNeedAnimation: true
                            height: 20
                        }
                    }
                }
            }

            Label {
                id: createdAtText
                text: "Created at: " + model.createdAt
                color: Style.Colors.textInformation
                anchors.left: parent.left
                anchors.right: parent.right
                font.pixelSize: 10
                font.italic: true
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignTop
            }

            Rectangle{
                id: informationAboutDownloadId
                height: 45; width: parent.width
                radius: 10
                border.color: Style.Colors.boxBorder
                border.width: 1
                color: "#00ffffff"
                HuggingfaceInformationModel{}
            }

            MyButton{
                id: downloadButtonId
                myText: "More Information"
                bottonType: Style.RoleEnum.BottonType.Primary
                anchors.right: parent.right
                onClicked:{
                    huggingfaceModelList.OpenModel(model.id)
                    huggingfaceDialogId.open()
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
