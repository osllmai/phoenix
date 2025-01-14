import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import '../../component_library/style' as Style
import "../../component_library/button"

Item {
    id: control
    width: 250
    height: 250

    property var myText
    property var myIcon
    property var about
    property var gitHubLink
    property var notebookLink
    property int goPage

    Rectangle{
        id: backgroundId
        anchors.fill: parent
        radius: 10
        border.width: 0
        border.color: Style.Colors.boxBorder

        gradient: Gradient {
            GradientStop {
                position: 0
                color: Style.Colors.boxGradient0
            }

            GradientStop {
                position: 1
                color: Style.Colors.boxGradient1
            }
            orientation: Gradient.Vertical
        }

        Rectangle {
            id: newChatBox
            width: newChatIcon.width
            height: newChatIcon.height
            color: "#00ffffff"
            radius: 4
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 20
            anchors.topMargin: 20
            Image {
                id: newChatIcon
                height: 28; width: 28
                sourceSize.height: 28; sourceSize.width: 28
                source: control.myIcon
                fillMode: Image.PreserveAspectFit
            }
            ColorOverlay {
                id: colorOverlayNewChatIcon
                anchors.fill: newChatIcon
                source: newChatIcon
                color: Style.Colors.iconHoverAndChecked
            }
        }

        Text {
            id: titleId
            text: control.myText
            color: Style.Colors.textTitle
            anchors.verticalCenter: newChatBox.verticalCenter
            anchors.left: newChatBox.right
            anchors.leftMargin: 12
            font.pixelSize: 14
            font.styleName: "Bold"
        }

        Text{
            id:informationId
            text: control.about
            color: Style.Colors.textInformation
            clip: true
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: newChatBox.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.topMargin: 10
            anchors.bottomMargin: 25 + goPageId.height
            font.pixelSize: 12
            horizontalAlignment: Text.AlignJustify
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
        }

        MyButton{
            id:goPageId
            visible: control.goPage !== -1
            width: (parent.width-50)/2
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            myText: "Select"
            bottonType: Style.RoleEnum.BottonType.Primary
            Connections {
                target: goPageId
                // propagateComposedEvents: true
                function onClicked(){}
            }
        }
        MyButton{
            id:goToGithubId
            visible: control.gitHubLink !== ""
            width: (parent.width-50)/2
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            myText: "GitHub"
            bottonType: Style.RoleEnum.BottonType.Primary
            Connections {
                target: goToGithubId
                // propagateComposedEvents: true
                function onClicked(){
                    Qt.openUrlExternally(control.gitHubLink)
                }
            }
        }
        MyButton{
            id:goToNotebookId
            visible: control.notebookLink !== ""
            width: (parent.width-50)/2
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 20
            anchors.bottomMargin: 20
            myText: "Notebook"
            bottonType: Style.RoleEnum.BottonType.Primary
            Connections {
                target: goToNotebookId
                // propagateComposedEvents: true
                function onClicked(){
                    Qt.openUrlExternally(control.notebookLink)
                }
            }
        }

        layer.enabled: true
        layer.effect: Glow {
             samples: 2
             color:  Style.Colors.boxBorder
             spread: 0.1
             transparentBorder: true
         }
    }
}

