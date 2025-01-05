import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import 'style' as Style

Item {
    id: control
    width: 250
    height: 250

    signal chatViewRequested2()

    property alias myTextId: titleId.text
    property var myIcon
    property var about
    property var gitHubLink
    property var notebookLink
    property int goPage

    property int titleFontSize: 14
    property int informationFontSize: 12


    Rectangle{
        id: backgroundId
        anchors.fill: parent
        color: Style.Theme.boxColor
        radius: 2
        border.color: Style.Theme.boxColor
        border.width: 0

        gradient: Gradient {
            GradientStop {
                position: 0
                color: Style.Theme.backgroundPageColor
            }

            GradientStop {
                position: 1
                color: Style.Theme.backgroungColor
            }
            orientation: Gradient.Vertical
        }

        Rectangle {
            id: newChatBox
            width: 40
            height: 40
            color: Style.Theme.fillIconColor
            radius: 4
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 20
            anchors.topMargin: 20
            Image {
                id: newChatIcon
                height: 28
                width: 28
                anchors.verticalCenter: parent.verticalCenter
                source: control.myIcon
                sourceSize.height: 28
                sourceSize.width: 28
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
            }
            ColorOverlay {
                id: colorOverlayNewChatIcon
                anchors.fill: newChatIcon
                source: newChatIcon
                color: "#ffffff"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: function() {}
            }
        }

        Text {
            id: titleId
            color: Style.Theme.titleTextColor
            text: qsTr("Title")
            anchors.verticalCenter: newChatBox.verticalCenter
            anchors.left: newChatBox.right
            anchors.leftMargin: 12
            font.pixelSize: control.titleFontSize
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.styleName: "Bold"
            font.family: Style.Theme.fontFamily
        }

        Text{
            id:informationId
            text: control.about
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: newChatBox.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.topMargin: 10
            anchors.bottomMargin: 20 + goPageId.height
            font.pixelSize: control.informationFontSize
            horizontalAlignment: Text.AlignJustify
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
            font.family: Style.Theme.fontFamily
            color: Style.Theme.informationTextColor
        }

        MyButton{
            id:goPageId
            visible: control.goPage !== -1
            width: (parent.width-50)/2
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            myTextId: "Select"
            Connections {
                target: goPageId
                function onClicked(){
                    control.chatViewRequested2()
                }
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
            myTextId: "GitHub"
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
            width: (parent.width-50)/2
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 20
            anchors.bottomMargin: 20
            myTextId: "Notebook"
            Connections {
                target: goToNotebookId
                function onClicked(){
                    Qt.openUrlExternally(control.notebookLink)
                }
            }
        }

        layer.enabled: true
        layer.effect: Glow {
             samples: 40
             color:  Style.Theme.glowColor
             spread: 0.4
             transparentBorder: true
         }
    }
}

