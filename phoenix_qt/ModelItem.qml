import QtQuick 2.15
import QtQuick.Dialogs
import Phoenix
import Qt5Compat.GraphicalEffects
import 'style' as Style

Item{
    id: control
    width: 250
    height: 250

    property var myModel
    property var myModelListModel
    property int myIndex

    property int titleFontSize: 14
    property int informationFontSize: 10

    property int xNotification
    property int yNotification


    Rectangle{
        id: backgroundId
        anchors.fill: parent
        color: Style.Theme.boxColor
        radius: 4
        border.color: Style.Theme.hoverButtonColor
        border.width: 0

        gradient: Gradient {
            GradientStop {
                position: 0
                color: Style.Theme.backgroundPageColor
            }

            GradientStop {
                position: 1
                color: Style.Theme.backgroungColor
            }
            orientation: Gradient.Vertical
        }

        Rectangle {
            id: modelIconBox
            width: 40
            height: 40
            color: "#00ffffff"
            radius: 4
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 20
            anchors.topMargin: 20
            Image {
                id: modelIcon
                height: 32
                width: 32
                anchors.verticalCenter: parent.verticalCenter
                source: control.myModel.icon
                sourceSize.height: 32
                sourceSize.width: 32
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
            }
            MouseArea{
                anchors.fill: parent
                onClicked: function() {}
            }
        }

        Text {
            id: modelName
            color: Style.Theme.titleTextColor
            text: control.myModel.name
            anchors.verticalCenter: modelIconBox.verticalCenter
            anchors.left: modelIconBox.right
            anchors.leftMargin: 10
            font.pixelSize: control.titleFontSize
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.styleName: "Bold"
            font.family: Style.Theme.fontFamily
        }

        Text{
            id:informationId
            color: Style.Theme.informationTextColor
            text: control.myModel.information
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: modelIconBox.bottom
            anchors.bottom: informationAboutDownload.top
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            font.pixelSize: control.informationFontSize
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
            font.family: Style.Theme.fontFamily
        }
        Rectangle{
            id:informationAboutDownload
            height: 55
            color: "#00ffffff"
            radius: 10
            border.color: Style.Theme.informationTextColor
            border.width: 1
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: downloadButton.top
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.bottomMargin: 10
            Rectangle{
                id:fileSizeBox
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                width: (parent.width/4)-8
                color: "#00ffffff"
                Text {
                    id: fileSizeText
                    color: Style.Theme.informationTextColor
                    text: qsTr("File size")
                    font.styleName: "Bold"
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: Style.Theme.fontFamily
                }
                Text {
                    id: fileSizeValue
                    color: Style.Theme.informationTextColor
                    text: control.myModel.fileSize + " GB"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: Style.Theme.fontFamily
                }
            }
            Rectangle{
                id:line1
                width: 1
                color: Style.Theme.informationTextColor
                anchors.left: fileSizeBox.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
            }
            Rectangle{
                id: ramRequiredBox
                anchors.left: line1.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                width: (parent.width/4)+20
                color: "#00ffffff"
                Text {
                    id: ramRequiredText
                    color: Style.Theme.informationTextColor
                    text: qsTr("RAM requierd")
                    font.styleName: "Bold"
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: Style.Theme.fontFamily
                }
                Text {
                    id: ramRequiredValue
                    color: Style.Theme.informationTextColor
                    text: control.myModel.ramRamrequired + " GB"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: Style.Theme.fontFamily
                }
            }
            Rectangle{
                id:line2
                width: 1
                color: Style.Theme.informationTextColor
                anchors.left: ramRequiredBox.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
            }
            Rectangle{
                id: parameterersBox
                color: "#00ffffff"
                anchors.left: line2.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                width: (parent.width/4)
                Text {
                    id: parameterersText
                    color: Style.Theme.informationTextColor
                    text: qsTr("Parameters")
                    font.styleName: "Bold"
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: Style.Theme.fontFamily
                }
                Text {
                    id: parameterersValue
                    color: Style.Theme.informationTextColor
                    text: control.myModel.parameters
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    font.pointSize: 8
                    font.family: Style.Theme.fontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                id:line3
                width: 1
                color: Style.Theme.informationTextColor
                anchors.left: parameterersBox.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
            }
            Rectangle{
                id: quantBox
                color: "#00ffffff"
                anchors.left: line3.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                Text {
                    id: quantText
                    color: Style.Theme.informationTextColor
                    text: qsTr("Quant")
                    font.styleName: "Bold"
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: "Times New Roman"
                }
                Text {
                    id: quantValue
                    color: Style.Theme.informationTextColor
                    text: control.myModel.quant
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    font.pointSize: 8
                    font.family: "Times New Roman"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

        }


        DownloadModelButton{
            id:downloadButton
            borderColor: Style.Theme.hoverButtonColor
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.bottomMargin: 20

            // fontFamily: Style.Theme.fontFamily

            isDownload: !control.myModel.isDownloading && !control.myModel.downloadFinished
            isCancel: control.myModel.isDownloading && !control.myModel.downloadFinished
            isDelete: control.myModel.downloadFinished
            progressValue: control.myModel.downloadPercent

            FolderDialog {
                id: folderDialogId
                title: "Choose Folder"
                currentFolder: folderDialogId.currentFolder

                onAccepted: {
                    control.myModelListModel.downloadRequest(control.myIndex, currentFolder)
                    console.log(currentFolder)
                }
                onRejected: {
                    console.log("Rejected");
                }
            }

            Connections {
                target: downloadButton
                function onClicked(){
                    if(!control.myModel.isDownloading && !control.myModel.downloadFinished){
                        downloadRequest.open();
                    }else if(control.myModel.isDownloading && !control.myModel.downloadFinished){
                        deleteRequest.open();
                    }else {
                        deleteRequest.open();
                    }
                }
            }
        }

        Notification{
            id: downloadRequest
            title:"Path for Download"
            about:"F://Zeinab/"
            textBotton1: "Download In Defult Path"
            textBotton2: "Select Folder"

            Connections{
                target: downloadRequest
                function onBottonAction1(){
                    control.myModelListModel.downloadRequest(control.myIndex)
                    downloadRequest.close()
                }

                function onBottonAction2(){
                    folderDialogId.open();
                    downloadRequest.close()
                }
            }
        }

        Notification{
            id: deleteRequest
            title:"Delete LLM Model"
            about:"Are you sure you want to delete the LLM model? \nThis action is irreversible and may result in the loss of data or settings associated with the model."
            textBotton1: "Cancel"
            textBotton2: "Delete"

            Connections{
                target: deleteRequest
                function onBottonAction1(){
                    deleteRequest.close()
                }

                function onBottonAction2(){
                    if(control.myModel.isDownloading && !control.myModel.downloadFinished){
                        control.myModelListModel.cancelRequest(control.myIndex);
                    }else {
                        control.myModelListModel.deleteRequest(control.myIndex);
                    }
                    deleteRequest.close()
                }
            }
        }

        layer.enabled: true
        layer.effect: Glow {
             samples: 40
             color: Style.Theme.glowColor
             spread: 0.4
             transparentBorder: true
         }
    }
}
