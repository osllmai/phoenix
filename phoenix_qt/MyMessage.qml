import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Item {
    id: root
    height: messageTextRec.height
    width: messageTextRec.width

    property int maxWidth: 300
    property bool isFinished: true

    //signal and text about message
    property bool isLLM: true
    property var myText
    signal regenerateOrEdit()
    signal nextMessage()
    signal beforMessage()
    property int numberOfMessage
    property int numberOfRegenerateOrEdit

    property var executionTime
    property var numberOfToken

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

    Rectangle{
        id: messageRec
        color: messageTextRec.color
        width:  messageTextRec.width
        height: messageTextRec.height
        radius: 8
        Rectangle {
            id: messageTextRec
            color: root.chatMessageBackgroungColor
            width: Math.min(messageText.implicitWidth + 20, root.maxWidth)
            height: root.isLLM == true? messageText.implicitHeight + 30: messageText.implicitHeight+ 20
            radius: 8

            Text {
                id: messageText
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

            layer.enabled: root.chatMessageIsGlow
            layer.effect: Glow {
                samples: 30
                color: root.glowColor
                spread: 0.0
                transparentBorder: true
             }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onHoveredChanged:{
                    if(containsMouse){
                        messageIcon.open()
                        if(root.isLLM && !root.isFinished){
                            informationTokenId.open()
                        }
                    }else if(root.isLLM ){
                        informationTokenId.close()
                    }
                }
            }
        }

        Popup {
            id: messageIcon
            width: 90 + nubmerOfMessage.width
            height: 20
            x: messageTextRec.width - messageIcon.width + 10
            y: messageText.height + 20
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            background:Rectangle{
                color: "#00ffffff"
                radius: 4
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 3
                anchors.bottomMargin: 0
            }

            MyIcon {
                id: copyIconId
                width: 20
                height: 20
                anchors.right: parent.right
                anchors.rightMargin: 0
                heightSource:13
                widthSource:13
                normalColor:root.iconColor
                hoverColor:root.fillIconColor
                myIconId: "images/copyIcon.svg"
                myFillIconId: "images/fillCopyIcon.svg"
                myLable:"Copy"
                Connections {
                    target: copyIconId
                    function onClicked(){
                        // messageText.text.c
                    }
                }
            }
            MyIcon {
                id: regenerateOrEditIconId
                width: 20
                height: 20
                anchors.right: copyIconId.left
                anchors.rightMargin: 0
                heightSource:14
                widthSource:14
                normalColor:root.iconColor
                hoverColor:root.fillIconColor
                myIconId: root.isLLM?"images/regenerateIcon.svg":"images/editIcon.svg"
                myFillIconId: root.isLLM?"images/fillRegenerateIcon.svg":"images/fillEditIcon.svg"
                myLable:root.isLLM? "Regenerate": "Edit"
                Connections {
                    target: regenerateOrEditIconId
                    function onClicked(){
                        console.log("Hi message")
                        root.regenerateOrEdit()
                    }
                }
            }
            MyIcon {
                id: nextIcon
                width: 20
                height: 20
                visible: root.numberOfRegenerateOrEdit>1
                anchors.right: regenerateOrEditIconId.left
                anchors.rightMargin: 10
                heightSource:13
                widthSource:13
                normalColor:root.iconColor
                hoverColor:root.fillIconColor
                myIconId: "images/rightIcon.svg"
                myFillIconId: "images/rightIcon.svg"
                myLable:"next"
                Connections {
                    target: nextIcon
                    function onClicked(){
                        if(root.numberOfMessage !== root.numberOfRegenerateOrEdit)
                            root.nextMessage()
                    }
                }
            }
            Rectangle{
                id: nubmerOfMessageRec
                width: nubmerOfMessage.width
                height: 20
                color: "#00ffffff"
                visible: root.numberOfRegenerateOrEdit>1
                anchors.right: nextIcon.left
                anchors.rightMargin: 0
                Text {
                    id: nubmerOfMessage
                    text: root.numberOfMessage + "/" + root.numberOfRegenerateOrEdit
                    color: root.chatMessageTitleTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    font.family: root.fontFamily
                }
            }
            MyIcon {
                id: beforeIcon
                width: 20
                height: 20
                visible: root.numberOfRegenerateOrEdit>1
                anchors.right: nubmerOfMessageRec.left
                anchors.rightMargin: 0
                heightSource:13
                widthSource:13
                normalColor:root.iconColor
                hoverColor:root.fillIconColor
                myIconId: "images/leftIcon.svg"
                myFillIconId: "images/leftIcon.svg"
                myLable:"next"
                Connections {
                    target: beforeIcon
                    function onClicked(){
                        if(root.numberOfMessage !== 1)
                            root.beforMessage()
                    }
                }
            }
        }

        Popup {
            id: informationTokenId
            width: 280
            height: 20
            y: messageTextRec.height - 23

            background:Rectangle{
                color: "#00ffffff"
                radius: 4
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 3
                anchors.bottomMargin: 0
            }
            Rectangle {
                id: executionTimeId
                width: 140
                color: "#00ffffff"
                anchors.left: numberOfTokenId.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0

                Text {
                    id: executionTimeText
                    text: qsTr("Execution time: ")
                    color: root.chatMessageTitleTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    font.pointSize: 8
                }
                Text {
                    id: executionTimeValue
                    text: root.executionTime
                    color: root.chatMessageTitleTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: executionTimeText.right
                    anchors.leftMargin: 3
                    font.pointSize: 8
                }
            }

            Rectangle {
                id: numberOfTokenId
                width: 140
                color: "#00ffffff"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0

                Text {
                    id: numberOfTokenText
                    text: qsTr("Number of tokens: ")
                    color: root.chatMessageTitleTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    font.pointSize: 8
                }
                Text {
                    id: numberOfTokenValue
                    text: root.numberOfToken
                    color: root.chatMessageTitleTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: numberOfTokenText.right
                    anchors.leftMargin: 3
                    font.pointSize: 8
                }
            }
        }
    }
}
