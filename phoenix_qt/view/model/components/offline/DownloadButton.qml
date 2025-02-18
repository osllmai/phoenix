import QtQuick 2.15
import QtQuick.Dialogs

import '../../../component_library/style' as Style
import "../../../component_library/button"


Item {
    id: control
    height: 35
    width: parent.width

    // function selectButton(){
    //     if(model.downloadFinished) return deleteId;
    //     else if(model.isDownloading) return downloadPercentId;
    //     else return downloadId;
    // }

    function openSelectFolder(){
        folderDialogId.open()
    }

    // Loader {
    //     id: buttonLoader
    //     sourceComponent: control.selectButton()
    // }

    // Component {
    //     id: downloadId
        MyButton{
            id: dounloadButton
            visible: !model.downloadFinished && !model.isDownloading
            myText: "Download"
            bottonType: Style.RoleEnum.BottonType.Primary
            onClicked:{
                control.openSelectFolder()
            }
        }
    // }

    // Component {
    //     id: downloadPercentId
        MyButton{
            id: downloadPercentButton
            visible: model.isDownloading
            myText: "Progress"
            bottonType: Style.RoleEnum.BottonType.Primary
            onClicked:{

            }
        }
    // }

    // Component {
    //     id: deleteId
        MyButton{
            id: deleteButton
            visible: model.downloadFinished
            myText: "Delete"
            bottonType: Style.RoleEnum.BottonType.Danger
            onClicked:{

            }
        }
    // }
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


// T.Button {
//     id: control
//     width: 200
//     height: 30

//     leftPadding: 4
//     rightPadding: 4

//     text: control.state

//     autoExclusive: false
//     checkable: true

//     property color backgrounDownloadNormalColor:  "#ebebeb" /*"#cbcdff"*/
//     property color backgrounDownloadHoverColor: "#ffffff"
//     property color backgrounDeleteNormalColor: "#5b5fc7"
//     property color backgrounDeleteHoverColor:/* "#cbcdff"*/ "#ffffff"
//     property color borderColor: "#ffffff"
//     property color fontColor: "#000000"
//     property int fontSize: 12


//     property bool isDownload
//     property bool isCancel
//     property bool isDelete
//     property double progressValue: 0
//     property int percent: progressValue*100

//     background: Rectangle {
//         id: backgroundId
//         color: control.backgrounDownloadNormalColor
//         radius: 2
//         anchors.fill: parent
//         border.color: control.borderColor
//         border.width: 2

//         Rectangle{
//             id:whenDownloadModel
//             anchors.fill: parent
//             border.color: control.borderColor
//             border.width: 2
//             visible: control.isDownload
//             color: "#00ffffff"
//             Text {
//                 id: downloadText
//                 color: control.fontColor
//                 text: qsTr("Download Model")
//                 anchors.verticalCenter: parent.verticalCenter
//                 font.pixelSize: control.fontSize
//                 horizontalAlignment: Text.AlignHCenter
//                 verticalAlignment: Text.AlignVCenter
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 font.family: Style.Theme.fontFamily
//             }
//         }
//         Rectangle{
//             id: whenCancle
//             anchors.fill: parent
//             visible: control.isCancel
//             border.color: control.borderColor
//             border.width: 2
//             color: "#00ffffff"
//             ProgressBar {
//                 id: progressBar
//                 value: control.progressValue
//                 anchors.fill: parent
//                 background: Rectangle {
//                     color: "#00ffffff"
//                     implicitHeight: 45
//                     radius: 2
//                     border.color: control.borderColor
//                     border.width: 2
//                 }

//                 contentItem:Item{
//                     implicitHeight: 30
//                     Rectangle {
//                         width: progressBar.visualPosition * parent.width
//                         height: parent.height
//                         radius: 2
//                         color: control.backgrounDeleteNormalColor
//                         border.color: control.borderColor
//                         border.width: 2
//                     }
//                 }
//             }
//             Text {
//                 id: percentText
//                 color: control.fontColor
//                 text: "%" + control.percent
//                 anchors.verticalCenter: parent.verticalCenter
//                 font.pixelSize: control.fontSize
//                 horizontalAlignment: Text.AlignHCenter
//                 verticalAlignment: Text.AlignVCenter
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 font.family: Style.Theme.fontFamily
//                 visible: !control.hovered
//             }
//             Text {
//                 id: cancleText
//                 color: control.fontColor
//                 text: "Cancel"
//                 anchors.verticalCenter: parent.verticalCenter
//                 font.pixelSize: control.fontSize
//                 horizontalAlignment: Text.AlignHCenter
//                 verticalAlignment: Text.AlignVCenter
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 font.family: Style.Theme.fontFamily
//                 visible: control.hovered
//             }
//         }
//         Rectangle{
//             id:whenDeleteModel
//             anchors.fill: parent
//             border.color: control.borderColor
//             border.width: 2
//             color: "#00ffffff"
//             visible: control.isDelete
//             Text {
//                 id: deleteText
//                 color: control.fontColor
//                 text: qsTr("Delete Model")
//                 anchors.verticalCenter: parent.verticalCenter
//                 font.pixelSize: control.fontSize
//                 horizontalAlignment: Text.AlignHCenter
//                 verticalAlignment: Text.AlignVCenter
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 font.family: Style.Theme.fontFamily
//             }
//         }
//     }

//     states: [
//         State {
//             name: "hover"
//             when: control.hovered || control.pressed

//             PropertyChanges {
//                 target: backgroundId
//                 color: isDelete? control.backgrounDeleteHoverColor: control.backgrounDownloadHoverColor
//             }
//         },
//         State {
//             name: "normal"
//             when: !control.pressed &&!control.hovered

//             PropertyChanges {
//                 target: backgroundId
//                 color: isDelete? control.backgrounDeleteNormalColor: control.backgrounDownloadNormalColor
//             }
//         }
//     ]
// }
