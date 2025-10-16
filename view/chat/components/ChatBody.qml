import QtQuick 2.15
import QtQuick.Controls 2.15
import "./chat"
import '../../component_library/style' as Style
import '../../component_library/button'
import "./chat/components"
Item {
    id: chatBodyBoxId
    width: parent.width
    height: parent.height
    signal openModelList()
    function sendMessage(){
        if(conversationList.isEmptyConversation)
            inputBoxId2.sendMessage()
        else
            inputBoxId.sendMessage()
    }

    function requestEmptyTheInput(){
        inputBoxId.textInput = ""
        inputBoxId2.textInput = ""
    }

    function goToEnd(){
        myMessageView.goToEnd();
    }

    property string textInput: speechToText.text
    onTextInputChanged: {
        if(conversationList.isEmptyConversation)
            inputBoxId2.textInput  = chatBodyBoxId.textInput
        else if(!conversationList.isEmptyConversation)
            inputBoxId.textInput  = chatBodyBoxId.textInput
    }

    property var suggestions
    function fetchGoogleSuggestions(query) {
        if (query.trim() === "")
            return;

        const url = "http://suggestqueries.google.com/complete/search?client=firefox&q=" + encodeURIComponent(query);
        var xhr = new XMLHttpRequest();
        xhr.open("GET", url);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                try {
                    var json = JSON.parse(xhr.responseText);
                    var list = json[1];

                    list = list.filter(s => s.length > 20);

                    chatBodyBoxId.suggestions = list.slice(0, 5);
                } catch (e) {
                    console.log("JSON parse error:", e);
                }
            }
        }
        xhr.send();
    }


    Column{
        spacing: 10
        anchors.fill: parent
        visible: !conversationList.isEmptyConversation
        onVisibleChanged: {
            chatBodyBoxId.requestEmptyTheInput()
        }

        MyMessageList{
            id: myMessageView
        }
        InputPrompt{
            id: inputBoxId
            Connections{
                target: inputBoxId
                function onSendPrompt(prompt) {
                    const hasPrompt = prompt !== "";
                    if (conversationList.modelSelect && hasPrompt) {
                        myMessageView.goToEnd()
                        conversationList.currentConversation.prompt(prompt,
                                                                    (convertToMD.fileIsSelect? convertToMD.filePath:""),
                                                                    (convertToMD.fileIsSelect? convertToMD.textMD:""))
                        convertToMD.fileIsSelect = false;
                        chatBodyBoxId.requestEmptyTheInput()
                    } else if (hasPrompt) {
                        notificationDialogId.open();
                        chatBodyBoxId.openModelList();
                    }
                }

                function onOpenModelIsLoaded(){
                    modelIsloadedDialogId.open()
                }
            }
        }
    }

    NotificationDialog{
        id: notificationDialogId
        titleText: "No model selected"
        about:"Sorry! No model is currently active. Please try again later or check the settings."
    }

    NotificationDialog {
        id: modelIsloadedDialogId
        titleText: "Loading Model"
        about: "Please wait until the model finishes loading. You can stop the process after the loading is complete."
    }

    Column{
        id: columnId
        spacing: 8
        width: Math.min(700, parent.width - 48)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: conversationList.isEmptyConversation
        MyIcon {
            id: phoenixIconId
            myIcon: "qrc:/media/image_company/Phoenix.svg"
            iconType: Style.RoleEnum.IconType.Image
            anchors.horizontalCenter: parent.horizontalCenter
            enabled: false
            width: 100; height: 100
        }
        Label {
            id: phoenixId
            text: "Hello! I’m Phoenix."
            anchors.horizontalCenter: parent.horizontalCenter
            color: Style.Colors.textTitle
            font.pixelSize: 24
            font.styleName: "Bold"
        }
        InputPrompt{
            id:inputBoxId2
            Connections{
                target: inputBoxId2
                function onSendPrompt(prompt) {
                    const hasPrompt = prompt !== "";
                    if (conversationList.modelSelect && hasPrompt) {
                        conversationList.addRequest(prompt,
                                                    (convertToMD.fileIsSelect? convertToMD.filePath:""),
                                                    (convertToMD.fileIsSelect? convertToMD.textMD:""))
                        convertToMD.fileIsSelect = false;
                        chatBodyBoxId.requestEmptyTheInput()
                    } else if (hasPrompt) {
                        notificationDialogId.open();
                        chatBodyBoxId.openModelList();
                    }
                }
            }
        }


        // Flow{
        //     spacing: 5
        //     width: Math.min(parent.width, documentId.width + grammarId.width + rewriteId.width + imageEditorId.width + imageId.width + 20)
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     MyButton {
        //         id: documentId
        //         myText: "Document"
        //         myIcon: "qrc:/media/icon/document.svg"
        //         bottonType: Style.RoleEnum.BottonType.Feature
        //         iconType: Style.RoleEnum.IconType.FeatureBlue
        //         isNeedAnimation: true
        //     }
        //     MyButton {
        //         id: grammarId
        //         myText: "Grammer"
        //         myIcon: "qrc:/media/icon/grammer.svg"
        //         bottonType: Style.RoleEnum.BottonType.Feature
        //         iconType: Style.RoleEnum.IconType.FeatureRed
        //         isNeedAnimation: true
        //     }
        //     MyButton {
        //         id: rewriteId
        //         myText: "Rewrite"
        //         myIcon: "qrc:/media/icon/rewrite.svg"
        //         bottonType: Style.RoleEnum.BottonType.Feature
        //         iconType: Style.RoleEnum.IconType.FeatureOrange
        //         isNeedAnimation: true
        //     }
        //     MyButton {
        //         id: imageEditorId
        //         myText: "Image Editor"
        //         myIcon: "qrc:/media/icon/imageEditor.svg"
        //         bottonType: Style.RoleEnum.BottonType.Feature
        //         iconType: Style.RoleEnum.IconType.FeatureGreen
        //         isNeedAnimation: true
        //     }
        //     MyButton {
        //         id: imageId
        //         myText: "Image"
        //         myIcon: "qrc:/media/icon/image.svg"
        //         bottonType: Style.RoleEnum.BottonType.Feature
        //         iconType: Style.RoleEnum.IconType.FeatureYellow
        //         isNeedAnimation: true
        //     }
        // }
    }

    ListView {
        id: suggestionListView
        width: columnId.width - 40
        height: 35*5 + 16
        clip: true
        interactive: true
        spacing: 4
        model: chatBodyBoxId.suggestions
        visible: conversationList.isEmptyConversation
        anchors.top: columnId.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        delegate: SuggestionsButton{
            height: 35
            width: parent.width
            onClicked: {
                inputBoxId2.textInput = modelData
                chatBodyBoxId.suggestions = []
            }
        }

        //     Rectangle {
        //     width: parent.width
        //     height: Math.max(30, textItem.contentHeight + 10)
        //     radius: 6
        //     color: "#282828"

        //     Text {
        //         id: textItem
        //         text: modelData
        //         color: "white"
        //         wrapMode: Text.WordWrap
        //         anchors.fill: parent
        //         anchors.margins: 8
        //         font.pixelSize: 12
        //     }

        //     MouseArea {
        //         anchors.fill: parent
        //         onClicked: {
        //             inputBoxId2.textInput = modelData
        //             chatBodyBoxId.suggestions = []
        //         }
        //         hoverEnabled: true
        //         onEntered: parent.color = "#3a3a3a"
        //         onExited: parent.color = "#282828"
        //     }
        // }

        // visible: chatBodyBoxId.suggestions.length > 0
    }
}
