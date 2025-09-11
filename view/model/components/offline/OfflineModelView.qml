import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects
import '../../../component_library/style' as Style

Item {
    function setFilter(filter){
        headerId.filtter = filter
    }

    OfflineHeader{
        id: headerId
        width: parent.width - (window.isDesktopSize? 330: 210)
        anchors.top: parent.top; anchors.topMargin: 12
        anchors.right: parent.right; anchors.rightMargin:12
    }
    OfflineBody{
        id:offlineBodyId
        anchors.top: headerId.bottom; anchors.topMargin: 8
        anchors.bottom: parent.bottom
        anchors.left: parent.left; anchors.right: parent.right
        clip:true
    }
    ToolButton {
        id: iconButtonId
        anchors.right: parent.right; anchors.rightMargin: 75 - (iconButtonId.width/2)
        anchors.bottom: parent.bottom; anchors.bottomMargin: 55 - (iconButtonId.height/2)
        width:iconButtonId.hovered? 55: 50; height: iconButtonId.hovered? 55: 50
        Behavior on width{ NumberAnimation{ duration: 150}}
        Behavior on height{ NumberAnimation{ duration: 150}}
        background: Rectangle {
            radius: 50
            color: iconButtonId.hovered? Style.Colors.buttonPrimaryHover: Style.Colors.buttonPrimaryNormal
            layer.enabled: true
            layer.effect: Glow {
                 samples: 60
                 color:  Style.Colors.boxBorder
                 spread: 0.3
                 transparentBorder: true
             }
        }
        icon{
            source: "qrc:/media/icon/add.svg"
            color: "white"
            width: iconButtonId.width ; height: iconButtonId.height
        }
        onClicked:{
            fileDialogId.open();
        }
        FileDialog{
            id: fileDialogId
            title: "Choose file"
            nameFilters: ["Text files (*.gguf)"]
            fileMode: FileDialog.OpenFiles
            onAccepted: function(){
                offlineModelList.addRequest(currentFile)
            }
        }
    }
}
