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

    property bool installModel: false

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
            anchors.margins: 16
            spacing: 10
            Row{
                id: headerId
                width: parent.width

                MyIcon {
                    id: logoModelId
                    myIcon: model.icon
                    iconType: Style.RoleEnum.IconType.Image
                    enabled: false
                    width: 40; height: 40
                }

                OnlineDelegateTitleAndCopyButton{
                    width: parent.width - logoModelId.width - likeIconId.width - aboutIcon.width
                    height: parent.height
                }

                MyIcon{
                    id: aboutIcon
                    width: 29; height: 29
                    myIcon: aboutIcon.hovered? "qrc:/media/icon/aboutFill.svg": "qrc:/media/icon/about.svg"
                    anchors.verticalCenter: logoModelId.verticalCenter
                    myTextToolTip:model.information
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
                height: parent.height - headerId.height - (installRowLoader.active?installRowLoader.height:0) - 30
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
            }

            // Row for Installed Model
            Loader {
                id: installRowLoader
                active: installModel
                anchors.left: parent.left

                sourceComponent: Row {
                    id: installRowId
                    spacing: 5
                    width: (rejectButtonLoader.status === Loader.Ready?rejectButtonLoader.width + 5: 0) +
                           startChatButton.width + 5

                    Loader {
                        id: rejectButtonLoader
                        // active: model.id === conversationList.modelId
                        // visible: model.id === conversationList.modelId
                        sourceComponent: MyButton {
                            id: rejectButton
                            myText: "Eject"
                            bottonType: Style.RoleEnum.BottonType.Secondary
                            onClicked: {
                                conversationList.setModelRequest(-1, "", "", "", "")
                            }
                        }
                    }

                    MyButton {
                        id: startChatButton
                        myText:"Start Chat"
                        bottonType: Style.RoleEnum.BottonType.Primary
                        onClicked: {
                            conversationList.setModelRequest(model.id,
                                                             modelName,
                                                             modelIcon,
                                                             modelPromptTemplate,
                                                             modelSystemPrompt)
                            appBodyId.currentIndex = 1
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
