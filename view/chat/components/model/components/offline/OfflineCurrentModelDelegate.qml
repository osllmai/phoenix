import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import '../../../../../component_library/style' as Style
import '../../../../../component_library/button'
import QtQuick.Dialogs

T.Button {
    id: control
    property var modelName
    property var modelIcon
    signal deleteChat()
    signal editChatName(var chatName)

    onClicked: {
        if(model.downloadFinished){
            conversationList.setModelRequest(model.id, model.name, "qrc:/media/image_company/" + model.icon, model.promptTemplate, model.systemPrompt)
        }
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
                width: backgroundId.width -
                            (logoModelId.width) -
                            (rejectChatButton.visible? rejectChatButton.width: 0) -
                            (downloadPercentButton.visible? downloadPercentButton.width: 0) -
                            (dounloadButton.visible? dounloadButton.width: 0) - 5
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
                height: 30
                visible: model.id === conversationList.modelId && model.downloadFinished
                myText: "Eject"
                bottonType: Style.RoleEnum.BottonType.Secondary
                anchors.verticalCenter: logoModelId.verticalCenter
                onClicked:{
                    conversationList.setModelRequest(-1, "", "", "", "")
                }
            }
            MyButton{
                id: dounloadButton
                height: 30
                visible: !model.downloadFinished && !model.isDownloading
                myText: "Download"
                anchors.verticalCenter: logoModelId.verticalCenter
                bottonType: Style.RoleEnum.BottonType.Primary
                onClicked:{
                    folderDialogId.open()
                }
            }

            MyButton{
                id: downloadPercentButton
                visible: model.isDownloading
                height: 30
                width: 87
                progressBarValue: model.downloadPercent
                anchors.verticalCenter: logoModelId.verticalCenter
                bottonType: Style.RoleEnum.BottonType.Progress
                onClicked:{
                    offlineModelList.cancelRequest(model.id)
                }
            }
        }
    }
    FolderDialog {
        id: folderDialogId
        title: "Choose Folder"

        onAccepted: {
            offlineModelList.downloadRequest(model.id, currentFolder)
            console.log(currentFolder)
        }
        onRejected: {
            console.log("Rejected");
        }
    }
}
