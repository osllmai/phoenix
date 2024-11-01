import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Layouts
import QtQuick.Dialogs
import Phoenix
// import QtQuick.Studio.DesignEffects
import Qt5Compat.GraphicalEffects


Item{
    id: control
    width: 250
    height: 250


    property var myModel
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


    Rectangle{
        id: backgroundId
        anchors.fill: parent
        color: boxColor
        radius: 4
        border.color: hoverButtonColor
        border.width: 0

        Rectangle{
            id: recBackground
            height: 40
            color: boxColor
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 0
        }

        Rectangle {
            id: modelIconBox
            width: 40
            height: 40
            // color: fillIconColor
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
                source: myModel.icon
                sourceSize.height: 32
                sourceSize.width: 32
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
            }
            // ColorOverlay {
            //     id: colorOverlaymodelIcon
            //     anchors.fill: modelIcon
            //     source: modelIcon
            //     color: "#ffffff"
            // }
            MouseArea{
                anchors.fill: parent
                onClicked: function() {}
            }
        }

        Text {
            id: modelName
            color: control.titleTextColor
            text: myModel.name
            anchors.verticalCenter: modelIconBox.verticalCenter
            anchors.left: modelIconBox.right
            anchors.leftMargin: 10
            font.pixelSize: titleFontSize
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.styleName: "Bold"
            font.family: fontFamily
        }

        Text{
            id:informationId
            color: informationTextColor
            text: myModel.information
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: modelIconBox.bottom
            anchors.bottom: informationAboutDownload.top
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            font.pixelSize: informationFontSize
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
            font.family: fontFamily
        }
        Rectangle{
            id:informationAboutDownload
            height: 55
            color: "#00ffffff"
            radius: 10
            border.color: informationTextColor
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
                    color: informationTextColor
                    text: qsTr("File size")
                    font.styleName: "Bold"
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: fontFamily
                }
                Text {
                    id: fileSizeValue
                    color: informationTextColor
                    text: myModel.fileSize + " GB"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: fontFamily
                }
            }
            Rectangle{
                id:line1
                width: 1
                color:informationTextColor
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
                    color: informationTextColor
                    text: qsTr("RAM requierd")
                    font.styleName: "Bold"
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: fontFamily
                }
                Text {
                    id: ramRequiredValue
                    color: informationTextColor
                    text: myModel.ramRamrequired + " GB"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: fontFamily
                }
            }
            Rectangle{
                id:line2
                width: 1
                color:informationTextColor
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
                    color: informationTextColor
                    text: qsTr("Parameters")
                    font.styleName: "Bold"
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 8
                    font.family: fontFamily
                }
                Text {
                    id: parameterersValue
                    color: informationTextColor
                    text: myModel.parameters
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    font.pointSize: 8
                    font.family: fontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle{
                id:line3
                width: 1
                color:informationTextColor
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
                    text:myModel.quant
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
            borderColor: hoverButtonColor
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.bottomMargin: 20

            isDownload: !myModel.isDownloading && !myModel.downloadFinished
            isCancel: myModel.isDownloading && !myModel.downloadFinished
            isDelete: myModel.downloadFinished
            progressValue: myModel.downloadPercent

            // myModel: myModel

            FolderDialog {
                id: folderDialogId
                title: "Choose Folder"
                currentFolder: folderDialogId.currentFolder

                onAccepted: {
                    modelListModel.downloadRequest(index, currentFolder)
                    console.log(currentFolder)
                }
                onRejected: {
                    console.log("Rejected");
                }
            }

            Connections {
                target: downloadButton
                function onClicked(){
                    if(!myModel.isDownloading && !myModel.downloadFinished){
                        folderDialogId.open();
                    }else if(myModel.isDownloading && !myModel.downloadFinished){
                        modelListModel.cancelRequest(index);
                    }else {
                        modelListModel.deleteRequest(index);
                    }


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
