import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style
import '../../../../component_library/button'

Rectangle{
    id: allFileExist
    width: parent.width/2
    height: 60
    color:  "#00ffffff"
    border.width: 1
    border.color: Style.Colors.boxBorder
    radius: 8

    property string iconSource

    Row{
        anchors.fill: parent
        MyIcon {
            id: pdfId
            width: 60; height: 60
            myIcon: allFileExist.iconSource
            iconType: Style.RoleEnum.IconType.Image
        }
        Item{
            width: parent.width -pdfId.width - closeBox.width - 80
            height: parent.height
            Label {
                id: titleId
                visible: !titleAndCopy.visible
                text: {
                    var pathParts = convertToMD.filePath.split(/[/\\]/);
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
                myText: TextArea{text: convertToMD.textMD}
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
                        var pathParts = convertToMD.filePath.split(/[/\\]/);
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
                    myText: TextArea{text: convertToMD.textMD;}
                    anchors.verticalCenter: title2Id.verticalCenter
                    clip: true
                }
            }
        }
    }
    MyIcon{
        id: closeBox
        anchors.right: parent.right; anchors.rightMargin: 10;
        anchors.top: parent.top; anchors.topMargin: 10;
        width: 30; height: 30
        myIcon: "qrc:/media/icon/close.svg"
        myTextToolTip: "Close"
        isNeedAnimation: true
        onClicked: allFileExist.visible = false
    }
}
