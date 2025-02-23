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

    MyButton{
        id: deleteButton
        visible: model.downloadFinished
        myText: "Delete"
        bottonType: Style.RoleEnum.BottonType.Danger
        onClicked:{
            offlineModelList.deleteRequest(model.id)
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
