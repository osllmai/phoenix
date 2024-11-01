import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Item {
    id: root
    height: userTextRec.height
    width: userTextRec.width

    property int maxWidth: 300
    property bool isFinished: true
    property bool isLLM: true
    property var myText

    //theme for chat page
    property color chatBackgroungColor
    property color chatBackgroungConverstationColor
    property color chatMessageBackgroungColor
    property color chatMessageTitleTextColor
    property color chatMessageInformationTextColor
    property bool chatMessageIsGlow

    property color backgroungColor
    property color glowColor
    property color boxColor
    property color normalButtonColor
    property color selectButtonColor
    property color hoverButtonColor
    property color fillIconColor
    property color iconColor


    property color titleTextColor
    property color informationTextColor
    property color selectTextColor

    property var fontFamily


    Rectangle {
        id: userTextRec
        color: root.chatMessageBackgroungColor
        width: Math.min(Math.max( userText.implicitWidth, messageIcon.width+60 ) + 20, root.maxWidth)
        height: userText.implicitHeight + 30
        radius: 8

        Text {
            id: userText
            color: root.chatMessageInformationTextColor
            text: root.myText
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 10
            anchors.bottomMargin: 20
            verticalAlignment: Text.AlignTop
            textFormat: Text.MarkdownText
            wrapMode: Text.Wrap
            font.pointSize: 10
            font.family: root.fontFamily
            lineHeight: 1.1
        }

        Rectangle {
            id: messageIcon
            width: 60
            height: 20
            color: "#00ffffff" // Background color of tooltip
            radius: 4
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 3
            anchors.bottomMargin: 0
            visible: root.isFinished

            // Rounded corners
            MyIcon {
                id: icon1
                width: 20
                height: 20
                anchors.right: parent.right
                anchors.rightMargin: 0
                heightSource:16
                widthSource:16
                normalColor:root.iconColor
                hoverColor:root.fillIconColor
                myIconId: "images/deleteIcon.svg"
                myFillIconId: "images/fillDeleteIcon.svg"
                myLable:"Delete"
            }
            MyIcon {
                id: icon2
                width: 20
                height: 20
                anchors.right: icon1.left
                anchors.rightMargin: 0
                heightSource:13
                widthSource:13
                normalColor:root.iconColor
                hoverColor:root.fillIconColor
                myIconId: "images/copyIcon.svg"
                myFillIconId: "images/fillCopyIcon.svg"
                myLable:"Copy"
            }
            MyIcon {
                id: icon3
                width: 20
                height: 20
                anchors.right: icon2.left
                anchors.rightMargin: 0
                heightSource:14
                widthSource:14
                normalColor:root.iconColor
                hoverColor:root.fillIconColor
                myIconId: root.isLLM?"images/regenerateIcon.svg":"images/editIcon.svg"
                myFillIconId: root.isLLM?"images/fillRegenerateIcon.svg":"images/fillEditIcon.svg"
                myLable:root.isLLM? "Regenerate": "Edit"
            }
        }
        layer.enabled: root.chatMessageIsGlow
        layer.effect: Glow {
            samples: 30
            color: root.glowColor
            spread: 0.0
            transparentBorder: true
         }
    }
}
