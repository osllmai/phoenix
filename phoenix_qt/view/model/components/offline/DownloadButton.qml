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
            myText: "Start Chat"
            bottonType: Style.RoleEnum.BottonType.Primary
            onClicked:{
                // offlineModelList.deleteRequest(model.id)
            }
        }
    }

    VerificationDialog{
        id: deleteModelVerificationId
        titleText: "delete"
        about:"Are you sure you want to delete the LLM model? \nThis action is irreversible and may result in the loss of data or settings associated with the model."
        textBotton1: "delete"
        textBotton2: "cancel"
        Connections{
            target:deleteModelVerificationId
            function onButtonAction1(){
                offlineModelList.deleteRequest(model.id)
            }
            function onButtonAction2() {
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
