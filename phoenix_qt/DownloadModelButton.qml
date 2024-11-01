import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Layouts
import QtQuick.Dialogs
import Phoenix
// import QtQuick.Studio.DesignEffects

T.Button {
    id: control
    width: 200
    height: 30

    Constants{
        id: constantsId
    }

    leftPadding: 4
    rightPadding: 4

    text: control.state

    autoExclusive: false
    checkable: true

    property color backgrounDownloadColor: "#ffffff"
    property color backgrounDeleteColor: "#ebebeb"
    property color borderColor: "#ebebeb"
    property color fontColor: "#000000"
    property int fontSize: 12
    property var fontFamily: constantsId.fontFamily


    property bool isDownload
    property bool isCancel
    property bool isDelete
    property double progressValue: 0
    property int percent: progressValue*100

    onIsDownloadChanged: function(){
        console.log("download start")
    }
    onIsCancelChanged: function(){
        console.log("cancel active")
    }
    onProgressValueChanged: function(){
        console.log("progressValue")
    }

    background: Rectangle {
        id: backgroundId
        color: backgrounDownloadColor
        radius: 2
        anchors.fill: parent
        border.color: borderColor
        border.width: 2

        Rectangle{
            id:whenDownloadModel
            anchors.fill: parent
            border.color: borderColor
            border.width: 2
            visible: isDownload
            Text {
                id: downloadText
                color: fontColor
                text: qsTr("Download Model")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: fontSize
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: fontFamily
            }
        }
        Rectangle{
            id: whenCancle
            anchors.fill: parent
            visible: isCancel
            border.color: borderColor
            border.width: 2
            ProgressBar {
                id: progressBar
                value: progressValue
                anchors.fill: parent
                background: Rectangle {
                    color: backgrounDownloadColor
                    implicitHeight: 45
                    radius: 2
                    border.color: borderColor
                    border.width: 2
                }

                contentItem:Item{
                    implicitHeight: 30
                    Rectangle {
                        width: progressBar.visualPosition * parent.width
                        height: parent.height
                        radius: 2
                        color: backgrounDeleteColor
                        border.color: borderColor
                        border.width: 2
                    }
                }
            }
            Text {
                id: cancleText
                color: fontColor
                text: "%" + percent
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: fontSize
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: fontFamily
            }
        }
        Rectangle{
            id:whenDeleteModel
            anchors.fill: parent
            border.color: borderColor
            border.width: 2
            color: control.backgrounDeleteColor
            visible: isDelete
            Text {
                id: deleteText
                color: fontColor
                text: qsTr("Delete Model")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: fontSize
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: fontFamily
            }
        }
    }

    states: [
        State {
            name: "hover"
            when: control.hovered || control.pressed

            PropertyChanges {
                target: backgroundId
                color: backgrounDeleteColor
            }
        },
        State {
            name: "normal"
            when: !control.pressed &&!control.hovered

            PropertyChanges {
                target: backgroundId
                color: backgrounDownloadColor
            }
        }
    ]
}
