import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

import Phoenix
import Qt5Compat.GraphicalEffects

Item {
    id: root
    width: 1229 - 24 - 70
    height: 685 - 48

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

    property var chatListModel
    property var currentChat
    property var chatModel
    property var modelListModel

    property bool emptyConversation: root.chatModel.size == 0? true: false
    // function onEmptyConversationChanged(){
    //     if(emptyConversation){
    //         console.log("***********************onEmptyConversationChanged Hi")
    //         inputBoxRec.y = emptyMessageText.y +100
    //     }else{
    //         console.log("---------------------------------onEmptyConversationChanged Hi")
    //         inputBoxRec.y = textChat.y + textChat.height
    //     }
    // }

    signal goToModelPage()

    Rectangle{
        id: chatPage
        color: root.chatBackgroungConverstationColor
        radius: 4
        anchors.fill: parent

        // focus: true
        // Keys.onPressed: function(event){
        //     if(event.key & Qt.Key_5 /*&& event.key === Qt.Key_N*/){
        //         console.log("Hi hi hi ------------------------------------------ hi hi hi")
        //     }
        // }

        Row{
            id: mainStructure
            anchors.fill: parent

            Rectangle{
                id: leftSidePage
                width: Math.min(mainStructure.width / 4, 350)
                height: mainStructure.height
                color: root.chatBackgroungColor

                Row{
                    id: searchAndNewChatBox
                    height: 60
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.topMargin: 0

                    Rectangle {
                        id: searchBox
                        height: 40
                        color:root.chatBackgroungConverstationColor
                        width: 300
                        radius: 5
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: newChatBox.left
                        anchors.leftMargin: 0
                        anchors.rightMargin: 10
                        // border.color: root.glowColor

                        Image {
                            id: searchIcon
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            source: "images/searchIcon.svg"
                            sourceSize.height: 20
                            sourceSize.width: 20
                            fillMode: Image.PreserveAspectFit
                        }
                        ColorOverlay {
                            id: colorOverlaySearchIconId
                            anchors.fill: searchIcon
                            source: searchIcon
                            color: root.informationTextColor
                        }

                        TextArea {
                            id: textArea
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: searchIcon.right
                            anchors.right: parent.right
                            anchors.leftMargin: 0
                            anchors.rightMargin: 0
                            font.pointSize: 10
                            placeholderTextColor: root.informationTextColor
                            font.family: root.fontFamily
                            hoverEnabled: true
                            placeholderText: qsTr("Search History")
                            color: root.informationTextColor
                            background: Rectangle{
                                color: "#00ffffff"
                            }
                        }
                        layer.enabled: true
                        layer.effect: Glow {
                             samples: 15
                             color: root.glowColor
                             spread: 0.0
                             transparentBorder: true
                         }
                    }

                    Rectangle {
                        id: newChatBox
                        width: 40
                        height: 40
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        color: "#00ffffff"

                        MyIcon {
                            id: newChatIcon
                            height: 40
                            width: 40
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            myLable: "New chat"
                            myIconId: "images/chatAddIcon.svg"
                            myFillIconId:  "images/chatAddIcon.svg"
                            heightSource: 19
                            widthSource: 19
                            normalColor: root.iconColor
                            hoverColor: root.fillIconColor
                            Connections {
                                target: newChatIcon
                                function onClicked() {
                                    root.chatListModel.addChat();
                                    // historylist.contentY = historylist.contentHeight;
                                }
                            }
                        }

                    }

                }

                Rectangle {
                    id: historyRec
                    color: "#00ffffff"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: searchAndNewChatBox.bottom
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.topMargin: 0
                    anchors.bottomMargin: 10

                    Rectangle{
                        id: emptyChatListId
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: recHistoryText.bottom
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 0
                        anchors.rightMargin: 0
                        anchors.topMargin: 0
                        anchors.bottomMargin: 0
                        color: "#00ffffff"
                        visible: root.chatListModel.size == 0
                        Text {
                            id: emptyChatText
                            color: "#919191"
                            text: qsTr("There is no chat.")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pointSize: 10
                            font.family: "Times New Roman"
                        }
                    }

                    Rectangle{
                        id: rectangleListChat
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: recHistoryText.bottom
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 0
                        anchors.rightMargin: 0
                        anchors.topMargin: 16
                        anchors.bottomMargin: 0
                        color: "#00000000"
                        visible: root.chatListModel.size > 0

                        ListView {
                            id: historylist
                            anchors.fill: parent

                            model: root.chatListModel
                            // Component.onCompleted: chatListModel.loadChats()

                            delegate: Rectangle{
                                id: delegateChat
                                width: historylist.width
                                height: 42
                                color: "#00000000"

                                MyChatItem {
                                      id: applicationButton
                                      height: 35
                                      anchors.left: parent.left
                                      anchors.right: parent.right
                                      anchors.leftMargin: 0
                                      anchors.rightMargin: 0
                                      fontFamily: root.fontFamily
                                      myTextId: model.title
                                      myChatListModel: chatListModel
                                      myIndex:index
                                      fillIconColor: root.fillIconColor
                                      iconColor: root.iconColor
                                      normalButtonColor: root.normalButtonColor
                                      selectButtonColor: root.selectButtonColor
                                      hoverButtonColor: root.hoverButtonColor
                                      chatMessageInformationTextColor: root.chatMessageInformationTextColor
                                      glowColor: root.glowColor

                                }
                            }
                        }
                    }
                    Rectangle{
                        id: recHistoryText
                        width: parent.width
                        height: 40
                        color: "#00ffffff"
                        Text {
                            id: historyText
                            text: qsTr("Histoty")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.topMargin: 20
                            anchors.leftMargin: 16
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignTop
                            font.family: root.fontFamily
                            color: root.titleTextColor
                        }
                    }
                }

            }

            Rectangle{
                id: rightSidePage
                height: mainStructure.height
                color: root.chatBackgroungConverstationColor
                anchors.left: leftSidePage.visible=== true?leftSidePage.right: parent.left
                anchors.right: parent.right
                anchors.top: header.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 0
                radius: 10

                Rectangle {
                    id: chatStack
                    // width: Math.min(700,parent.width)
                    anchors.left: parent.left
                    anchors.right: modelSettings.visible=== true? modelSettings.left: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 0
                    color: "#00ffffff"
                    // anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        id: chatRec
                        width: Math.min(700,parent.width)
                        height: parent.height
                        color: "#00ffffff"
                        anchors.horizontalCenter: parent.horizontalCenter

                        Rectangle{
                            id: emptyMessageListId
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.leftMargin: 50
                            anchors.rightMargin: 50
                            anchors.topMargin: 24
                            anchors.bottomMargin: 24
                            color: "#00ffffff"
                            visible: root.emptyConversation
                            Text {
                                id: emptyMessageText
                                color: root.informationTextColor
                                text: qsTr("What can I help with?")
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.pointSize: 14
                                font.family: "Times New Roman"
                            }
                        }

                        Rectangle {
                            id: textChat
                            color: "#00ffffff"
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: inputBoxRec.top
                            anchors.leftMargin: 50
                            anchors.rightMargin: 50
                            anchors.topMargin: 24
                            anchors.bottomMargin: 12
                            visible: !root.emptyConversation
                            function onVisible(){
                                inputBoxRec.y = inputBoxRec.y + 200
                            }

                            ColumnLayout{
                                anchors.fill: parent
                                ListView {
                                    id: listViewChat
                                    Layout.maximumWidth: 1280
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Layout.margins: 20
                                    Layout.leftMargin: 0
                                    Layout.rightMargin: 0
                                    Layout.alignment: Qt.AlignHCenter

                                    model: root.chatModel
                                    cacheBuffer: Math.max(0, listViewChat.contentHeight)

                                    delegate: Rectangle{
                                        id: myPromptResponseBox
                                        width: listViewChat.width
                                        height: myPromptResponseId.height
                                        color: root.chatBackgroungConverstationColor
                                        MyPromptResponse{
                                            id: myPromptResponseId
                                            width: parent.width

                                            prompt: model.prompt
                                            response: model.response
                                            isFinished: !root.currentChat.responseInProgress
                                            Connections {
                                                target: myPromptResponseId
                                                function onRegenerateResponse(){
                                                    root.chatModel.regenerateResponse(index)
                                                }
                                                function onEditPrompt(){
                                                    console.log("onEditPrompt")
                                                    root.chatModel.editPrompt(index, "Tell me about iran")
                                                }
                                                function onNextPrompt(){
                                                    console.log("onNextPrompt")
                                                    root.chatModel.nextPrompt(index, model.numberPrompt)
                                                }
                                                function onBeforPrompt(){
                                                    console.log("onBeforPrompt")
                                                    root.chatModel.nextPrompt(index, model.numberPrompt-2)
                                                }
                                                function onNextResponse(){
                                                    console.log("onNextResponse")
                                                    root.chatModel.nextResponse(index, model.numberResponse)
                                                }
                                                function onBeforResponse(){
                                                    console.log("onBeforResponse")
                                                    root.chatModel.nextResponse(index, model.numberResponse-2)
                                                }
                                            }
                                            numberOfPrompt: model.numberPrompt
                                            numberOfRegenerate: model.numberOfRegenerate
                                            numberOfResponse: model.numberResponse
                                            numberOfEdit: model.numberOfEditPrompt


                                            backgroungColor: root.backgroungColor
                                            glowColor: root.glowColor
                                            boxColor: root.boxColor
                                            normalButtonColor: root.normalButtonColor
                                            selectButtonColor: root.selectButtonColor
                                            hoverButtonColor: root.hoverButtonColor
                                            fillIconColor: root.fillIconColor
                                            iconColor: root.iconColor

                                            chatBackgroungColor: root.chatBackgroungColor
                                            chatBackgroungConverstationColor: root.chatBackgroungConverstationColor
                                            chatMessageBackgroungColor: root.chatMessageBackgroungColor
                                            chatMessageTitleTextColor: root.chatMessageTitleTextColor
                                            chatMessageInformationTextColor: root.chatMessageInformationTextColor
                                            chatMessageIsGlow: root.chatMessageIsGlow

                                            titleTextColor: root.titleTextColor
                                            informationTextColor: root.informationTextColor
                                            selectTextColor: root.selectTextColor

                                            fontFamily: root.fontFamily
                                        }
                                    }

                                    // function scrollToEnd() {
                                    //     listViewChat.positionViewAtEnd()
                                    // }

                                    onContentHeightChanged: {
                                        // if (atYEnd)
                                            listViewChat.positionViewAtEnd()
                                    }
                                    // onHeightChanged:{
                                    //     if (atYEnd)
                                    //         scrollToEnd()
                                    // }
                                }
                            }
                        }

                        Rectangle{
                            id: inputBoxRec
                            width: parent.width
                            height: inputBox.height+30
                            anchors.left: parent.left
                            anchors.right: parent.right
                            // anchors.bottom: parent.bottom
                            color: rightSidePage.color

                            y: emptyMessageText.y + 50

                            Behavior on y{
                                NumberAnimation{
                                    duration: 200
                                }
                            }

                            InputPromptBox{
                                id: inputBox
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.leftMargin: 80
                                anchors.rightMargin: 80
                                anchors.bottomMargin: 20

                                backgroungColor: root.backgroungColor
                                glowColor: root.glowColor
                                boxColor: root.boxColor
                                normalButtonColor: root.normalButtonColor
                                selectButtonColor: root.selectButtonColor
                                hoverButtonColor: root.hoverButtonColor
                                fillIconColor: root.fillIconColor
                                iconColor: root.iconColor

                                chatBackgroungColor: root.chatBackgroungColor
                                chatBackgroungConverstationColor: root.chatBackgroungConverstationColor
                                chatMessageBackgroungColor: root.chatMessageBackgroungColor
                                chatMessageTitleTextColor: root.chatMessageTitleTextColor
                                chatMessageInformationTextColor: root.chatMessageInformationTextColor
                                chatMessageIsGlow: root.chatMessageIsGlow

                                titleTextColor: root.titleTextColor
                                informationTextColor: root.informationTextColor
                                selectTextColor: root.selectTextColor

                                fontFamily: root.fontFamily

                                currentChat: root.currentChat
                                modelListModel: root.modelListModel

                                Connections{
                                    target: inputBox
                                    function onSendPrompt(prompt){
                                        if(root.currentChat.responseInProgress){
                                            root.currentChat.responseInProgress = false;
                                        }else if (prompt !== "") {
                                            chatModel.prompt(prompt);
                                            prompt = ""; // Clear the input
                                            listViewChat.contentY = listViewChat.contentHeight; // Scroll to bottom
                                        }
                                    }
                                    function onGoToModelPage(){
                                        root.goToModelPage()
                                    }
                                    function onLoadModelDialog(modelPath , name){
                                    }
                                }
                            }

                            // Rectangle {
                            //     id: inputBox
                            //     height: 40 + selectModelId.height
                            //     color: parent.color
                            //     radius: 12
                            //     anchors.left: parent.left
                            //     anchors.right: parent.right
                            //     anchors.bottom: parent.bottom
                            //     anchors.leftMargin: 80
                            //     anchors.rightMargin: 80
                            //     anchors.bottomMargin: 20
                            //     visible: parent.visible

                            //     // Rectangle{
                            //     //     id:lineInputBox
                            //     //     width: parent.width - 16
                            //     //     height: 3
                            //     //     anchors.bottom: parent.bottom
                            //     //     anchors.bottomMargin: 0
                            //     //     anchors.horizontalCenter: parent.horizontalCenter
                            //     //     color: /*root.iconColor*/root.glowColor
                            //     //     visible: false
                            //     // }

                            //     ScrollView {
                            //         id: scrollInput
                            //         anchors.left: parent.left
                            //         anchors.right: sendIcon.left
                            //         anchors.top: parent.top
                            //         anchors.bottom: selectModelId.top
                            //         anchors.leftMargin: 10
                            //         anchors.rightMargin: 10
                            //         anchors.topMargin: 5
                            //         anchors.bottomMargin: 5

                            //         TextArea {
                            //             id: inputTextBox
                            //             height: text.height
                            //             visible: true
                            //             color: root.informationTextColor
                            //             wrapMode: Text.Wrap
                            //             placeholderText: root.currentChat.isLoadModel? qsTr("What is in your mind ?"): qsTr("Load a model to continue ...")
                            //             clip: false
                            //             font.pointSize: 12
                            //             hoverEnabled: true
                            //             tabStopDistance: 80
                            //             selectionColor: "#fff5fe"
                            //             cursorVisible: false
                            //             persistentSelection: true
                            //             placeholderTextColor: root.informationTextColor
                            //             font.family: root.fontFamily
                            //             onHeightChanged: {
                            //                 if(inputTextBox.height >30 && inputTextBox.text !== ""){
                            //                     inputBox.height  = Math.min(inputTextBox.height + 10 + selectModelId.height, 180+selectModelId.height) ;
                            //                 }if(inputTextBox.text === ""){
                            //                     inputBox.height = 40 + selectModelId.height
                            //                 }
                            //             }

                            //             // onHeightChanged: {
                            //             //     if(inputBox.height < 150 && inputTextBox.text !== ""){
                            //             //         inputBox.height += 6;
                            //             //     }
                            //             // }
                            //             onEditingFinished: {
                            //                 // inputBoxRec.layer.enabled= false
                            //             }
                            //             onPressed: {
                            //                 // inputBoxRec.layer.enabled= true
                            //             }

                            //             Keys.onReturnPressed: (event)=> {
                            //               if (event.modifiers & Qt.ControlModifier || event.modifiers & Qt.ShiftModifier)
                            //                 event.accepted = false;
                            //               else {
                            //                     sendIcon.clicked()
                            //                   // if(root.currentChat.responseInProgress){
                            //                   //     root.currentChat.responseInProgress = false;
                            //                   // }else if (inputTextBox.text !== "") {
                            //                   //     chatModel.prompt(inputTextBox.text);
                            //                   //     inputTextBox.text = ""; // Clear the input
                            //                   //     listViewChat.contentY = listViewChat.contentHeight; // Scroll to bottom
                            //                   //     inputBox.height = 40 + selectModelId.height;
                            //                   // }
                            //               }
                            //             }

                            //             background: Rectangle{
                            //                 color: "#00ffffff"
                            //             }
                            //         }
                            //     }

                            //     MyIcon {
                            //         id: sendIcon
                            //         width: 40
                            //         height: 40
                            //         anchors.right: parent.right
                            //         anchors.bottom: parent.bottom
                            //         anchors.bottomMargin: 35
                            //         myLable: root.currentChat.responseInProgress? "Stop":"Send"
                            //         myIconId: root.currentChat.responseInProgress? "images/stopIcon.svg" : "images/sendIcon.svg"
                            //         myFillIconId:  root.currentChat.responseInProgress? "images/fillStopIcon.svg" : "images/fillSendIcon.svg"
                            //         heightSource: 16
                            //         widthSource: 16
                            //         normalColor: root.iconColor
                            //         hoverColor: root.fillIconColor
                            //         Connections {
                            //             target: sendIcon
                            //             function onClicked() {
                            //                 if(root.currentChat.responseInProgress){
                            //                     root.currentChat.responseInProgress = false;
                            //                 }else if (inputTextBox.text !== "") {
                            //                     chatModel.prompt(inputTextBox.text);
                            //                     inputTextBox.text = ""; // Clear the input
                            //                     listViewChat.contentY = listViewChat.contentHeight; // Scroll to bottom
                            //                     inputBox.height = 40 + selectModelId.height;
                            //                 }
                            //             }
                            //         }
                            //     }

                            //     Rectangle{
                            //         id: selectModelId
                            //         height: 35
                            //         color: "#00ffffff"
                            //         anchors.left: parent.left
                            //         anchors.right: parent.right
                            //         anchors.bottom: parent.bottom
                            //         anchors.leftMargin: 0
                            //         anchors.rightMargin: 0
                            //         anchors.bottomMargin: 0
                            //         MyButton{
                            //             id:loadModelIcon
                            //             width: 200
                            //             anchors.left: parent.left
                            //             anchors.top: parent.top
                            //             anchors.bottom: parent.bottom
                            //             anchors.leftMargin: 15
                            //             anchors.topMargin: 5
                            //             anchors.bottomMargin: 5
                            //             myTextId: "load Model"
                            //             Connections{
                            //                 target:loadModelIcon
                            //                 function onClicked(){
                            //                     loadModelPopup.open()
                            //                 }
                            //             }
                            //         }
                            //     }

                            //     Popup {
                            //         id: loadModelPopup
                            //         width: 200
                            //         height: 250
                            //         x: 0
                            //         y: -180
                            //         closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

                            //         background:Rectangle{
                            //             color: "#00ffffff" // Background color of tooltip
                            //             radius: 4
                            //             anchors.fill: parent
                            //         }
                            //         ModelDialog{
                            //             id: modelListDialog
                            //             // anchors.fill: parent

                            //             backgroungColor: root.backgroungColor
                            //             glowColor: root.glowColor
                            //             boxColor: root.boxColor
                            //             normalButtonColor: root.normalButtonColor
                            //             selectButtonColor: root.selectButtonColor
                            //             hoverButtonColor: root.hoverButtonColor
                            //             fillIconColor: root.fillIconColor
                            //             iconColor: root.iconColor

                            //             chatBackgroungColor: root.chatBackgroungColor
                            //             chatBackgroungConverstationColor: root.chatBackgroungConverstationColor
                            //             chatMessageBackgroungColor: root.chatMessageBackgroungColor
                            //             chatMessageTitleTextColor: root.chatMessageTitleTextColor
                            //             chatMessageInformationTextColor: root.chatMessageInformationTextColor
                            //             chatMessageIsGlow: root.chatMessageIsGlow

                            //             titleTextColor: root.titleTextColor
                            //             informationTextColor: root.informationTextColor
                            //             selectTextColor: root.selectTextColor

                            //             fontFamily: root.fontFamily

                            //             modelListModel: root.modelListModel
                            //             Connections{
                            //                 target: modelListDialog
                            //                 function onGoToModelPage(){
                            //                     loadModelPopup.close()
                            //                     root.goToModelPage()
                            //                 }
                            //                 function onLoadModelDialog(modelPath , name){
                            //                     loadModelIcon.myTextId = name
                            //                     loadModelPopup.close()
                            //                 }
                            //             }
                            //         }
                            //     }



                            //     layer.enabled: true
                            //     layer.effect: Glow {
                            //         samples: 15
                            //         color: root.glowColor
                            //         spread: 0.0
                            //         transparentBorder: true
                            //      }
                            // }


                        }

                        Rectangle {
                            id: header
                            height: 20
                            color: rightSidePage.color
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 0
                            anchors.rightMargin: 0
                        }
                    }
                }

                Rectangle{
                    id:modelSettings
                    width: Math.min(mainStructure.width / 4, 350)
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    color: root.chatBackgroungColor
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    radius:5
                    visible: true

                    Rectangle {
                        id: menuSettingsId
                        width: parent.width
                        height: 60
                        color: "#00ffffff"

                        Row{
                            id: rowSettingsId
                            anchors.fill: parent

                            MyMenuSettings {
                                id: assistantMenue
                                width: (parent.width-10)/2
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom
                                anchors.leftMargin: 10
                                anchors.topMargin: 10
                                anchors.bottomMargin:  10
                                myTextId: "Assistant"
                                checked: true
                                autoExclusive: true
                                backgroungColor: "#00ffffff"
                                borderColor:"#00ffffff"
                                textColor: root.informationTextColor
                                glowColor: root.glowColor
                                fontFamily: root.fontFamily
                                selectTextColor:root.fillIconColor
                                Connections {
                                    target: assistantMenue
                                    function onClicked(){
                                        settingsSpace.currentIndex = 0
                                        showSelectMenuId.x = menuSettingsId.x +10
                                    }
                                }
                            }
                            MyMenuSettings {
                                id: modelMenue
                                width: (parent.width-10)/2
                                anchors.left: assistantMenue.right
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.leftMargin: 0
                                anchors.rightMargin: 10
                                anchors.topMargin: 10
                                anchors.bottomMargin:  10
                                myTextId: "Model"
                                checked: false
                                autoExclusive: true
                                backgroungColor: "#00ffffff"
                                borderColor:"#00ffffff"
                                textColor: root.informationTextColor
                                glowColor: root.glowColor
                                fontFamily: root.fontFamily
                                selectTextColor:root.fillIconColor
                                Connections {
                                    target: modelMenue
                                    function onClicked(){
                                        settingsSpace.currentIndex = 1
                                        showSelectMenuId.x = menuSettingsId.x + 10 + (menuSettingsId.width-10)/2
                                    }
                                }
                            }
                        }
                        Rectangle{
                            id: showSelectMenuId
                            color: root.fillIconColor
                            height: 2
                            width: (parent.width-30)/2
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                            x: menuSettingsId.x +10

                            Behavior on x{
                                NumberAnimation{
                                    duration: 300
                                }
                            }
                        }
                    }
                    StackLayout {
                        id: settingsSpace
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: menuSettingsId.bottom
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 0
                        anchors.rightMargin: 0
                        anchors.topMargin: 0
                        anchors.bottomMargin: 0
                        currentIndex: 0


                        Rectangle {
                            id: assistantSpace
                            radius: 4
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "#00ffffff"
                            Rectangle {
                                id: instructionsBox
                                height: 80
                                color: root.chatBackgroungConverstationColor
                                radius: 12
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                anchors.topMargin: 0


                                ScrollView {
                                    id: scrollInstruction
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    anchors.topMargin: 5
                                    anchors.bottomMargin: 5

                                    TextArea {
                                        id: instructionTextBox
                                        height: text.height
                                        visible: true
                                        color: root.informationTextColor
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.leftMargin: 0
                                        anchors.rightMargin: 0
                                        wrapMode: Text.WordWrap
                                        placeholderText: qsTr("Eg. You are a helpful assistant")
                                        clip: false
                                        font.pointSize: 10
                                        hoverEnabled: true
                                        tabStopDistance: 80
                                        selectionColor: root.informationTextColor
                                        cursorVisible: false
                                        persistentSelection: true
                                        placeholderTextColor: root.informationTextColor
                                        font.family: root.fontFamily

                                        onHeightChanged: {
                                            if(instructionTextBox.height + 10>80 && instructionTextBox.text !== ""){
                                                instructionsBox.height  = Math.min(instructionTextBox.height + 10,settingsSpace.height - 10) ;
                                            }
                                        }

                                        background: Rectangle{
                                            color: "#00ffffff"
                                        }
                                    }
                                }
                                layer.enabled: true
                                layer.effect: Glow {
                                     samples: 15
                                     color: root.glowColor
                                     spread: 0.0
                                     transparentBorder: true
                                 }
                            }
                        }


                        Rectangle {
                            id: modelSpace
                            radius: 4
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "#00ffffff"
                            ScrollView{
                                id: scrollViewSettingsId
                                width: parent.width
                                height: parent.height
                                // height: inferenceSettingsId.height+modelSettingsId.height+engineSettingsId.height +30
                                Rectangle{
                                    id: inferenceSettingsId
                                    height: inferenceSettingsButtonId.height /*+ inferenceSettingsInformationId.height*/
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    anchors.topMargin: 0
                                    color: "#00ffffff"

                                    Rectangle{
                                        id: inferenceSettingsButtonId
                                        height: 40
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.leftMargin: 5
                                        anchors.rightMargin: 5
                                        anchors.topMargin: 0
                                        color: "#00ffffff"
                                        Text {
                                            id: inferenceSettingsTextId
                                            text: qsTr("Inference Settings")
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.left: parent.left
                                            anchors.leftMargin: 5
                                            font.pointSize: 10
                                            color: root.titleTextColor
                                            font.family: root.fontFamily
                                        }
                                        MyIcon {
                                            id: inferenceSettingsIconId
                                            visible: true
                                            anchors.left: modelList.right
                                            anchors.right: parent.right
                                            width: 40
                                            anchors.top: parent.top
                                            anchors.bottom: parent.bottom
                                            anchors.leftMargin: 0
                                            anchors.rightMargin: 0
                                            anchors.topMargin: 0
                                            myLable: inferenceSettingsInformationId.visible=== true? "close": "open"
                                            myIconId:  inferenceSettingsInformationId.visible=== true?"images/upIcon.svg":"images/downIcon.svg"
                                            myFillIconId: inferenceSettingsInformationId.visible=== true?"images/fillUpIcon.svg":"images/fillDownIcon.svg"
                                            normalColor: root.iconColor
                                            hoverColor: root.fillIconColor
                                            Connections {
                                                target: inferenceSettingsIconId
                                                function onClicked () {
                                                    if(inferenceSettingsInformationId.visible=== true){
                                                        inferenceSettingsInformationId.visible = false
                                                        inferenceSettingsId.height = inferenceSettingsButtonId.height
                                                    }else{
                                                        inferenceSettingsInformationId.visible = true
                                                        inferenceSettingsId.height = inferenceSettingsButtonId.height + inferenceSettingsInformationId.height
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    Rectangle{
                                        id: inferenceSettingsInformationId
                                        height: streamId.height+temperatureId.height+topPId.height+maxTokensId.height+frequencyPenaltyId.height+presencePenaltyId.height
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: inferenceSettingsButtonId.bottom
                                        anchors.leftMargin: 0
                                        anchors.rightMargin: 0
                                        anchors.topMargin: 0
                                        visible: false
                                        color: "#00ffffff"

                                        SettingsSwitchItem{
                                            id:streamId
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: parent.top
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            anchors.topMargin: 0
                                            myTextName: "Stream"
                                            fontFamily:root.fontFamily
                                            textColor: root.informationTextColor
                                        }
                                        SettingsSliderItem{
                                            id:temperatureId
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: streamId.bottom
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            anchors.topMargin: 0
                                            myTextName: "Temperature"
                                            sliderValue: 0.4
                                            sliderFrom: 0
                                            sliderTo:2
                                            sliderStepSize:0.1
                                            fontFamily:root.fontFamily
                                            textColor: root.informationTextColor
                                            boxColor: root.chatBackgroungConverstationColor
                                            glowColor: root.glowColor
                                        }
                                        SettingsSliderItem{
                                            id:topPId
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: temperatureId.bottom
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            anchors.topMargin: 0
                                            myTextName: "Top P"
                                            sliderValue: 0.9
                                            sliderFrom: 0
                                            sliderTo:1
                                            sliderStepSize:0.1
                                            fontFamily:root.fontFamily
                                            textColor: root.informationTextColor
                                            boxColor: root.chatBackgroungConverstationColor
                                            glowColor: root.glowColor
                                        }
                                        SettingsSliderItem{
                                            id:maxTokensId
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: topPId.bottom
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            anchors.topMargin: 0
                                            myTextName: "Max Tokens"
                                            sliderValue: 4096
                                            sliderFrom: 100
                                            sliderTo: 4096
                                            sliderStepSize:1
                                            fontFamily:root.fontFamily
                                            textColor: root.informationTextColor
                                            boxColor: root.chatBackgroungConverstationColor
                                            glowColor: root.glowColor
                                        }
                                        SettingsSliderItem{
                                            id:frequencyPenaltyId
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: maxTokensId.bottom
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            anchors.topMargin: 0
                                            myTextName: "Frequency Penalty"
                                            sliderValue: 0
                                            sliderFrom: 0
                                            sliderTo: 1
                                            sliderStepSize:0.1
                                            fontFamily:root.fontFamily
                                            textColor: root.informationTextColor
                                            boxColor: root.chatBackgroungConverstationColor
                                            glowColor: root.glowColor
                                        }
                                        SettingsSliderItem{
                                            id:presencePenaltyId
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: frequencyPenaltyId.bottom
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            anchors.topMargin: 0
                                            myTextName: "Presence Penalty"
                                            sliderValue: 0
                                            sliderFrom: 0
                                            sliderTo: 1
                                            sliderStepSize:0.1
                                            fontFamily:root.fontFamily
                                            textColor: root.informationTextColor
                                            boxColor: root.chatBackgroungConverstationColor
                                            glowColor: root.glowColor
                                        }
                                    }
                                }


                                Rectangle{
                                    id: modelSettingsId
                                    height: modelSettingsButtonId.height /*+ modelSettingsInformationId.height*/
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: inferenceSettingsId.bottom
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    anchors.topMargin: 10
                                    color: "#00ffffff"
                                    Rectangle{
                                        id: modelSettingsButtonId
                                        height: 40
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.leftMargin: 5
                                        anchors.rightMargin: 5
                                        anchors.topMargin: 0
                                        color: "#00ffffff"
                                        Text {
                                            id: modelSettingsTextId
                                            text: qsTr("Model Settings")
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.left: parent.left
                                            anchors.leftMargin: 5
                                            font.pointSize: 10
                                            color: root.titleTextColor
                                            font.family: root.fontFamily
                                        }
                                        MyIcon {
                                            id: modelSettingsIconId
                                            visible: true
                                            // anchors.left: modelList.right
                                            anchors.right: parent.right
                                            width: 40
                                            anchors.top: parent.top
                                            anchors.bottom: parent.bottom
                                            // anchors.leftMargin: 0
                                            anchors.rightMargin: 0
                                            anchors.topMargin: 0
                                            myLable: modelSettingsInformationId.visible=== true? "close": "open"
                                            myIconId:  modelSettingsInformationId.visible=== true?"images/upIcon.svg":"images/downIcon.svg"
                                            myFillIconId: modelSettingsInformationId.visible=== true?"images/fillUpIcon.svg":"images/fillDownIcon.svg"
                                            normalColor: root.iconColor
                                            hoverColor: root.fillIconColor
                                            Connections {
                                                target: modelSettingsIconId
                                                function onClicked() {
                                                    if(modelSettingsInformationId.visible=== true){
                                                        modelSettingsInformationId.visible = false
                                                        modelSettingsId.height = modelSettingsButtonId.height
                                                    }else{
                                                        modelSettingsInformationId.visible = true
                                                        modelSettingsId.height = modelSettingsButtonId.height + modelSettingsInformationId.height
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    Rectangle{
                                        id: modelSettingsInformationId
                                        height: 120
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: modelSettingsButtonId.bottom
                                        anchors.leftMargin: 0
                                        anchors.rightMargin: 0
                                        anchors.topMargin: 0
                                        visible: false
                                        color: "#00ffffff"

                                        Text {
                                            id: promptTemplateTextId
                                            height: 20
                                            text: qsTr("Prompt template")
                                            anchors.left: parent.left
                                            anchors.leftMargin: 10
                                            font.pointSize: 10
                                            font.family: root.fontFamily
                                            color: root.informationTextColor
                                        }

                                        Rectangle {
                                            id: promptTemplateBox
                                            height: 80
                                            color: root.chatBackgroungConverstationColor
                                            radius: 12
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: promptTemplateTextId.bottom
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            anchors.topMargin: 0


                                            ScrollView {
                                                id: scrollPromptTemplate
                                                anchors.left: parent.left
                                                anchors.right: parent.right
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                anchors.leftMargin: 10
                                                anchors.rightMargin: 10
                                                anchors.topMargin: 5
                                                anchors.bottomMargin: 5

                                                TextArea {
                                                    id: promptTemplateTextBox
                                                    height: scrollPromptTemplate.height
                                                    visible: true
                                                    color: root.informationTextColor
                                                    anchors.left: parent.left
                                                    anchors.right: parent.right
                                                    anchors.leftMargin: 0
                                                    anchors.rightMargin: 0
                                                    wrapMode: Text.WordWrap
                                                    placeholderText: qsTr("Eg. You are a helpful assistant")
                                                    clip: false
                                                    font.pointSize: 10
                                                    hoverEnabled: true
                                                    tabStopDistance: 80
                                                    selectionColor: root.informationTextColor
                                                    cursorVisible: false
                                                    persistentSelection: true
                                                    placeholderTextColor: root.informationTextColor
                                                    font.family: root.fontFamily
                                                    onHeightChanged: {
                                                        if(promptTemplateBox.height < 70 && promptTemplateTextBox.text !== ""){
                                                            promptTemplateBox.height += 10;
                                                        }
                                                    }
                                                    background: Rectangle{
                                                        color: "#00ffffff"
                                                    }
                                                }
                                            }

                                            layer.enabled: true
                                            layer.effect: Glow {
                                                 samples: 15
                                                 color: root.glowColor
                                                 spread: 0.0
                                                 transparentBorder: true
                                             }
                                        }
                                    }
                                }


                                Rectangle{
                                    id: engineSettingsId
                                    height: engineSettingsButtonId.height /*+ engineSettingsInformationId.height*/
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: modelSettingsId.bottom
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    anchors.topMargin: 10
                                    color: "#00ffffff"

                                    Rectangle{
                                        id: engineSettingsButtonId
                                        height: 40
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.leftMargin: 5
                                        anchors.rightMargin: 5
                                        anchors.topMargin: 0
                                        color: "#00ffffff"

                                        Text {
                                            id: engineSettingsTextId
                                            text: qsTr("Engine Settings")
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.left: parent.left
                                            anchors.leftMargin: 5
                                            font.pointSize: 10
                                            font.family: root.fontFamily
                                            color: root.titleTextColor

                                        }
                                        MyIcon {
                                            id: engineSettingsIconId
                                            visible: true
                                            // anchors.left: modelList.right
                                            anchors.right: parent.right
                                            width: 40
                                            anchors.top: parent.top
                                            anchors.bottom: parent.bottom
                                            // anchors.leftMargin: 0
                                            anchors.rightMargin: 0
                                            anchors.topMargin: 0
                                            myLable: engineSettingsInformationId.visible=== true? "close":"open"
                                            myIconId:  engineSettingsInformationId.visible=== true?"images/upIcon.svg":"images/downIcon.svg"
                                            myFillIconId: engineSettingsInformationId.visible=== true?"images/fillUpIcon.svg":"images/fillDownIcon.svg"
                                            normalColor: root.iconColor
                                            hoverColor: root.fillIconColor
                                            Connections {
                                                target: engineSettingsIconId
                                                function onClicked() {
                                                    if(engineSettingsInformationId.visible=== true){
                                                        engineSettingsInformationId.visible = false
                                                        engineSettingsId.height = engineSettingsButtonId.height
                                                    }else{
                                                        engineSettingsInformationId.visible = true
                                                        engineSettingsId.height = engineSettingsButtonId.height + engineSettingsInformationId.height
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    Rectangle{
                                        id: engineSettingsInformationId
                                        height: contextLengthId.height+numberOfGPUId.height
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: engineSettingsButtonId.bottom
                                        anchors.leftMargin: 0
                                        anchors.rightMargin: 0
                                        anchors.topMargin: 0
                                        visible: false
                                        color: "#00ffffff"

                                        SettingsSliderItem{
                                            id:contextLengthId
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: parent.top
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            anchors.topMargin: 0
                                            myTextName: "Context Length"
                                            sliderValue: 4096
                                            sliderFrom: 120
                                            sliderTo:4096
                                            sliderStepSize:1
                                            fontFamily:root.fontFamily
                                            textColor: root.informationTextColor
                                            boxColor: root.chatBackgroungConverstationColor
                                            glowColor: root.glowColor
                                        }
                                        SettingsSliderItem{
                                            id:numberOfGPUId
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: contextLengthId.bottom
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            anchors.topMargin: 0
                                            myTextName: "Number of GPU layers (ngl)"
                                            sliderValue: 40
                                            sliderFrom: 1
                                            sliderTo: 100
                                            sliderStepSize:1
                                            fontFamily:root.fontFamily
                                            textColor: root.informationTextColor
                                            boxColor: root.chatBackgroungConverstationColor
                                            glowColor: root.glowColor
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                MyIcon {
                    id: rightDrawer
                    visible: true
                    anchors.right: modelSettings.visible=== true?modelSettings.left: parent.right
                    height: 40
                    width: 40
                    anchors.top: parent.top
                    anchors.rightMargin: 10
                    anchors.topMargin: 10
                    myLable: modelSettings.visible=== true? "close model settings":"open model settings"
                    myIconId: modelSettings.visible=== true? "./images/alignRightIcon.svg": "./images/alignLeftIcon.svg"
                    myFillIconId: modelSettings.visible=== true? "./images/fillAlignRightIcon.svg": "./images/fillAlignLeftIcon"
                    heightSource: 18
                    widthSource: 18
                    normalColor: root.iconColor
                    hoverColor: root.fillIconColor
                    Connections {
                        target: rightDrawer
                        function onClicked() {
                            if(modelSettings.visible=== true){
                                modelSettings.visible = false
                            }else{
                                modelSettings.visible = true
                            }
                        }
                    }
                }

                MyIcon {
                    id: leftDrawer
                    visible: true
                    anchors.left: parent.left
                    height: 40
                    width: 40
                    anchors.top: parent.top
                    anchors.leftMargin: 10
                    anchors.topMargin: 10
                    myLable: leftSidePage.visible=== true? "close history":"open history"
                    myIconId: leftSidePage.visible=== true? "./images/alignLeftIcon.svg":"./images/alignRightIcon.svg"
                    myFillIconId: leftSidePage.visible=== true? "./images/fillAlignLeftIcon":"./images/fillAlignRightIcon.svg"
                    heightSource: 18
                    widthSource: 18
                    normalColor: root.iconColor
                    hoverColor: root.fillIconColor
                    Connections {
                        target: leftDrawer
                        function onClicked() {
                            if(leftSidePage.visible=== true){
                                leftSidePage.visible = false
                            }else{
                                leftSidePage.visible = true
                            }
                        }
                    }
                }

                MyIcon {
                    id: newChatIcon2
                    visible: leftSidePage.visible=== true? false: true
                    anchors.left: leftDrawer.right
                    height: 40
                    width: 40
                    anchors.top: parent.top
                    anchors.leftMargin: 0
                    anchors.topMargin: 10
                    myLable: "New chat"
                    myIconId: "images/chatAddIcon.svg"
                    myFillIconId:  "images/chatAddIcon.svg"
                    heightSource: 19
                    widthSource: 19
                    normalColor: root.iconColor
                    hoverColor: root.fillIconColor
                    Connections {
                        target: newChatIcon2
                        function onClicked() {
                            root.chatListModel.addChat();
                        }
                    }
                }
            }
        }
    }
}


