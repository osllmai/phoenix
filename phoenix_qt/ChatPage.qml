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
                width: mainStructure.width / 4
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
                            heightSource: 18
                            widthSource: 18
                            normalColor: root.iconColor
                            hoverColor: root.fillIconColor
                            Connections {
                                target: newChatIcon
                                function onClicked() {
                                    root.chatListModel.addChat();
                                    historylist.contentY = historylist.contentHeight;
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
                            text: qsTr("History")
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

                Rectangle{
                    id:lineId3
                    height: parent.height
                    color: "#e1e1e1"
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    width: 1
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

                Rectangle {
                    id: chatStack
                    // width: Math.min(700,parent.width)
                    anchors.left: parent.left
                    anchors.right: modelSettings.visible=== true? modelSettings.left: parent.right
                    anchors.top: header.bottom
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

                        Rectangle {
                            id: textChat
                            color: "#00ffffff"
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: inputBoxRec.top
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            anchors.topMargin: 24
                            anchors.bottomMargin: 12
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

                                    function scrollToEnd() {
                                        listViewChat.positionViewAtEnd()
                                    }

                                    onContentHeightChanged: {
                                        if (atYEnd)
                                            scrollToEnd()
                                    }
                                }
                            }
                        }

                        Rectangle{
                            id: inputBoxRec
                            width: parent.width
                            height: inputBox.height+36
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            color: rightSidePage.color
                            Rectangle {
                                id: inputBox
                                height: 40
                                color: parent.color
                                radius: 12
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.leftMargin: 24
                                anchors.rightMargin: 24
                                anchors.bottomMargin: 24

                                Rectangle{
                                    id:lineInputBox
                                    width: parent.width - 16
                                    height: 3
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 0
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    color: /*root.iconColor*/root.glowColor
                                    visible: false
                                }

                                ScrollView {
                                    id: scrollInput
                                    anchors.left: parent.left
                                    anchors.right: sendIcon.left
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    anchors.topMargin: 5
                                    anchors.bottomMargin: 5

                                    TextArea {
                                        id: inputTextBox
                                        height: scrollInput.height
                                        visible: true
                                        color: root.informationTextColor
                                        wrapMode: Text.Wrap
                                        placeholderText: root.currentChat.isLoadModel? qsTr("What is in your mind ?"): qsTr("Load a model to continue ...")
                                        clip: false
                                        font.pointSize: 12
                                        hoverEnabled: true
                                        tabStopDistance: 80
                                        selectionColor: "#fff5fe"
                                        cursorVisible: false
                                        persistentSelection: true
                                        placeholderTextColor: root.informationTextColor
                                        font.family: root.fontFamily
                                        onHeightChanged: {
                                            if(inputBox.height < 150 && inputTextBox.text !== ""){
                                                inputBox.height += 6;
                                            }
                                        }
                                        onEditingFinished: {
                                            lineInputBox.visible= false
                                        }
                                        onPressed: {
                                            lineInputBox.visible= true
                                        }

                                        Keys.onReturnPressed: (event)=> {
                                          if (event.modifiers & Qt.ControlModifier || event.modifiers & Qt.ShiftModifier)
                                            event.accepted = false;
                                          else {
                                              if(root.currentChat.responseInProgress){
                                                  root.currentChat.responseInProgress = false;
                                              }else if (inputTextBox.text !== "") {
                                                  chatModel.prompt(inputTextBox.text);
                                                  inputTextBox.text = ""; // Clear the input
                                                  listViewChat.contentY = listViewChat.contentHeight; // Scroll to bottom
                                                  inputBox.height = 40;
                                              }
                                          }
                                        }

                                        background: Rectangle{
                                            color: "#00ffffff"
                                        }
                                    }
                                }

                                MyIcon {
                                    id: sendIcon
                                    width: 40
                                    height: 40
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    myLable: root.currentChat.responseInProgress? "Stop":"Send"
                                    myIconId: root.currentChat.responseInProgress? "images/stopIcon.svg" : "images/sendIcon.svg"
                                    myFillIconId:  root.currentChat.responseInProgress? "images/fillStopIcon.svg" : "images/fillSendIcon.svg"
                                    heightSource: 16
                                    widthSource: 16
                                    normalColor: root.iconColor
                                    hoverColor: root.fillIconColor
                                    Connections {
                                        target: sendIcon
                                        function onClicked() {
                                            if(root.currentChat.responseInProgress){
                                                root.currentChat.responseInProgress = false;
                                            }else if (inputTextBox.text !== "") {
                                                chatModel.prompt(inputTextBox.text);
                                                inputTextBox.text = ""; // Clear the input
                                                listViewChat.contentY = listViewChat.contentHeight; // Scroll to bottom
                                                inputBox.height = 40;
                                            }
                                        }
                                    }
                                }

                                layer.enabled: true
                                layer.effect: Glow {
                                    samples: 30
                                    color: root.glowColor
                                    spread: 0.0
                                    transparentBorder: true
                                 }
                            }
                        }
                    }
                }

                Rectangle{
                    id:modelSettings
                    width: mainStructure.width / 4
                    anchors.top: header.bottom
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                    color: "#00ffffff"
                    anchors.right: parent.right
                    anchors.rightMargin: 0
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
                                Connections {
                                    target: assistantMenue
                                    function onClicked(){ settingsSpace.currentIndex = 0}
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
                                Connections {
                                    target: modelMenue
                                    function onClicked(){ settingsSpace.currentIndex = 1}
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
                                color: root.boxColor
                                radius: 12
                                border.color: "#eaeaea"
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
                                        height: scrollInput.height
                                        visible: true
                                        color: "#343434"
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
                                        selectionColor: "#fff5fe"
                                        cursorVisible: false
                                        persistentSelection: true
                                        placeholderTextColor: "#343434"
                                        font.family: root.fontFamily
                                        onHeightChanged: {
                                            if(instructionsBox.height < settingsSpace.height - 100 && instructionTextBox.text !== ""){
                                                instructionsBox.height += 10;
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
                                     color: root.backgroungAndGlowColor
                                     spread: 0.0
                                     // radius: 2
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
                                    height: inferenceSettingsButtonId.height + inferenceSettingsInformationId.height
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    anchors.topMargin: 0

                                    Rectangle{
                                        id: inferenceSettingsButtonId
                                        height: 40
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.leftMargin: 5
                                        anchors.rightMargin: 5
                                        anchors.topMargin: 0
                                        Text {
                                            id: inferenceSettingsTextId
                                            text: qsTr("Inference Settings")
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.left: parent.left
                                            anchors.leftMargin: 5
                                            font.pointSize: 10
                                            font.styleName: "Bold"
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
                                            myLable: inferenceSettingsInformationId.visible=== true?"open":"close"
                                            myIconId: "images/upIcon.svg"
                                            myFillIconId: "images/fillUpIcon.svg"
                                            normalColor: root.iconColor
                                            hoverColor: root.fillIconColor
                                            Connections {
                                                target: inferenceSettingsIconId
                                                function onClicked () {
                                                    if(inferenceSettingsInformationId.visible=== true){
                                                        inferenceSettingsInformationId.visible = false
                                                        inferenceSettingsId.height = inferenceSettingsButtonId.height
                                                        inferenceSettingsIconId.myIconId = "images/downIcon.svg"
                                                        inferenceSettingsIconId.myFillIconId = "images/fillDownIcon.svg"
                                                    }else{
                                                        inferenceSettingsInformationId.visible = true
                                                        inferenceSettingsId.height = inferenceSettingsButtonId.height + inferenceSettingsInformationId.height
                                                        inferenceSettingsIconId.myIconId = "images/upIcon.svg"
                                                        inferenceSettingsIconId.myFillIconId = "images/fillUpIcon.svg"
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
                                        visible: true

                                        SettingsSwitchItem{
                                            id:streamId
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: parent.top
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            anchors.topMargin: 0
                                            myTextName: "Stream"
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
                                        }
                                    }
                                }


                                Rectangle{
                                    id: modelSettingsId
                                    height: modelSettingsButtonId.height + modelSettingsInformationId.height
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: inferenceSettingsId.bottom
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    anchors.topMargin: 10
                                    Rectangle{
                                        id: modelSettingsButtonId
                                        height: 40
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.leftMargin: 5
                                        anchors.rightMargin: 5
                                        anchors.topMargin: 0
                                        Text {
                                            id: modelSettingsTextId
                                            text: qsTr("Model Settings")
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.left: parent.left
                                            anchors.leftMargin: 5
                                            font.pointSize: 10
                                            font.styleName: "Bold"
                                            font.family: root.fontFamily
                                        }
                                        MyIcon {
                                            id: modelSettingsIconId
                                            visible: true
                                            anchors.left: modelList.right
                                            anchors.right: parent.right
                                            width: 40
                                            anchors.top: parent.top
                                            anchors.bottom: parent.bottom
                                            anchors.leftMargin: 0
                                            anchors.rightMargin: 0
                                            anchors.topMargin: 0
                                            myLable: modelSettingsInformationId.visible=== true?"open":"close"
                                            myIconId: "images/upIcon.svg"
                                            myFillIconId: "images/fillUpIcon.svg"
                                            normalColor: root.iconColor
                                            hoverColor: root.fillIconColor
                                            Connections {
                                                target: modelSettingsIconId
                                                function onClicked() {
                                                    if(modelSettingsInformationId.visible=== true){
                                                        modelSettingsInformationId.visible = false
                                                        modelSettingsId.height = modelSettingsButtonId.height
                                                        modelSettingsIconId.myIconId = "images/downIcon.svg"
                                                        modelSettingsIconId.myFillIconId = "images/fillDownIcon.svg"
                                                    }else{
                                                        modelSettingsInformationId.visible = true
                                                        modelSettingsId.height = modelSettingsButtonId.height + modelSettingsInformationId.height
                                                        modelSettingsIconId.myIconId = "images/upIcon.svg"
                                                        modelSettingsIconId.myFillIconId = "images/fillUpIcon.svg"
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
                                        visible: true

                                        Text {
                                            id: promptTemplateTextId
                                            height: 20
                                            text: qsTr("Prompt template")
                                            anchors.left: parent.left
                                            anchors.leftMargin: 10
                                            font.pointSize: 10
                                            font.styleName: "Bold"
                                            font.family: root.fontFamily
                                        }

                                        Rectangle {
                                            id: promptTemplateBox
                                            height: 80
                                            color: root.boxColor
                                            radius: 12
                                            border.color: "#eaeaea"
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
                                                    color: "#343434"
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
                                                    selectionColor: "#fff5fe"
                                                    cursorVisible: false
                                                    persistentSelection: true
                                                    placeholderTextColor: "#343434"
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
                                                 color: root.backgroungAndGlowColor
                                                 spread: 0.0
                                                 transparentBorder: true
                                             }
                                        }
                                    }
                                }


                                Rectangle{
                                    id: engineSettingsId
                                    height: engineSettingsButtonId.height + engineSettingsInformationId.height
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: modelSettingsId.bottom
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    anchors.topMargin: 10
                                    Rectangle{
                                        id: engineSettingsButtonId
                                        height: 40
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.leftMargin: 5
                                        anchors.rightMargin: 5
                                        anchors.topMargin: 0
                                        Text {
                                            id: engineSettingsTextId
                                            text: qsTr("Engine Settings")
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.left: parent.left
                                            anchors.leftMargin: 5
                                            font.pointSize: 10
                                            font.styleName: "Bold"
                                            font.family: root.fontFamily
                                        }
                                        MyIcon {
                                            id: engineSettingsIconId
                                            visible: true
                                            anchors.left: modelList.right
                                            anchors.right: parent.right
                                            width: 40
                                            anchors.top: parent.top
                                            anchors.bottom: parent.bottom
                                            anchors.leftMargin: 0
                                            anchors.rightMargin: 0
                                            anchors.topMargin: 0
                                            myLable: engineSettingsInformationId.visible=== true?"open":"close"
                                            myIconId: "images/upIcon.svg"
                                            myFillIconId: "images/fillUpIcon.svg"
                                            normalColor: root.iconColor
                                            hoverColor: root.fillIconColor
                                            Connections {
                                                target: engineSettingsIconId
                                                function onClicked() {
                                                    if(engineSettingsInformationId.visible=== true){
                                                        engineSettingsInformationId.visible = false
                                                        engineSettingsId.height = engineSettingsButtonId.height
                                                        engineSettingsIconId.myIconId = "images/downIcon.svg"
                                                        engineSettingsIconId.myFillIconId = "images/fillDownIcon.svg"
                                                    }else{
                                                        engineSettingsInformationId.visible = true
                                                        engineSettingsId.height = engineSettingsButtonId.height + engineSettingsInformationId.height
                                                        engineSettingsIconId.myIconId = "images/upIcon.svg"
                                                        engineSettingsIconId.myFillIconId = "images/fillUpIcon.svg"
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
                                        visible: true
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
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle{
                        id:lineId
                        height: parent.height
                        color: "#e1e1e1"
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        width: 1
                    }
                }

                Rectangle {
                    id: header
                    height: 60
                    color: root.chatBackgroungColor
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0

                    MyIcon {
                        id: leftDrawer
                        visible: true
                        anchors.left: parent.left
                        width: 40
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
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
                        height: 40
                        width: 40
                        anchors.left: leftDrawer.right
                        anchors.leftMargin: 3
                        anchors.verticalCenter: parent.verticalCenter
                        myLable: "New chat"
                        myIconId: "images/chatAddIcon.svg"
                        myFillIconId:  "images/chatAddIcon.svg"
                        heightSource: 18
                        widthSource: 18
                        normalColor: root.iconColor
                        hoverColor: root.fillIconColor
                        Connections {
                            target: newChatIcon2
                            function onClicked() {
                                root.chatListModel.addChat();
                                historylist.contentY = historylist.contentHeight;
                            }
                        }
                    }

                    MyComboBox {
                        id: modelList
                        height: 35
                        width: 200
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: root.fontFamily
                        anchors.horizontalCenter: parent.horizontalCenter

                        backgroundPageColor: root.chatBackgroungColor
                        backgroungColor: root.backgroungColor
                        glowColor: root.glowColor
                        boxColor: root.boxColor
                        headerColor: root.chatBackgroungConverstationColor
                        normalButtonColor: root.normalButtonColor
                        selectButtonColor: root.selectButtonColor
                        hoverButtonColor: root.hoverButtonColor
                        fillIconColor: root.fillIconColor
                        iconColor: root.iconColor

                        titleTextColor: root.titleTextColor
                        informationTextColor: root.informationTextColor
                        selectTextColor: root.selectTextColor

                        editable: true
                        model: modelListModel
                        valueRole: "id"
                        textRole: "name"

                        Layout.fillWidth: true
                        currentIndex: {
                            var i = modelList.indexOfValue(ChatListModel.currentChat.modelInfo.id);
                            if (i >= 0)
                                return i;
                            return 0;
                        }
                        contentItem: Text {
                            leftPadding: 10
                            rightPadding: 20
                            text: modelList.currentText
                            font: modelList.font
                            color:"red"
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
                        delegate: ItemDelegate {
                            width: modelList.width -20
                            contentItem: Text {
                                text: name
                                color: "yellow"
                                font: modelList.font
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                            }
                            background: Rectangle {
                                radius: 10
                                color: "green"
                            }
                            highlighted: modelList.highlightedIndex === index
                        }
                    }

                    MyIcon {
                        id: rightDrawer
                        visible: true
                        anchors.right: parent.right
                        width: 40
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
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

                    Rectangle{
                        id:lineId2
                        height: 1
                        color: "#e1e1e1"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        width: parent.width
                    }
                }
            }
        }
    }
}


