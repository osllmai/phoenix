import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

import Phoenix
import Qt5Compat.GraphicalEffects

Item {
    id: root
    width: 200
    height: inputBox.height

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

    property var modelListModel
    property var currentChat

    signal goToModelPage()
    signal sendPrompt(var prompt)
    signal loadModelInCurrentChat(int indexModel)

    Rectangle {
        id: inputBox
        height: 40 + selectModelId.height
        width: parent.width

        color: root.chatBackgroungConverstationColor
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
                color: root.informationTextColor
                wrapMode: Text.Wrap
                placeholderText: root.currentChat.isLoadModel? qsTr("What is in your mind ?"): qsTr("Load a model to continue ...")
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
                placeholderTextColor: root.informationTextColor
                font.family: root.fontFamily
                onHeightChanged: {
                    if(inputTextBox.height >30 && inputTextBox.text !== ""){
                        inputBox.height  = Math.min(inputTextBox.height + 10 + selectModelId.height, 180+selectModelId.height) ;
                    }if(inputTextBox.text === ""){
                        inputBox.height = 40 + selectModelId.height
                    }
                }

                // onHeightChanged: {
                //     if(inputBox.height < 150 && inputTextBox.text !== ""){
                //         inputBox.height += 6;
                //     }
                // }
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
            normalColor: root.iconColor
            hoverColor: root.fillIconColor
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

                modelListModel: root.modelListModel
                Connections{
                    target: modelListDialog
                    function onGoToModelPage(){
                        loadModelPopup.close()
                        root.goToModelPage()
                    }

                    function onLoadModelDialog(indexModel){
                        root.loadModelInCurrentChat(indexModel)
                        // root.currentChat.loadModelRequested(indexModel);
                        loadModelPopup.close()
                    }
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
