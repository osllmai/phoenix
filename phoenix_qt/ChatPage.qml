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

    signal goToModelPage()

    property bool isTheme

    Rectangle{
        id: chatPage
        color: root.chatBackgroungConverstationColor
        radius: 4
        anchors.fill: parent

        Row{
            id: mainStructure
            anchors.fill: parent

            Rectangle{
                id: leftSidePage
                width: Math.min(mainStructure.width / 4, 350)
                height: mainStructure.height
                color: root.chatBackgroungColor
                visible: true

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
                                function onActionClicked() {
                                    root.chatListModel.addChat();
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
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    anchors.topMargin: 0
                    anchors.bottomMargin: 10

                    Rectangle{
                        id: emptyChatListId
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: recHistoryText.bottom
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
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
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        anchors.topMargin: 0
                        anchors.bottomMargin: 0
                        color: "#00000000"
                        visible: root.chatListModel.size > 0

                        ListView {
                            id: historylist
                            anchors.fill: parent
                            model: root.chatListModel
                            ScrollBar.vertical: ScrollBar {
                                policy: ScrollBar.AsNeeded
                            }
                            clip: true
                            delegate: Rectangle{
                                id: delegateChat
                                width: historylist.width -25
                                height: model.date!==""? dateHistoryId.height + applicationButton.height +7:  applicationButton.height +7
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                color: "#00000000"

                                Text {
                                    id:dateHistoryId
                                    text: model.date
                                    height: 20
                                    font.pointSize: 10
                                    font.family: root.fontFamily
                                    color: root.informationTextColor
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.leftMargin: 5
                                    visible:model.date!==""
                                }

                                MyChatItem {
                                      id: applicationButton
                                      height: 35
                                      anchors.left: parent.left
                                      anchors.right: parent.right
                                      anchors.top: model.date!==""?dateHistoryId.bottom:parent.top
                                      anchors.leftMargin: 0
                                      anchors.rightMargin: 0
                                      anchors.topMargin: 0
                                      fontFamily: root.fontFamily
                                      myTextId: model.title
                                      isCurrentItem: root.chatListModel.currentChat === root.chatListModel.getChat(index)
                                      isTheme: root.isTheme
                                      fillIconColor: root.fillIconColor
                                      iconColor: root.iconColor
                                      normalButtonColor: root.normalButtonColor
                                      selectButtonColor: root.selectButtonColor
                                      hoverButtonColor: root.hoverButtonColor
                                      chatMessageInformationTextColor: root.chatMessageInformationTextColor

                                      backgroundPageColor: root.backgroundPageColor
                                      backgroungColor: root.backgroungColor
                                      boxColor: root.boxColor
                                      headerColor: root.headerColor
                                      titleTextColor: root.titleTextColor
                                      informationTextColor: root.informationTextColor
                                      selectTextColor: root.selectTextColor


                                      glowColor: root.glowColor

                                      Connections {
                                            target: applicationButton
                                            function onCurrentChat(){
                                                  root.chatListModel.currentChat = root.chatListModel.getChat(index);
                                            }
                                            function onDeleteChat(){
                                                  root.chatListModel.deleteChat(index)
                                            }
                                            function onEditChatName(chatName){
                                                root.chatListModel.editChatName(index, chatName)
                                            }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle{
                        id: recHistoryText
                        width: parent.width
                        height: 60
                        color:"#00000000"
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
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 0
                radius: 10

                Rectangle {
                    id: chatStack
                    anchors.left: parent.left
                    anchors.right: modelSettings.visible=== true? modelSettings.left: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 0
                    color: "#00ffffff"

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
                            anchors.leftMargin: 0
                            anchors.rightMargin: 0
                            anchors.topMargin: 60
                            anchors.bottomMargin: 0
                            visible: !root.emptyConversation

                            ColumnLayout{
                                anchors.fill: parent
                                ListView {
                                    id: listViewChat
                                    Layout.maximumWidth: 1280
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Layout.leftMargin: 0
                                    Layout.rightMargin: 0
                                    Layout.alignment: Qt.AlignHCenter

                                    model: root.chatModel
                                    cacheBuffer: Math.max(0, listViewChat.contentHeight)

                                    clip: true

                                    ScrollBar.vertical: ScrollBar {
                                        policy: ScrollBar.AsNeeded
                                        background: Rectangle {
                                            color: leftSidePage.color
                                            radius: 4
                                            visible: ScrollBar.AsNeeded
                                        }
                                    }

                                    delegate: Rectangle{
                                        id: myPromptResponseBox
                                        width: listViewChat.width - 10 - 100
                                        height: myPromptResponseId.height
                                        color: root.chatBackgroungConverstationColor


                                        MyPromptResponse{
                                            id: myPromptResponseId
                                            width: parent.width
                                            anchors.left:parent.left
                                            anchors.leftMargin: 60

                                            prompt: model.prompt
                                            response: model.response
                                            promptTime: model.promptTime
                                            responseTime: model.responseTime
                                            dateRequest: model.dateRequest

                                            executionTime: model.executionTime
                                            numberOfToken:model.numberOfToken
                                            isFinished: root.currentChat.responseInProgress
                                            isLoadModel: root.currentChat.isLoadModel

                                            Connections {
                                                target: myPromptResponseId
                                                function onRegenerateResponse(){
                                                    root.chatModel.regenerateResponse(index)
                                                }
                                                function onEditPrompt(text_edit){
                                                    root.chatModel.editPrompt(index, text_edit)
                                                }
                                                function onNextPrompt(){
                                                    root.chatModel.nextPrompt(index, model.numberPrompt)
                                                }
                                                function onBeforPrompt(){
                                                    root.chatModel.nextPrompt(index, model.numberPrompt-2)
                                                }
                                                function onNextResponse(){
                                                    root.chatModel.nextResponse(index, model.numberResponse)
                                                }
                                                function onBeforResponse(){
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

                                    onContentHeightChanged: {
                                            listViewChat.positionViewAtEnd()
                                    }                                  
                                }
                            }
                        }

                        Rectangle{
                            id: inputBoxRec
                            width: parent.width
                            height: inputBox.height+30
                            anchors.left: parent.left
                            anchors.right: parent.right
                            color: rightSidePage.color

                            y: root.emptyConversation?inputBoxRec.y = emptyMessageText.y + 50:
                                                                    inputBoxRec.y = rightSidePage.y + rightSidePage.height - inputBoxRec.height

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
                                    // function onLoadModelDialog(promptTemplate, systemPrompt){
                                    //     instructionTextBox.text = systemPrompt
                                    //     promptTemplateTextBox.text = promptTemplate
                                    // }
                                }
                            }
                        }
                    }
                }

                Rectangle{
                    id:modelSettings
                    width: Math.min(mainStructure.width / 4, 350)
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    anchors.rightMargin: 10
                    color: root.chatBackgroungColor
                    radius:5
                    visible: false


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

                                    ScrollBar.vertical: ScrollBar {
                                        policy: ScrollBar.AsNeeded
                                    }

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

                                Column{
                                    width: parent.width
                                    spacing: 5
                                    Rectangle{
                                        id: inferenceSettingsId
                                        height: inferenceSettingsButtonId.height
                                        width: parent.width
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
                                                anchors.right: parent.right
                                                width: 40
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                anchors.rightMargin: 0
                                                anchors.topMargin: 0
                                                myLable: inferenceSettingsInformationId.visible=== true? "close": "open"
                                                myIconId:  inferenceSettingsInformationId.visible=== true?"images/upIcon.svg":"images/downIcon.svg"
                                                myFillIconId: inferenceSettingsInformationId.visible=== true?"images/fillUpIcon.svg":"images/fillDownIcon.svg"
                                                normalColor: root.iconColor
                                                hoverColor: root.fillIconColor
                                                Connections {
                                                    target: inferenceSettingsIconId
                                                    function onActionClicked () {
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
                                            MouseArea{
                                                anchors.fill: parent
                                                onClicked:{
                                                    inferenceSettingsIconId.actionClicked()
                                                }
                                            }
                                        }

                                        Column{
                                            id: inferenceSettingsInformationId
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: inferenceSettingsButtonId.bottom
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            anchors.topMargin: 0
                                            visible: false

                                            SettingsSwitchItem{
                                                id:streamId
                                                width: parent.width
                                                myTextName: "Stream"
                                                fontFamily:root.fontFamily
                                                textColor: root.informationTextColor
                                            }
                                            SettingsSliderItem{
                                                id:temperatureId
                                                width: parent.width
                                                myTextName: "Temperature"
                                                myTextDescription: "Controls response randomness, lower values make responses more predictable, higher values make them more creative."
                                                sliderValue: 1.0
                                                sliderFrom: 0.0
                                                sliderTo:2.0
                                                sliderStepSize:0.1
                                                fontFamily:root.fontFamily
                                                textColor: root.informationTextColor
                                                boxColor: root.chatBackgroungConverstationColor
                                                glowColor: root.glowColor
                                            }
                                            SettingsSliderItem{
                                                id:topPId
                                                width: parent.width
                                                myTextName: "Top-P"
                                                myTextDescription:"Limits word selection to a subset with a cumulative probability above p, affecting response diversity."
                                                sliderValue: 1.0
                                                sliderFrom: 0.0
                                                sliderTo:1.0
                                                sliderStepSize:0.1
                                                fontFamily:root.fontFamily
                                                textColor: root.informationTextColor
                                                boxColor: root.chatBackgroungConverstationColor
                                                glowColor: root.glowColor
                                            }
                                            SettingsSliderItem{
                                                id:maxTokensId
                                                width: parent.width
                                                myTextName: "Max Tokens"
                                                myTextDescription: "Defines the maximum number of tokens the model can process in one input or output."
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
                                                width: parent.width
                                                myTextName: "Frequency Penalty"
                                                myTextDescription: "Reduces the likelihood of repeating the same word or phrase."
                                                sliderValue: 0.0
                                                sliderFrom: 0.0
                                                sliderTo: 2.0
                                                sliderStepSize:0.1
                                                fontFamily:root.fontFamily
                                                textColor: root.informationTextColor
                                                boxColor: root.chatBackgroungConverstationColor
                                                glowColor: root.glowColor
                                            }
                                            SettingsSliderItem{
                                                id:presencePenaltyId
                                                width: parent.width
                                                myTextName: "Presence Penalty"
                                                myTextDescription: "Reduces the likelihood of repeating any word or phrase already present."
                                                sliderValue: 0.0
                                                sliderFrom: 0.0
                                                sliderTo: 2.0
                                                sliderStepSize:0.1
                                                fontFamily:root.fontFamily
                                                textColor: root.informationTextColor
                                                boxColor: root.chatBackgroungConverstationColor
                                                glowColor: root.glowColor
                                            }
                                            SettingsSliderItem{
                                                id:promptBatchSizeId
                                                width: parent.width
                                                myTextName: "Prompt Batch Size"
                                                myTextDescription:"Refers to the number of prompts processed in a single batch, affecting processing efficiency."
                                                sliderValue: 1
                                                sliderFrom: 1
                                                sliderTo: 128
                                                sliderStepSize:1
                                                fontFamily:root.fontFamily
                                                textColor: root.informationTextColor
                                                boxColor: root.chatBackgroungConverstationColor
                                                glowColor: root.glowColor
                                            }
                                            SettingsSliderItem{
                                                id:minPId
                                                width: parent.width
                                                myTextName: "Min-P"
                                                myTextDescription:"Sets the minimum cumulative probability threshold for word selection."
                                                sliderValue: 0.0
                                                sliderFrom: 0.0
                                                sliderTo: 1.0
                                                sliderStepSize:0.1
                                                fontFamily:root.fontFamily
                                                textColor: root.informationTextColor
                                                boxColor: root.chatBackgroungConverstationColor
                                                glowColor: root.glowColor
                                            }
                                            SettingsSliderItem{
                                                id:maxLengthId
                                                width: parent.width
                                                myTextName: "Max Lenght"
                                                myTextDescription: "Defines the maximum length of input and output combined, limiting the generated text."
                                                sliderValue: 1024
                                                sliderFrom: 1
                                                sliderTo: 4096
                                                sliderStepSize:1
                                                fontFamily:root.fontFamily
                                                textColor: root.informationTextColor
                                                boxColor: root.chatBackgroungConverstationColor
                                                glowColor: root.glowColor
                                            }
                                            SettingsSliderItem{
                                                id:topKId
                                                width: parent.width
                                                myTextName: "Top-K"
                                                myTextDescription: "Limits word selection to the top K most probable words, controlling output diversity."
                                                sliderValue: 1
                                                sliderFrom: 1
                                                sliderTo: 50000
                                                sliderStepSize:1
                                                fontFamily:root.fontFamily
                                                textColor: root.informationTextColor
                                                boxColor: root.chatBackgroungConverstationColor
                                                glowColor: root.glowColor
                                            }
                                            SettingsSliderItem{
                                                id:repeatPenaltyTokensId
                                                width: parent.width
                                                myTextName: "Repeat Penalty Tokens"
                                                myTextDescription: "Increases the penalty for repeating specific tokens during generation."
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
                                                id:repeatPenaltyId
                                                width: parent.width
                                                myTextName: "Repeat Penalty"
                                                myTextDescription: "Discourages repeating words or phrases by applying a penalty to repeated tokens."
                                                sliderValue: 1.0
                                                sliderFrom: 1.0
                                                sliderTo: 2.0
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
                                        height: modelSettingsButtonId.height
                                        width: parent.width
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
                                                anchors.right: parent.right
                                                width: 40
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                anchors.rightMargin: 0
                                                anchors.topMargin: 0
                                                myLable: modelSettingsInformationId.visible=== true? "close": "open"
                                                myIconId:  modelSettingsInformationId.visible=== true?"images/upIcon.svg":"images/downIcon.svg"
                                                myFillIconId: modelSettingsInformationId.visible=== true?"images/fillUpIcon.svg":"images/fillDownIcon.svg"
                                                normalColor: root.iconColor
                                                hoverColor: root.fillIconColor
                                                Connections {
                                                    target: modelSettingsIconId
                                                    function onActionClicked() {
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
                                            MouseArea{
                                                anchors.fill: parent
                                                onClicked:{
                                                    modelSettingsIconId.actionClicked()
                                                }
                                            }
                                        }

                                        Column{
                                            id: modelSettingsInformationId
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: modelSettingsButtonId.bottom
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            anchors.topMargin: 0
                                            visible: false

                                            Text {
                                                id: promptTemplateTextId
                                                height: 20
                                                text: qsTr("Prompt template")
                                                font.pointSize: 10
                                                font.family: root.fontFamily
                                                color: root.informationTextColor
                                            }

                                            Rectangle {
                                                id: promptTemplateBox
                                                height: 80
                                                color: root.chatBackgroungConverstationColor
                                                radius: 12
                                                width: parent.width

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
                                        height: engineSettingsButtonId.height
                                        width: parent.width
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
                                                    function onActionClicked() {
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
                                            MouseArea{
                                                anchors.fill: parent
                                                onClicked:{
                                                    engineSettingsIconId.actionClicked()
                                                }
                                            }
                                        }

                                        Column{
                                            id: engineSettingsInformationId
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: engineSettingsButtonId.bottom
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            anchors.topMargin: 0
                                            visible: false

                                            SettingsSliderItem{
                                                id:contextLengthId
                                                myTextName: "Context Length"
                                                myTextDescription: "Refers to the number of tokens the model considers from the input when generating a response."
                                                sliderValue: 2048
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
                                                myTextName: "Number of GPU layers (ngl)"
                                                myTextDescription: "Refers to the number of layers processed using a GPU, affecting performance."
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
                        function onActionClicked() {
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
                        function onActionClicked() {
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
                        function onActionClicked() {
                            root.chatListModel.addChat();
                        }
                    }
                }
            }
        }
    }
}


