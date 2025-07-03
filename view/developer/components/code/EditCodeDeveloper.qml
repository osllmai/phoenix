import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import '../../../component_library/style' as Style
import '../../../component_library/button'

Dialog {
    id: settingsDialogId
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: Math.min( 600 , parent.width-40)
    height: Math.min( 400 , parent.height-40)

    property bool isDesktopSize: width >= 630;
    onIsDesktopSizeChanged: {
        settingsMenuDerawerId.close()
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
                settingsMenuDerawerId.open()
            }
        }else{
            if(settingsDialogId.isDesktopSize){
                settingsMenuId.width = 60
            }else{
                settingsMenuDerawerId.open()
            }
        }
    }

    focus: true
    modal: true

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
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

        Item{
            anchors.fill: parent
            anchors.margins: 5
            anchors.top: parent.top
            anchors.topMargin: 40

            ScrollView {
                id: scrollInput
                width: parent.width
                height: parent.height
                ScrollBar.vertical.interactive: true

                ScrollBar.vertical.policy: scrollInput.contentHeight > scrollInput.height
                                           ? ScrollBar.AlwaysOn
                                           : ScrollBar.AlwaysOff

                ScrollBar.vertical.active: (scrollInput.contentY > 0) &&
                                (scrollInput.contentY < scrollInput.contentHeight - scrollInput.height)

                ScrollBar.horizontal.interactive: true

                ScrollBar.horizontal.policy: scrollInput.contentWidth > scrollInput.width
                                           ? ScrollBar.AlwaysOn
                                           : ScrollBar.AlwaysOff

                ScrollBar.horizontal.active: (scrollInput.contentX > 0) &&
                                (scrollInput.contentX < scrollInput.contentWidth - scrollInput.width)

                Component.onCompleted: {
                    scrollInput.contentItem.contentX = 0
                }

                onVisibleChanged: {
                    if (scrollInput.visible) {
                        scrollInput.contentItem.contentX = 0
                  }
                }

                TextArea {
                    id: textId
                    width: scrollInput.width
                    height: implicitHeight
                    wrapMode: Text.NoWrap
                    color: Style.Colors.textInformation
                    font.family: "Courier New"
                    font.pointSize: 10
                    padding: 10
                    cursorVisible: false
                    persistentSelection: false
                    clip: true

                    text: !codeDeveloperList.currentProgramLanguage.codeGenerator? "": codeDeveloperList.currentProgramLanguage.codeGenerator.text

                    onTextChanged: {
                        textId.cursorPosition = textId.length
                    }
                }
            }
            Row {
                id: dateAndIconId
                width: copyId.width
                height: copyId.height
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 10
                property bool checkCopy: false

                MyCopyButton{
                    id: copyId
                    myText: textId
                }
            }
        }

        Item{
            id: closeBox
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            width: 28; height: 28
            ToolButton {
                id: closeIcon
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width:closeIcon.hovered? 26: 25; height: closeIcon.hovered? 26: 25
                Behavior on width{ NumberAnimation{ duration: 150}}
                Behavior on height{ NumberAnimation{ duration: 150}}
                background: null
                icon{
                    source: "qrc:/media/icon/close.svg"
                    color: closeIcon.hovered? Style.Colors.iconPrimaryHoverAndChecked: Style.Colors.iconPrimaryNormal
                    width: closeIcon.width; height: closeIcon.height
                }
                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked:{settingsDialogId.close()}
                }
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
