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

        gradient: Gradient {
            GradientStop {
                position: 0
                color: control.hovered? Style.Colors.boxHoverGradient0: Style.Colors.boxNormalGradient0
            }

            GradientStop {
                position: 1
                color: control.hovered? Style.Colors.boxHoverGradient1: Style.Colors.boxNormalGradient1
            }
            orientation: Gradient.Vertical
        }

        Column{
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10
            Row{
                id: headerId
                ToolButton {
                    id: iconButtonId
                    background: null
                    icon{
                        source: control.myIcon
                        color: Style.Colors.iconHoverAndChecked
                        width:28; height:28
                    }
                }

                Text {
                    id: titleId
                    text: control.myText
                    color: Style.Colors.textTitle
                    anchors.verticalCenter: iconButtonId.verticalCenter
                    font.pixelSize: 14
                    font.styleName: "Bold"
                }
            }
            Item{
                id: bodyId
                height: parent.height - headerId.height - buttonList.height - 20
                width: parent.width
                Label{
                    id:informationId
                    text: control.about
                    color: Style.Colors.textInformation
                    clip: true
                    anchors.left: parent.left; anchors.right: parent.right
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignJustify
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }

            }


            Row{
                id: buttonList
                spacing: 10
                MyButton{
                    id:goPageId
                    visible: control.goPage !== -1
                    myText: "Select"
                    bottonType: Style.RoleEnum.BottonType.Primary
                    Connections {
                        target: goPageId
                        function onActionClicked(){}
                    }
                }
                MyButton{
                    id:goToGithubId
                    visible: control.gitHubLink !== ""
                    myText: "GitHub"
                    bottonType: Style.RoleEnum.BottonType.Primary
                    Connections {
                        target: goToGithubId
                        function onActionClicked(){
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
                        function onActionClicked(){
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

