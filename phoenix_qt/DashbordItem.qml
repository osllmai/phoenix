import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

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


    property color backgroundPageColor
    property color backgroungColor
    property color glowColor
    property color boxColor
    property color headerColor
    property color normalButtonColor
    property color selectButtonColor
    property color hoverButtonColor
    property color fillIconColor

    property color titleTextColor
    property color informationTextColor
    property color selectTextColor

    property var fontFamily


    property int titleFontSize: 14
    property int informationFontSize: 12


    Rectangle{
        id: backgroundId
        anchors.fill: parent
        color: boxColor
        radius: 2
        border.color: boxColor
        border.width: 0

        Rectangle {
            id: newChatBox
            width: 40
            height: 40
            color: fillIconColor
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
                source: myIcon
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
            color: titleTextColor
            text: qsTr("IndoxGen")
            anchors.verticalCenter: newChatBox.verticalCenter
            anchors.left: newChatBox.right
            anchors.leftMargin: 12
            font.pixelSize: titleFontSize
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.styleName: "Bold"
            font.family: fontFamily
        }

        Text{
            id:informationId
            text: about
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: newChatBox.bottom
            anchors.bottom: downloadButton.top
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            font.pixelSize: informationFontSize
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
            font.family: fontFamily
            color: control.informationTextColor
        }

        MyButton{
            id:goPageId
            visible: goPage !== -1
            width: (parent.width-50)/2
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            myTextId: "Select"
            Connections {
                target: goPageId
                function onClicked(){
                    chatViewRequested2()
                }
            }
        }

        MyButton{
            id:goToGithubId
            visible: gitHubLink !== ""
            width: (parent.width-50)/2
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            myTextId: "GitHub"
            Connections {
                target: goToGithubId
                function onClicked(){
                    Qt.openUrlExternally(gitHubLink)
                }
            }
        }
        MyButton{
            id:goToNotebookId
            visible: notebookLink !== ""
            width: (parent.width-50)/2
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 20
            anchors.bottomMargin: 20
            myTextId: "Notebook"
            Connections {
                target: goToNotebookId
                function onClicked(){
                    Qt.openUrlExternally(notebookLink)
                }
            }
        }

        layer.enabled: true
        layer.effect: Glow {
             samples: 40
             color:  root.glowColor
             spread: 0.4
             transparentBorder: true
         }
    }
}

