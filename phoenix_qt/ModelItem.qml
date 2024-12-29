import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Layouts
import QtQuick.Dialogs
import Phoenix
import Qt5Compat.GraphicalEffects


Item{
    id: control
    width: 250
    height: 250

    property Model myModel
    property var myModelListModel
    property int myIndex

    property color backgroundPageColor
    property color backgroungColor
    property color glowColor
    property color boxColor
    property color headerColor
    property color normalButtonColor
    property color selectButtonColor
    property color hoverButtonColor
    property color fillIconColor

    property color titleTextColor
    property color informationTextColor
    property color selectTextColor

    property var fontFamily

    property int titleFontSize: 14
    property int informationFontSize: 10

    property int xNotification
    property int yNotification


    Rectangle{
        id: backgroundId
        anchors.fill: parent
        color: control.boxColor
        radius: 4
        border.color: control.hoverButtonColor
        border.width: 0

        gradient: Gradient {
            GradientStop {
                position: 0
                color: control.backgroundPageColor
            }

            GradientStop {
                position: 1
                color: control.backgroungColor
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
            color: control.titleTextColor
            text: control.myModel.name
            anchors.verticalCenter: modelIconBox.verticalCenter
            anchors.left: modelIconBox.right
            anchors.leftMargin: 10
            font.pixelSize: control.titleFontSize
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.styleName: "Bold"
            font.family: control.fontFamily
        }

        Text{
            id:informationId
            color: control.informationTextColor
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
            font.family: control.fontFamily
        }
        Rectangle{
            id:informationAboutDownload
            height: 55
            color: "#00ffffff"
            radius: 10
            border.color: control.informationTextColor
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
                    color: control.informationTextColor
                    text: qsTr("File size")
                    font.styleName: "Bold"
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: control.fontFamily
                }
                Text {
                    id: fileSizeValue
                    color: control.informationTextColor
                    text: control.myModel.fileSize + " GB"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: control.fontFamily
                }
            }
            Rectangle{
                id:line1
                width: 1
                color: control.informationTextColor
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
                    color: control.informationTextColor
                    text: qsTr("RAM requierd")
                    font.styleName: "Bold"
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: control.fontFamily
                }
                Text {
                    id: ramRequiredValue
                    color: control.informationTextColor
                    text: control.myModel.ramRamrequired + " GB"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: control.fontFamily
                }
            }
            Rectangle{
                id:line2
                width: 1
                color: control.informationTextColor
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
                    color: control.informationTextColor
                    text: qsTr("Parameters")
                    font.styleName: "Bold"
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: control.fontFamily
                }
                Text {
                    id: parameterersValue
                    color: control.informationTextColor
                    text: control.myModel.parameters
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    font.pointSize: 8
                    font.family: control.fontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                id:line3
                width: 1
                color: control.informationTextColor
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
                    color: control.informationTextColor
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
                    color: control.informationTextColor
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
            borderColor: control.hoverButtonColor
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.bottomMargin: 20

            fontFamily: control.fontFamily

            isDownload: !control.myModel.isDownloading && !control.myModel.downloadFinished
            isCancel: control.myModel.isDownloading && !control.myModel.downloadFinished
            isDelete: control.myModel.downloadFinished
            progressValue: control.myModel.downloadPercent

            FolderDialog {
                id: folderDialogId
                title: "Choose Folder"
                currentFolder: folderDialogId.currentFolder

                onAccepted: {
                    control.myModelListModel.downloadRequest(control.myModel.id, currentFolder)
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

            backgroundPageColor: control.backgroundPageColor
            backgroungColor: control.backgroungColor
            glowColor: control.glowColor
            boxColor: control.boxColor
            headerColor: control.headerColor
            normalButtonColor: control.normalButtonColor
            selectButtonColor: control.selectButtonColor
            hoverButtonColor: control.hoverButtonColor
            fillIconColor: control.fillIconColor

            titleTextColor: control.titleTextColor
            informationTextColor: control.informationTextColor
            selectTextColor: control.selectTextColor

            fontFamily: control.fontFamily

            title:"Path for Download"
            about:"F://Zeinab/"
            textBotton1: "Download In Defult Path"
            textBotton2: "Select Folder"

            Connections{
                target: downloadRequest
                function onBottonAction1(){
                    control.myModelListModel.downloadRequest(control.myModel.id)
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

            backgroundPageColor: control.backgroundPageColor
            backgroungColor: control.backgroungColor
            glowColor: control.glowColor
            boxColor: control.boxColor
            headerColor: control.headerColor
            normalButtonColor: control.normalButtonColor
            selectButtonColor: control.selectButtonColor
            hoverButtonColor: control.hoverButtonColor
            fillIconColor: control.fillIconColor

            titleTextColor: control.titleTextColor
            informationTextColor: control.informationTextColor
            selectTextColor: control.selectTextColor

            fontFamily: control.fontFamily

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
                        control.myModelListModel.cancelRequest(control.myModel.id);
                    }else {
                        control.myModelListModel.deleteRequest(control.myModel.id);
                    }
                    deleteRequest.close()
                }
            }
        }

        layer.enabled: true
        layer.effect: Glow {
             samples: 40
             color: control.glowColor
             spread: 0.4
             transparentBorder: true
         }
    }
}
