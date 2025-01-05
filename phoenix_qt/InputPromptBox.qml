import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

import Phoenix
import Qt5Compat.GraphicalEffects
import 'style' as Style

Item {
    id: root
    width: 200
    height: inputBox.height

    property var modelListModel
    property var currentChat

    signal goToModelPage()
    signal sendPrompt(var prompt)
    signal loadModelInCurrentChat(int indexModel)

    Rectangle {
        id: inputBox
        height: 40 + selectModelId.height
        width: parent.width

        color: Style.Theme.chatBackgroungConverstationColor
        radius: 12

        ScrollView {
            id: scrollInput
            anchors.left: parent.left
            anchors.right: sendIcon.left
            anchors.top: parent.top
            anchors.bottom: selectModelId.top
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 5
            anchors.bottomMargin: 5

            TextArea {
                id: inputTextBox
                height: text.height
                enabled: root.currentChat.isLoadModel
                color: Style.Theme.informationTextColor
                wrapMode: Text.Wrap
                placeholderText: inputTextBox.placeholderTextInput()

                function placeholderTextInput(){
                    if( root.currentChat.isLoadModel){
                        return qsTr("What is in your mind ?");
                    }else if( root.currentChat.loadModelInProgress){
                        return qsTr("Loading model " + root.currentChat.model.name);
                    }else{
                        return qsTr("Load a model to continue ...");
                    }
                }

                Accessible.role: Accessible.EditableText
                Accessible.name: placeholderText
                Accessible.description: qsTr("Send prompts to the model")

                clip: false
                font.pointSize: 12
                hoverEnabled: true
                tabStopDistance: 80
                selectionColor: "#fff5fe"
                cursorVisible: false
                persistentSelection: true
                placeholderTextColor: Style.Theme.informationTextColor
                font.family: Style.Theme.fontFamily
                onHeightChanged: {
                    if(inputTextBox.height >30 && inputTextBox.text !== ""){
                        inputBox.height  = Math.min(inputTextBox.height + 10 + selectModelId.height, 180+selectModelId.height) ;
                    }if(inputTextBox.text === ""){
                        inputBox.height = 40 + selectModelId.height
                    }
                }

                onEditingFinished: {
                    // inputBoxRec.layer.enabled= false
                }
                onPressed: {
                    // inputBoxRec.layer.enabled= true
                }

                Keys.onReturnPressed: (event)=> {
                  if (event.modifiers & Qt.ControlModifier || event.modifiers & Qt.ShiftModifier)
                    event.accepted = false;
                  else {
                        sendIcon.actionClicked()
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
            enabled: root.currentChat.isLoadModel
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 35
            myLable: root.currentChat.responseInProgress? "Stop":"Send"
            myIconId: root.currentChat.responseInProgress? "images/stopIcon.svg" : "images/sendIcon.svg"
            myFillIconId:  root.currentChat.responseInProgress? "images/fillStopIcon.svg" : "images/fillSendIcon.svg"
            heightSource: 16
            widthSource: 16
            normalColor: Style.Theme.iconColor
            hoverColor: Style.Theme.fillIconColor
            Connections {
                target: sendIcon
                function onActionClicked() {
                    root.sendPrompt(inputTextBox.text)
                    inputTextBox.text = ""; // Clear the input
                    inputBox.height = 40 + selectModelId.height;
                }
            }
        }

        Rectangle{
            id: selectModelId
            height: 35
            color: "#00ffffff"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            MyButton{
                id:loadModelIcon
                visible:! root.currentChat.loadModelInProgress
                width: 200
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 15
                anchors.topMargin: 5
                anchors.bottomMargin: 5
                myTextId:  root.currentChat.isLoadModel? root.currentChat.model.name: "load Model"
                Connections{
                    target:loadModelIcon
                    function onClicked(){
                        loadModelPopup.open()
                    }
                }
            }
            ProgressBar {
                id: progressBarLoadModel
                height: 5
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.leftMargin: 15
                anchors.rightMargin: 15
                visible: root.currentChat.loadModelInProgress
                value: 0.5
                indeterminate: true
            }
        }

        Popup {
            id: loadModelPopup
            width: 200
            height: 250
            x: 0
            y: -180
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            background:Rectangle{
                color: "#00ffffff" // Background color of tooltip
                radius: 4
                anchors.fill: parent
            }
            ModelDialog{
                id: modelListDialog
                modelListModel: root.modelListModel
                Connections{
                    target: modelListDialog
                    function onGoToModelPage(){
                        loadModelPopup.close()
                        root.goToModelPage()
                    }

                    function onLoadModelDialog(indexModel){
                        root.loadModelInCurrentChat(indexModel)
                        loadModelPopup.close()
                    }
                }
            }
        }

        layer.enabled: true
        layer.effect: Glow {
            samples: 15
            color: Style.Theme.glowColor
            spread: 0.0
            transparentBorder: true
         }
    }
}
