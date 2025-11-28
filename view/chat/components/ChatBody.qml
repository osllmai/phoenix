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
        chatBodyBoxId.suggestions = []
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
                function onSendPrompt(prompt, converstationType) {
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
            myIcon: "qrc:/media/image_company/phoenix.svg"
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
                function onSendPrompt(prompt, converstationType) {
                    const hasPrompt = prompt !== "";
                    if (conversationList.modelSelect && hasPrompt) {
                        conversationList.addRequest(prompt,
                                                    (convertToMD.fileIsSelect? convertToMD.filePath:""),
                                                    (convertToMD.fileIsSelect? convertToMD.textMD:""),
                                                    converstationType)
                        convertToMD.fileIsSelect = false;
                        chatBodyBoxId.requestEmptyTheInput()
                    } else if (hasPrompt) {
                        notificationDialogId.open();
                        chatBodyBoxId.openModelList();
                    }
                }
            }
        }
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

        delegate: SuggestionsButton {
            onClicked: suggestionListView.suggestionClicked(modelData)
        }
        signal suggestionClicked(string text)
        onSuggestionClicked: function(text) {
            inputBoxId2.textInput = text
            chatBodyBoxId.suggestions = []
            chatBodyBoxId.sendMessage()
        }

    }
}
