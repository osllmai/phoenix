import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import '../../../style' as Style
import '../../../button'

T.Button {
    id: control

    onClicked: {
        if(model.installModel){
            modelSelectViewId.setModelRequest(model.id, model.name, "qrc:/media/image_company/" + model.icon, model.promptTemplate, model.systemPrompt)
        }
    }

    property bool checkselectItem: modelSelectViewId.modelSelect &&(modelSelectViewId.modelId === model.id)

    background: null
    contentItem: Rectangle {
        id: backgroundId
        anchors.fill: parent
        radius: 8
        border.width: 1
        border.color: control.checkselectItem? Style.Colors.buttonFeatureBorderSelected: Style.Colors.buttonFeatureBorderNormal
        color: (control.hovered || control.checkselectItem)? Style.Colors.boxHover: "#00ffffff"

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
                width: backgroundId.width -
                       logoModelId.width -
                       copyId.width -
                       (installButton.visible? installButton.width: 0) -
                       (rejectChatButton.visible? rejectChatButton.width: 0) - 5
                clip: true
                elide: Label.ElideRight
                color: Style.Colors.textTitle
                font.pixelSize: 12
                font.bold: control.checkselectItem? true: false
                horizontalAlignment: Text.AlignJustify
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
                anchors.verticalCenter: logoModelId.verticalCenter
            }
            MyCopyButton{
                id: copyId
                myText: TextArea{text: model.company.name + "/" + model.modelName;}
                anchors.verticalCenter: logoModelId.verticalCenter
            }
            MyButton{
                id: rejectChatButton
                visible: model.id === modelSelectViewId.modelId && model.installModel
                height: 30
                myText: "Eject"
                bottonType: Style.RoleEnum.BottonType.Secondary
                anchors.verticalCenter: logoModelId.verticalCenter
                onClicked:{
                    modelSelectViewId.setModelRequest(-1, "", "", "", "")
                }
            }
            MyButton{
                id: installButton
                height: 30
                visible: !model.installModel
                myText: "Install"
                anchors.verticalCenter: logoModelId.verticalCenter
                bottonType: Style.RoleEnum.BottonType.Primary
                onClicked:{
                    inputApikeyDialogId.open()
                }
            }
        }
    }
    InputApikeyDialog{
        id: inputApikeyDialogId
    }
}
