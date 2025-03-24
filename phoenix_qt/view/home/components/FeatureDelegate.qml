import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import '../../component_library/style' as Style
import "../../component_library/button"

T.Button {
    id: control
    width: 250
    height: 250

    property var myText
    property var myIcon
    property var about
    property var gitHubLink
    property var notebookLink
    property int goPage

    background:null

    contentItem:Rectangle{
        id: backgroundId
        anchors.fill: parent
        radius: 10
        border.width: 1
        border.color: Style.Colors.boxBorder
        color: Style.Colors.boxHover

        Column{
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10
            Row{
                id: headerId
                MyIcon {
                    id: iconButtonId
                    myIcon: control.myIcon
                    iconType: Style.RoleEnum.IconType.Primary
                    enabled: false
                    width:42; height:42
                }

                Label {
                    id: titleId
                    text: control.myText
                    color: Style.Colors.textTitle
                    anchors.verticalCenter: iconButtonId.verticalCenter
                    font.pixelSize: 14
                    font.styleName: "Bold"
                }
            }
            Label{
                id: informationId
                height: parent.height - headerId.height - buttonList.height - 20
                width: parent.width
                text: control.about
                color: Style.Colors.textInformation
                font.pixelSize: 12
                horizontalAlignment: Text.AlignJustify
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
                elide: Label.ElideRight
                clip: true
                MouseArea {
                    id: infoMouseArea
                    anchors.fill: informationId
                    hoverEnabled: true

                    onPositionChanged: {
                        toolTip.x = mouseX
                        toolTip.y = mouseY
                    }

                    ToolTip {
                        id: toolTip
                        visible: infoMouseArea.containsMouse
                        width: 400
                        delay: 500
                        timeout: 5000
                        contentItem: Label {
                            id: toolTipId
                            width: 400
                            text: control.about
                            wrapMode: Text.Wrap
                            color: Style.Colors.toolTipText
                            font.pixelSize: 10
                        }

                        background: Rectangle {
                            width: toolTipId.width + 20
                            height: toolTipId.height + 10
                            color: Style.Colors.toolTipBackground
                            border.color: Style.Colors.toolTipGlowAndBorder
                            radius: 4
                            layer.enabled: true
                            layer.effect: Glow {
                                samples: 30
                                color: Style.Colors.toolTipGlowAndBorder
                                spread: 0.4
                                transparentBorder: true
                            }
                        }
                    }
                }

                // ToolTip{
                //     visible: control.hovered
                //     width: 400
                //     x: informationId.x
                //     y: informationId.y
                //     delay: 500
                //     timeout: 10000
                //     contentItem: Label {
                //         id: toolTipId
                //         width: 400
                //         text: control.about
                //         wrapMode: Text.Wrap
                //         color:Style.Colors.toolTipText
                //         font.pixelSize: 10
                //     }

                //     background: Rectangle{
                //         id: backgroundId2
                //         width: toolTipId.parent; height: toolTipId.height + 10
                //         anchors.horizontalCenter: parent.horizontalCenter
                //         anchors.verticalCenter: parent.verticalCenter
                //         anchors.margins: 2
                //         color: Style.Colors.toolTipBackground
                //         border.color: Style.Colors.toolTipGlowAndBorder
                //         radius: 4
                //         layer.enabled: true
                //         layer.effect: Glow {
                //              samples: 30
                //              color: Style.Colors.toolTipGlowAndBorder
                //              spread: 0.4
                //              transparentBorder: true
                //          }
                //     }
                // }
            }
            Row{
                id: buttonList
                spacing: 10
                anchors.right: parent.right
                MyButton{
                    id:goPageId
                    visible: control.goPage !== -1
                    myText: "Select"
                    bottonType: Style.RoleEnum.BottonType.Primary
                    Connections {
                        target: goPageId
                        function onClicked(){
                            appBodyId.currentIndex = 1
                        }
                    }
                }
                MyButton{
                    id:goToGithubId
                    visible: control.gitHubLink !== ""
                    myText: "GitHub"
                    bottonType: Style.RoleEnum.BottonType.Primary
                    Connections {
                        target: goToGithubId
                        function onClicked(){
                            Qt.openUrlExternally(control.gitHubLink)
                        }
                    }
                }
                MyButton{
                    id:goToNotebookId
                    visible: control.notebookLink !== ""
                    myText: "Notebook"
                    bottonType: Style.RoleEnum.BottonType.Primary
                    Connections {
                        target: goToNotebookId
                        function onClicked(){
                            Qt.openUrlExternally(control.notebookLink)
                        }
                    }
                }

            }
        }

        layer.enabled: control.hovered? true: false
        layer.effect: Glow {
             samples: 40
             color:  Style.Colors.boxBorder
             spread: 0.1
             transparentBorder: true
         }
    }
}

