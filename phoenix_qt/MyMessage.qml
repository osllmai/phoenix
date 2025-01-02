import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    id: root
    height: messageRec.height
    width: messageRec.width

    property int maxWidth: 300
    property bool isFinished: true
    property bool isLoadModel

    //signal and text about message
    property bool isLLM: true
    property string myText
    property int numberOfMessage
    property var curentResponse

    signal regenerateOrEdit(var text_edit)
    signal nextMessage()
    signal beforMessage()

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
        color: "#00ffffff"
        width:  messageTextRec.width
        height: messageTextRec.height /*+ messageIcon.height*/
        radius: 8


        Rectangle {
            id: messageTextRec
            color: root.chatMessageBackgroungColor
            width: messageTextRec.widthCalculation()
            height: messageTextRec.heightCalculation()
            function heightCalculation(){
                 if(root.isLLM == true){
                    if(root.isFinished)
                        return messageTextLLM.implicitHeight + 15;
                    else
                        return recListViewChat.height +15
                }else{
                    return messageTextUser.implicitHeight
                }
            }
            function widthCalculation(){
                 if(root.isLLM == true){
                    if(root.isFinished)
                        return Math.min(messageTextLLM.implicitWidth, root.maxWidth);
                    else
                        return recListViewChat.width +15
                }else{
                    return messageTextUser.implicitWidth
                }
            }

            radius: 8

            TextArea{
                id: messageTextUser
                visible: !root.isLLM
                width:  root.maxWidth
                text: root.myText
                color: root.chatMessageInformationTextColor

                padding: 10
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                font.pointSize: 10
                font.family: root.fontFamily
                focus: false
                readOnly: true
                wrapMode: Text.Wrap
                selectByMouse: false
                cursorVisible: !root.isFinished && root.isLLM
                cursorPosition: root.myText.length
                persistentSelection: true
                clip: false

                background: Rectangle {
                    color: "transparent"
                }

                onEditingFinished: {
                    if (messageTextUser.readOnly)
                        return;
                    messageTextUser.focus = false;
                    messageTextUser.readOnly = true;
                    messageTextUser.selectByMouse = false;
                }
                property bool isEnter: true
                hoverEnabled: true
                onHoveredChanged:{
                    if(isEnter ){
                        if(root.isLLM && !root.isFinished ){
                            // informationTokenId.visible = true
                        }
                        isEnter = false
                    }else if(root.isLLM ){
                        // informationTokenId.visible = false
                        isEnter = true
                    }
                }

                Accessible.role: Accessible.Button
                Accessible.name: text
                Accessible.description: qsTr("Select the current chat or edit the chat when in edit mode")
            }

            Text {
                id: messageTextLLM
                visible: root.isLLM && root.isFinished
                color: root.chatMessageInformationTextColor
                text: root.myText
                anchors.fill: parent
                padding: 10
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                textFormat: Text.MarkdownText
                wrapMode: Text.Wrap
                font.pointSize: 10
                font.family: root.fontFamily
            }


            //                 Text {
            //                     id: curentResponseTextLLM
            //                     color: root.chatMessageInformationTextColor
            //                     text: model.text
            //                     anchors.fill: parent
            //                     horizontalAlignment: Text.AlignLeft
            //                     verticalAlignment: Text.AlignTop
            //                     textFormat: Text.MarkdownText
            //                     wrapMode: Text.Wrap
            //                     font.pointSize: 10
            //                     font.family: root.fontFamily



            Rectangle {
                id: recListViewChat
                width: listViewChat.width + 20
                height: listViewChat.contentHeight + 20
                visible: root.isLLM && !root.isFinished
                color: "#00ffffff"

                ListView {
                    id: listViewChat
                    anchors.fill: parent
                    anchors.margins:10
                    model: root.curentResponse
                    delegate: Rectangle {
                        id: myPromptResponseBox
                        width: Math.min(curentResponseTextLLM.implicitWidth, root.maxWidth)
                        onWidthChanged:{
                           if(recListViewChat.width < myPromptResponseBox.width)
                               recListViewChat.width = myPromptResponseBox.width;
                        }

                        height: curentResponseTextLLM.implicitHeight
                        color: "#00ffffff"

                        Text {
                            id: curentResponseTextLLM
                            text: model.text
                            color: root.chatMessageInformationTextColor
                            anchors.fill: parent
                            textFormat: Text.MarkdownText
                            wrapMode: Text.Wrap
                            font.pointSize: 10
                            font.family: root.fontFamily
                            onTextChanged:{
                                console.log("--------------------------------- OK")
                            }
                        }
                    }

                    onContentHeightChanged: {
                        // recListViewChat.height = contentHeight
                        console.log("Content Height: ", contentHeight)
                    }
                    onContentWidthChanged:{
                        // recListViewChat.width = Math.min(contentWidth, root.maxWidth)
                        console.log("Content Width: ", contentWidth)
                    }
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

    //     Rectangle {
    //         id: messageIcon
    //         width: 90 + nubmerOfMessage.width
    //         height: 22
    //         anchors.right: parent.right
    //         anchors.top: messageTextRec.bottom
    //         anchors.rightMargin: 5
    //         anchors.topMargin: 2
    //         color: "#00ffffff"

    //         property bool checkCopy: false
    //         MyIcon {
    //             id: copyIconId
    //             width: 20
    //             height: 20
    //             visible: messageText.readOnly
    //             anchors.right: parent.right
    //             anchors.rightMargin: 0
    //             heightSource:13
    //             widthSource:13
    //             normalColor:root.iconColor
    //             hoverColor:root.fillIconColor
    //             myIconId: messageIcon.checkCopy?"images/copySuccessIcon.svg": "images/copyIcon.svg"
    //             myFillIconId: messageIcon.checkCopy?"images/copySuccessIcon.svg": "images/fillCopyIcon.svg"
    //             myLable:"Copy"
    //             Connections {
    //                 target: copyIconId
    //                 function onActionClicked(){
    //                     messageText.selectAll()
    //                     messageText.copy()
    //                     messageText.deselect()
    //                     messageIcon.checkCopy= true
    //                     successTimer.start();
    //                 }
    //             }
    //         }
    //         Timer {
    //             id: successTimer
    //             interval: 2000
    //             repeat: false

    //             onTriggered: messageIcon.checkCopy= false
    //         }
    //         MyIcon {
    //             id: regenerateOrEditIconId
    //             width: 20
    //             height: 20
    //             visible: messageText.readOnly
    //             enabled: root.isLoadModel
    //             anchors.right: copyIconId.left
    //             anchors.rightMargin: 0
    //             heightSource:14
    //             widthSource:14
    //             normalColor:root.iconColor
    //             hoverColor:root.fillIconColor
    //             myIconId: root.isLLM?"images/regenerateIcon.svg":"images/editIcon.svg"
    //             myFillIconId: root.isLLM?"images/fillRegenerateIcon.svg":"images/fillEditIcon.svg"
    //             myLable:root.isLLM? "Regenerate": "Edit"
    //             Connections {
    //                 target: regenerateOrEditIconId
    //                 function onActionClicked(){
    //                     if(root.isLLM){
    //                         root.regenerateOrEdit("");
    //                     }else{
    //                         messageText.focus = true;
    //                         messageText.readOnly = false;
    //                         messageText.selectByMouse = true;
    //                     }
    //                 }
    //             }
    //         }
    //         MyIcon {
    //             id: cancelIconId
    //             visible: !messageText.readOnly
    //             width: 20
    //             height: 20
    //             anchors.right: parent.right
    //             anchors.rightMargin: 0
    //             heightSource:15
    //             widthSource:15
    //             normalColor:root.iconColor
    //             hoverColor:root.fillIconColor
    //             myIconId: "images/cancelCircle.svg"
    //             myFillIconId: "images/fillCancelCircle.svg"
    //             myLable: "Cancel"
    //             Connections {
    //                 target: cancelIconId
    //                 function onActionClicked(){
    //                     root.regenerateOrEdit("");
    //                     messageText.editingFinished()
    //                 }
    //             }
    //         }
    //         MyIcon {
    //             id: okIconId
    //             visible: !messageText.readOnly
    //             width: 20
    //             height: 20
    //             enabled: root.isLoadModel
    //             anchors.right: cancelIconId.left
    //             anchors.rightMargin: 0
    //             heightSource:15
    //             widthSource:15
    //             normalColor:root.iconColor
    //             hoverColor:root.fillIconColor
    //             myIconId: "images/okCircle.svg"
    //             myFillIconId: "images/fillOkCircle.svg"
    //             myLable:"Save edit"
    //             Connections {
    //                 target: okIconId
    //                 function onActionClicked(){
    //                     root.regenerateOrEdit(messageText.text);
    //                     messageText.editingFinished()
    //                 }
    //             }
    //         }
    //         MyIcon {
    //             id: nextIcon
    //             width: 20
    //             height: 20
    //             visible: messageText.readOnly && root.numberOfRegenerateOrEdit>1
    //             anchors.right: regenerateOrEditIconId.left
    //             anchors.rightMargin: 10
    //             heightSource:13
    //             widthSource:13
    //             normalColor:root.iconColor
    //             hoverColor:root.fillIconColor
    //             myIconId: "images/rightIcon.svg"
    //             myFillIconId: "images/rightIcon.svg"
    //             myLable:"next"
    //             Connections {
    //                 target: nextIcon
    //                 function onActionClicked(){
    //                     if(root.numberOfMessage !== root.numberOfRegenerateOrEdit)
    //                         root.nextMessage()
    //                 }
    //             }
    //         }

    //         Rectangle{
    //             id: nubmerOfMessageRec
    //             width: nubmerOfMessage.width
    //             height: 20
    //             color: "#00ffffff"
    //             visible: messageText.readOnly && root.numberOfRegenerateOrEdit>1
    //             anchors.right: nextIcon.left
    //             anchors.rightMargin: 0
    //             Text {
    //                 id: nubmerOfMessage
    //                 text: root.numberOfMessage + "/" + root.numberOfRegenerateOrEdit
    //                 color: root.chatMessageTitleTextColor
    //                 anchors.verticalCenter: parent.verticalCenter
    //                 anchors.left: parent.left
    //                 anchors.leftMargin: 0
    //                 font.family: root.fontFamily
    //             }
    //         }
    //         MyIcon {
    //             id: beforeIcon
    //             width: 20
    //             height: 20
    //             visible: messageText.readOnly && root.numberOfRegenerateOrEdit>1
    //             anchors.right: nubmerOfMessageRec.left
    //             anchors.rightMargin: 0
    //             heightSource:13
    //             widthSource:13
    //             normalColor:root.iconColor
    //             hoverColor:root.fillIconColor
    //             myIconId: "images/leftIcon.svg"
    //             myFillIconId: "images/leftIcon.svg"
    //             myLable:"next"
    //             Connections {
    //                 target: beforeIcon
    //                 function onActionClicked(){
    //                     if(root.numberOfMessage !== 1)
    //                         root.beforMessage()
    //                 }
    //             }
    //         }
    //     }

    //     Rectangle {
    //         id: informationTokenId
    //         width: 280
    //         height: 20
    //         color: "#00ffffff"
    //         anchors.left: messageTextRec.left
    //         anchors.bottom: messageTextRec.bottom
    //         anchors.leftMargin: 10
    //         anchors.bottomMargin: 0
    //         visible: false

    //         Rectangle {
    //             id: executionTimeId
    //             width: 140
    //             color: "#00ffffff"
    //             anchors.left: numberOfTokenId.right
    //             anchors.top: parent.top
    //             anchors.bottom: parent.bottom
    //             anchors.leftMargin: 0
    //             anchors.topMargin: 0
    //             anchors.bottomMargin: 0

    //             Text {
    //                 id: executionTimeText
    //                 text: qsTr("Execution time: ")
    //                 color: root.chatMessageTitleTextColor
    //                 anchors.verticalCenter: parent.verticalCenter
    //                 anchors.left: parent.left
    //                 anchors.leftMargin: 0
    //                 font.pointSize: 8
    //             }
    //             Text {
    //                 id: executionTimeValue
    //                 text: root.executionTime
    //                 color: root.chatMessageTitleTextColor
    //                 anchors.verticalCenter: parent.verticalCenter
    //                 anchors.left: executionTimeText.right
    //                 anchors.leftMargin: 3
    //                 font.pointSize: 8
    //             }
    //         }

    //         Rectangle {
    //             id: numberOfTokenId
    //             width: 70
    //             color: "#00ffffff"
    //             anchors.left: parent.left
    //             anchors.top: parent.top
    //             anchors.bottom: parent.bottom
    //             anchors.leftMargin: 0
    //             anchors.topMargin: 0
    //             anchors.bottomMargin: 0

    //             Text {
    //                 id: numberOfTokenText
    //                 text: qsTr("Tokens: ")
    //                 color: root.chatMessageTitleTextColor
    //                 anchors.verticalCenter: parent.verticalCenter
    //                 anchors.left: parent.left
    //                 anchors.leftMargin: 0
    //                 font.pointSize: 8
    //             }
    //             Text {
    //                 id: numberOfTokenValue
    //                 text: root.numberOfToken
    //                 color: root.chatMessageTitleTextColor
    //                 anchors.verticalCenter: parent.verticalCenter
    //                 anchors.left: numberOfTokenText.right
    //                 anchors.leftMargin: 3
    //                 font.pointSize: 8
    //             }
    //         }
    //     }


    }
}
