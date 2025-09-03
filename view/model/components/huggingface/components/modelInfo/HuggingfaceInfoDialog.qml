import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import '../../../../../component_library/style' as Style
import "../../../../../component_library/button"
import "./components"

Dialog {
    id: settingsDialogId
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: Math.min( 800 , parent.width-40)
    height: Math.min( 600 , parent.height-40)

    property bool isDesktopSize: width >= 630;
    onIsDesktopSizeChanged: {
        settingsDialogId.close()
        if(settingsDialogId.isDesktopSize){
            settingsDialogId.isOpenMenu = true
        }
    }

    property bool isOpenMenu: true
    onIsOpenMenuChanged: {
        if(settingsDialogId.isOpenMenu){
            if(settingsDialogId.isDesktopSize){
                settingsMenuId.width = 200
            }else{
                settingsDialogId.open()
            }
        }else{
            if(settingsDialogId.isDesktopSize){
                settingsMenuId.width = 60
            }else{
                settingsDialogId.open()
            }
        }
    }

    focus: true
    modal: true

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        width: window.width
        height: window.height - 40
        y: 40
        color: Style.Colors.overlayDrawer
    }

    background: null
    contentItem:Rectangle{
        id: backgroundId
        anchors.fill: parent

        radius: 10
        border.width: 1
        border.color: Style.Colors.boxBorder
        color: Style.Colors.background

        HugginfaceDialogView{
            visible: huggingfaceModelList.hugginfaceInfo &&
                     huggingfaceModelList.hugginfaceInfo.successModelProcess
            anchors.fill: parent
            anchors.margins: 24
        }

        Item{
            id: connectionFail
            visible: huggingfaceModelList.hugginfaceInfo &&
                     !huggingfaceModelList.hugginfaceInfo.successModelProcess &&
                     !huggingfaceModelList.hugginfaceInfo.loadModelProcess
            anchors.fill: parent
            anchors.margins: 10
            Label {
                id: createdAtText
                text: "connectionFail"
                color: Style.Colors.textInformation
                font.pixelSize: 50
                font.italic: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Item{
            id: loadInProgress
            visible: huggingfaceModelList.hugginfaceInfo &&
                     !huggingfaceModelList.hugginfaceInfo.successModelProcess &&
                     huggingfaceModelList.hugginfaceInfo.loadModelProcess
            anchors.fill: parent
            anchors.margins: 10
            Label {
                id: createdAtText2
                text: "loadInProgress"
                color: Style.Colors.textInformation
                font.pixelSize: 50
                font.italic: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        layer.enabled: true
        layer.effect: Glow {
             samples: 40
             color:  Style.Colors.boxBorder
             spread: 0.1
             transparentBorder: true
         }
    }
}
