import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import '../../../style' as Style
import '../../../button'
import QtQuick.Dialogs

T.Button {
    id: control

    onClicked: {
        if (model.downloadFinished) {
            modelSelectViewId.setModelRequest(
                model.id,
                model.name,
                model.icon,
                model.promptTemplate,
                model.systemPrompt
            )
        }
    }

    property bool checkselectItem: modelSelectViewId.modelSelect &&
                                   (modelSelectViewId.modelId === model.id)

    background: null
    contentItem: Rectangle {
        id: backgroundId
        anchors.fill: parent
        radius: 8
        border.width: 1
        border.color: control.checkselectItem
                       ? Style.Colors.buttonFeatureBorderSelected
                       : Style.Colors.buttonFeatureBorderNormal
        color: (control.hovered || control.checkselectItem)
               ? Style.Colors.boxHover
               : "#00ffffff"

        Row {
            id: headerId
            anchors.verticalCenter: parent.verticalCenter

            MyIcon {
                id: logoModelId
                myIcon: model.icon
                iconType: Style.RoleEnum.IconType.Image
                enabled: false
                width: 32
                height: 32
            }

            Label {
                id: modelNameId
                text: model.name
                width: backgroundId.width
                        - logoModelId.width
                        - copyId.width
                        - (rejectChatLoader.visible ? 60 : 0)
                        - (downloadButtonLoader.visible ? 80 : 0)
                        - (progressButtonLoader.visible ? 87 : 0)
                        - 5
                clip: true
                elide: Label.ElideRight
                color: Style.Colors.textTitle
                font.pixelSize: 12
                font.bold: control.checkselectItem
                horizontalAlignment: Text.AlignJustify
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
                anchors.verticalCenter: logoModelId.verticalCenter
            }

            MyCopyButton {
                id: copyId
                myText: TextArea { text: model.modelName }
                anchors.verticalCenter: logoModelId.verticalCenter
            }

            Loader {
                id: rejectChatLoader
                active: model.id === modelSelectViewId.modelId && model.downloadFinished
                visible: model.id === modelSelectViewId.modelId && model.downloadFinished
                anchors.verticalCenter: logoModelId.verticalCenter
                sourceComponent: MyButton {
                    height: 30
                    width: 60
                    myText: "Eject"
                    bottonType: Style.RoleEnum.BottonType.Secondary
                    onClicked: {
                        modelSelectViewId.setModelRequest(-1, "", "", "", "")
                    }
                }
            }

            Loader {
                id: downloadButtonLoader
                active: !model.downloadFinished && !model.isDownloading
                visible: !model.downloadFinished && !model.isDownloading
                anchors.verticalCenter: logoModelId.verticalCenter
                sourceComponent: MyButton {
                    id: dounloadButton
                    height: 30
                    width: 80
                    myText: "Download"
                    bottonType: Style.RoleEnum.BottonType.Primary
                    onClicked: {
                        folderDialogLoader.active = true
                        folderDialogLoader.item.open()
                    }
                }
            }

            Loader {
                id: progressButtonLoader
                active: model.isDownloading
                visible: model.isDownloading
                anchors.verticalCenter: logoModelId.verticalCenter
                sourceComponent: MyButton {
                    id: downloadPercentButton
                    height: 30
                    width: 87
                    progressBarValue: model.downloadPercent
                    bottonType: Style.RoleEnum.BottonType.Progress
                    onClicked: {
                        offlineModelList.cancelRequest(model.id)
                    }
                }
            }
        }
    }

    Loader {
        id: folderDialogLoader
        active: false
        sourceComponent: FolderDialog {
            id: folderDialogId
            title: "Choose Folder"

            onAccepted: offlineModelList.downloadRequest(model.id, currentFolder)
            onRejected: console.log("Rejected")
        }
    }
}
