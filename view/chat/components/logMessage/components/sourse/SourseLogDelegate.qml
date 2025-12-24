import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import '../../../../../component_library/style' as Style
import '../../../../../component_library/button'

T.Button {
    id: control
    height: Math.max(logoModelId.height, titleId.height + 16) + informationId.height + information2Id.height + 10

    onClicked: {
        if (model.link && model.link !== "") {
            Qt.openUrlExternally(model.link)
        }
    }

    background: null
    contentItem: Rectangle {
        id: backgroundId
        anchors.fill: parent
        radius: 8
        color: control.hovered? Style.Colors.boxHover: "#00ffffff"

        Column {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 2

            Row {
                id: headerId
                width: parent.width
                MyIcon {
                    id: logoModelId
                    visible: model.icon !== "qrc:/media/image_company/user.svg"
                    myIcon: model.icon
                    iconType: Style.RoleEnum.IconType.Image
                    enabled: false
                    width: 50; height: 35
                }
                ToolButton {
                    id: phoenixIconId
                    visible: model.icon === "qrc:/media/image_company/user.svg"
                    width: 50; height: 35
                    background: null
                    icon{
                        source: model.icon
                        color: Style.Colors.menuHoverAndCheckedIcon
                        width:24; height:24
                    }
                }
                Label {
                    id: titleId
                    text: model.title
                    color: Style.Colors.textTitle
                    width: parent.width - 30
                    font.pixelSize: 10
                    font.bold: true
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: logoModelId.verticalCenter
                    elide: Label.ElideRight
                    wrapMode: Text.NoWrap
                }
            }

            Label {
                id: informationId
                text: model.link
                color: Style.Colors.textTitle
                clip: true
                width: parent.width
                height: 16
                font.pixelSize: 13
                font.bold: true
                horizontalAlignment: Text.AlignJustify
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
                elide: Label.ElideRight
            }
            Label {
                id: information2Id
                text: model.text
                color: Style.Colors.textInformation
                clip: true
                width: parent.width
                height: 16
                font.pixelSize: 12
                font.bold: false
                horizontalAlignment: Text.AlignJustify
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
                elide: Label.ElideRight
            }
        }
    }
}
