import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import '../../../component_library/style' as Style
import "../../../component_library/button"


Item {
    id: control
    height: 35
    width: parent.width

    MyButton{
        id: dounloadButton
        anchors.right: parent.right
        anchors.left: parent.left
        visible: !model.downloadFinished && !model.isDownloading
        myText: "Download"
        bottonType: Style.RoleEnum.BottonType.Primary
        onClicked:{
            folderDialogId.open()
        }
    }

    MyButton{
        id: downloadPercentButton
        visible: model.isDownloading
        progressBarValue: model.downloadPercent
        bottonType: Style.RoleEnum.BottonType.Progress
        onClicked:{
            offlineModelList.cancelRequest(model.id)
        }
    }

    Row{
        spacing: 5
        visible: model.downloadFinished
        anchors.right: parent.right
        MyButton{
            id: deleteButton
            myText: "Delete"
            bottonType: Style.RoleEnum.BottonType.Danger
            onClicked:{
                deleteModelVerificationId.open()
            }
        }
        MyButton{
            id: startChatButton
            width: control.width - deleteButton.width - 5
            myText: "Start Chat"
            bottonType: Style.RoleEnum.BottonType.Primary
            onClicked:{
                // offlineModelList.deleteRequest(model.id)
            }
        }
    }

    VerificationDialog{
        id: deleteModelVerificationId
        titleText: "Delete"
        about:"Do you really want to delete these Model?"
        textBotton1: "Cancel"
        textBotton2: "Delete"
        Connections{
            target:deleteModelVerificationId
            function onButtonAction1(){
                deleteModelVerificationId.close()
            }
            function onButtonAction2() {
                offlineModelList.deleteRequest(model.id)
                deleteModelVerificationId.close()
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
