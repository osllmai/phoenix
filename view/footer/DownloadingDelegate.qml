import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import '../component_library/style' as Style
import '../component_library/button'
import QtQuick.Dialogs

T.Button {
    id: control

    background: null
    contentItem: Rectangle {
        id: backgroundId
        anchors.fill: parent
        radius: 8
        border.width: 1
        border.color: Style.Colors.buttonFeatureBorderNormal
        color: (control.hovered)? Style.Colors.boxHover: "#00ffffff"

        Row {
            id: headerId
            anchors.verticalCenter: parent.verticalCenter
            MyIcon {
                id: logoModelId
                myIcon: model.icon
                iconType: Style.RoleEnum.IconType.Image
                enabled: false
                width: 32; height: 32
            }
            Label {
                id: modelNameId
                text: model.name
                width: backgroundId.width -
                            (logoModelId.width) -
                            (downloadPercentButton.visible? downloadPercentButton.width: 0) - 5
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
            MyButton{
                id: downloadPercentButton
                visible: model.isDownloading
                height: 28
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
