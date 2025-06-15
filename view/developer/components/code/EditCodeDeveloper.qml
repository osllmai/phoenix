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
            width: parent.width
            height:  parent.height - rowMethodId.height - 8
            ScrollView {
                id: scrollInstruction
                anchors.fill: parent
                clip: true

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

                ScrollBar.horizontal: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

                TextArea {
                    id: textId
                    width: scrollInstruction.width
                    height: implicitHeight
                    readOnly: true
                    wrapMode: Text.NoWrap
                    color: Style.Colors.textInformation
                    font.family: "Courier New"
                    font.pointSize: 10
                    background: Rectangle {
                        radius: 8
                        color: Style.Colors.boxNormalGradient0
                        border.color: Style.Colors.boxBorder
                    }
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
                width: editId.width + copyId.width
                height: Math.max(editId.height, copyId.height)
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 10
                property bool checkCopy: false

                MyIcon {
                    id: editId
                    myIcon: editId.hovered? "qrc:/media/icon/editFill.svg": "qrc:/media/icon/edit.svg"
                    iconType: Style.RoleEnum.IconType.Primary
                    width: 26; height: 26
                    Connections{
                        target: editId
                        function onClicked(){

                        }
                    }
                }

                MyIcon {
                    id: copyId
                    visible: control.hovered
                    myIcon: copyId.selectIcon()
                    iconType: Style.RoleEnum.IconType.Primary
                    width: 26; height: 26
                    Connections{
                        target: copyId
                        function onClicked(){
                            textId.selectAll()
                            textId.copy()
                            textId.deselect()
                            dateAndIconId.checkCopy= true
                            successTimer.start();
                        }
                    }

                    Timer {
                        id: successTimer
                        interval: 2000
                        repeat: false
                        onTriggered: dateAndIconId.checkCopy = false
                    }

                    function selectIcon(){
                        if(dateAndIconId.checkCopy === false){
                            return copyId.hovered? "qrc:/media/icon/copyFill.svg": "qrc:/media/icon/copy.svg"
                        }else{
                            return copyId.hovered? "qrc:/media/icon/copySuccessFill.svg": "qrc:/media/icon/copySuccess.svg"
                        }
                    }
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
