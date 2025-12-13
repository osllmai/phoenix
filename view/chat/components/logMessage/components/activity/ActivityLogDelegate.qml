import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import '../../../../../component_library/style' as Style
import '../../../../../component_library/button'

Item {
    id: control
    height: Math.max(logoModelId.height, informationId.height + 16)

    Row {
        id: headerId
        width: parent.width
        MyIcon {
            id: logoModelId
            visible: model.icon !== "qrc:/media/image_company/user.svg"
            myIcon: model.icon
            iconType: Style.RoleEnum.IconType.Image
            enabled: false
            width: 32; height: 32
        }
        ToolButton {
            id: phoenixIconId
            visible: model.icon === "qrc:/media/image_company/user.svg"
            width: 32; height: 32
            background: null
            icon{
                source: model.icon
                color: Style.Colors.menuHoverAndCheckedIcon
                width:32; height:32
            }
        }
        Label {
            id: informationId
            text: model.text
            color: Style.Colors.textTitle
            width: parent.width - logoModelId.width - 12
            font.pixelSize: 12
            wrapMode: Text.Wrap
            elide: Label.ElideRight
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            topPadding: (logoModelId.height - font.pixelSize ) / 3
        }
    }
}
