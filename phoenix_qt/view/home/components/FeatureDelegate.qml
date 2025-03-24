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

                    MyToolTip{
                        id: toolTip
                        toolTipText: control.about
                    }
                }
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

