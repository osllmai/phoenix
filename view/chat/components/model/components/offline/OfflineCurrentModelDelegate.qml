import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import '../../../../../component_library/style' as Style
import '../../../../../component_library/button'

T.Button {
    id: control
    property var modelName
    property var modelIcon
    signal deleteChat()
    signal editChatName(var chatName)

    onClicked: {
        conversationList.setModelRequest(model.id, model.name, "qrc:/media/image_company/" + model.icon, model.promptTemplate, model.systemPrompt)
    }

    background: null
    contentItem: Rectangle {
        id: backgroundId
        anchors.fill: parent
        radius: 8
        border.width: 1
        border.color: Style.Colors.boxBorder
        color: (control.hovered || (conversationList.modelSelect &&(conversationList.modelId === model.id) ))? Style.Colors.boxHover: "#00ffffff"

        Row {
            id: headerId
            anchors.verticalCenter: parent.verticalCenter
            MyIcon {
                id: logoModelId
                myIcon: "qrc:/media/image_company/" + model.icon
                iconType: Style.RoleEnum.IconType.Image
                enabled: false
                width: 32; height: 32
            }
            Label {
                id: modelNameId
                text: model.name
                width: backgroundId.width - logoModelId.width - rejectChatButton.width - 5
                clip: true
                elide: Label.ElideRight
                color: Style.Colors.textTitle
                font.pixelSize: 12
                horizontalAlignment: Text.AlignJustify
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
                anchors.verticalCenter: logoModelId.verticalCenter
            }
            MyButton{
                id: rejectChatButton
                visible: model.id === conversationList.modelId
                myText: "Reject"
                bottonType: Style.RoleEnum.BottonType.Secondary
                onClicked:{
                    conversationList.setModelRequest(-1, "", "", "", "")
                }
            }
        }
    }
}
