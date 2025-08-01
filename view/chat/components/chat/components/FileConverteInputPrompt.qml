import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style
import '../../../../component_library/button'

Rectangle{
    id: control
    width: window.isDesktopSize? parent.width/2 : parent.width
    height: 60
    color:  "#00ffffff"
    border.width: 1
    border.color: Style.Colors.boxBorder
    radius: 8

    property string filePath
    property string textMD
    property bool convertInProcess
    property bool isInputBox
    signal closeFile()

    function iconForFile(fileUrl) {
        let path = (typeof fileUrl === "string") ? fileUrl : fileUrl.toString();
        let ext = path.split('.').pop().toLowerCase();
        switch (ext) {
            case "docx": return "qrc:/media/icon/fileDocx.svg"
            case "pptx": return "qrc:/media/icon/filePptx.svg"
            case "html":
            case "htm": return "qrc:/media/icon/fileHtml.svg"
            case "jpg":
            case "jpeg": return "qrc:/media/icon/fileJpg.svg"
            case "png": return "qrc:/media/icon/filePng.svg"
            case "pdf": return "qrc:/media/icon/filePdf.svg"
            case "md": return "qrc:/media/icon/fileMd.svg"
            case "csv": return "qrc:/media/icon/fileCsv.svg"
            case "xlsx": return "qrc:/media/icon/fileXlsx.svg"
            case "xml": return "qrc:/media/icon/fileXml.svg"
            case "json": return "qrc:/media/icon/fileJson.svg"
            case "mp3": return "qrc:/media/icon/fileMp3Audio.svg"
            case "wav": return "qrc:/media/icon/fileWav.svg"
            default: return "qrc:/media/icon/filePdf.svg"
        }
    }

    Row{
        anchors.fill: parent

        Item {
            id: fileIconWithBusy
            width: 60
            height: 60

            MyIcon {
                id: pdfId
                anchors.centerIn: parent
                width: 40
                height: 40
                myIcon: control.iconForFile(control.filePath)
                iconType: Style.RoleEnum.IconType.Primary
                enabled: false
            }

            Loader {
                id: busyLoader
                anchors.centerIn: parent
                active: control.convertInProcess
                sourceComponent: BusyIndicator {
                    running: true
                    width: 60
                    height: 60

                    contentItem: Item {
                        implicitWidth: 60
                        implicitHeight: 60

                        Canvas {
                            id: spinnerCanvas
                            anchors.fill: parent
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                ctx.beginPath()
                                ctx.arc(width / 2, height / 2, width / 2 - 2, 0, Math.PI * 1.5)
                                ctx.lineWidth = 2
                                ctx.strokeStyle = Style.Colors.iconPrimaryHoverAndChecked;
                                ctx.stroke()
                            }
                            Component.onCompleted: requestPaint()
                        }

                        RotationAnimator on rotation {
                            from: 0
                            to: 360
                            duration: 1000
                            loops: Animation.Infinite
                            running: true
                        }
                    }
                }
            }
        }

        Item{
            width: parent.width -fileIconWithBusy.width - closeBox.width - 80
            height: parent.height
            Label {
                id: titleId
                visible: !titleAndCopy.visible
                text: {
                    var pathParts = control.filePath.split(/[/\\]/);
                    return pathParts[pathParts.length - 1];
                }
                color: Style.Colors.textTitle
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - copyId.width
                font.pixelSize: 14
                font.styleName: "Bold"
                clip: true
                elide: Label.ElideRight
            }
            MyCopyButton{
                id: copyId
                visible: !titleAndCopy.visible
                myText: TextArea{text: control.textMD}
                anchors.verticalCenter: titleId.verticalCenter
                anchors.right: parent.right
                clip: true
            }
            Row{
                id: titleAndCopy
                visible: parent.width - title2Id.implicitWidth - copy2Id.width > 0
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                clip: true
                Label {
                    id: title2Id
                    text: {
                        var pathParts = control.filePath.split(/[/\\]/);
                        return pathParts[pathParts.length - 1];
                    }
                    color: Style.Colors.textTitle
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 14
                    font.styleName: "Bold"
                    clip: true
                    elide: Label.ElideRight
                }
                MyCopyButton{
                    id: copy2Id
                    myText: TextArea{text: control.textMD;}
                    anchors.verticalCenter: title2Id.verticalCenter
                    clip: true
                }
            }
        }
    }
    MyIcon{
        id: closeBox
        visible: control.isInputBox
        anchors.right: parent.right; anchors.rightMargin: 10;
        anchors.top: parent.top; anchors.topMargin: 10;
        width: 30; height: 30
        myIcon: "qrc:/media/icon/close.svg"
        myTextToolTip: "Close"
        isNeedAnimation: true
        onClicked: {
            control.closeFile()
        }
    }
}
