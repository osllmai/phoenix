import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import '../../../../component_library/style' as Style
import "../../../../component_library/button"
import "./components"
// import "../../../../component_library/model/components/online"

T.Button {
    id: control
    width: 250
    height: 250

    background: null
    contentItem: Rectangle{
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
                    myTextToolTip:model.name
                }

                MyIcon{
                    id: likeIconId
                    myIcon: model.isLike? "qrc:/media/icon/favorite.svg": "qrc:/media/icon/disFavorite.svg"
                    anchors.verticalCenter: logoModelId.verticalCenter
                    iconType: Style.RoleEnum.IconType.Like
                    onClicked: {
                        onlineCompanyList.likeRequest(model.id, !model.isLike)
                        model.isLike = !model.isLike
                    }
                }
            }

            OnlineModelListComboBox{}

            // ApikeyButton{
            //     id: apikeyButton
            // }
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
