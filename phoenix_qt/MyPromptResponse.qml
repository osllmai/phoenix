import QtQuick 2.15
// import QtQuick.Templates 2.1 as T
// import QtQuick.Layouts
// import Qt5Compat.GraphicalEffects
import QtQuick.Controls 2.15


Item {
    id: root
    width: 400
    height: columnDelegate.height

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

    //information about model
    property var prompt
    property var response
    property var promptTime
    property var responseTime
    property var dateRequest
    property bool isFinished
    property bool isLoadModel
    property var executionTime
    property var numberOfToken

    signal regenerateResponse()
    signal editPrompt(var text_edit)
    signal nextPrompt()
    signal beforPrompt()
    signal nextResponse()
    signal beforResponse()
    property int numberOfPrompt
    property int numberOfRegenerate
    property int numberOfResponse
    property int numberOfEdit


    Rectangle{
        id: backgroundId
        color: "#00ffffff"
        radius: 0
        anchors.fill: parent

        Rectangle{
            id: columnDelegate
            width: parent.width
            height: root.dateRequest === ""? userBox.height + llmBox.height :userBox.height + llmBox.height + dateBoxId.height + 20
            color: "#00ffffff"

            Rectangle{
                id:dateBoxId
                height: 20
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 20
                color: "#00ffffff"
                visible: root.dateRequest !== ""

                Text {
                    id: dateId
                    text: root.dateRequest
                    color: root.chatMessageTitleTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 10
                    font.family: "Times New Roman"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle{
                id: userBox
                height: userTextRec.height +timeText.height+20
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: root.dateRequest !== ""?dateBoxId.bottom:parent.top
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0
                color: "#00ffffff"

                Rectangle{
                    id: userImageRec
                    width: 30
                    height: 30
                    color: "#00ffffff"
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 0
                    anchors.topMargin: 10
                    Image{
                        id: userImage
                        anchors.fill: parent
                        source: "images/userIcon.svg"
                        sourceSize.height: 30
                        sourceSize.width: 30
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                        clip: true
                    }
                }

                MyMessage{
                    id: userTextRec
                    anchors.right: userImageRec.left
                    anchors.top: parent.top
                    anchors.rightMargin: 2
                    anchors.topMargin: 10
                    maxWidth: root.width - 90
                    isLLM: false
                    isLoadModel: root.isLoadModel
                    myText: root.prompt
                    executionTime: root.executionTime
                    numberOfToken:root.numberOfToken

                    Connections {
                        target: userTextRec
                        function onRegenerateOrEdit(text_edit){
                            root.editPrompt(text_edit);
                        }
                        function onNextMessage(){
                            root.nextPrompt()
                        }
                        function onBeforMessage(){
                            root.beforPrompt()
                        }
                    }
                    numberOfMessage: root.numberOfPrompt
                    numberOfRegenerateOrEdit: root.numberOfEdit


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

                Text {
                    id: timeText
                    color: root.chatMessageTitleTextColor
                    text: root.promptTime
                    anchors.right: userImageRec.left
                    anchors.bottom: userTextRec.top
                    anchors.rightMargin: 5
                    anchors.bottomMargin: 2

                    font.pointSize: 8
                    font.family: root.fontFamily
                }
            }

            Rectangle{
                id: llmBox
                height: llmTextRec.height +llmTimeText.height+20
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: userBox.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0
                color: "#00ffffff"

                Rectangle{
                    id: llmImageRec
                    visible:root.response !=""
                    width: 30
                    height: 30
                    color: "#00ffffff"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 0
                    anchors.topMargin: 10
                    Image{
                        id: llmImage
                        anchors.fill: parent
                        source: "images/phoenix.png"
                        sourceSize.height: 30
                        sourceSize.width: 30
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                        clip: true
                    }  
                }
                BusyIndicator {
                    id: busyIndicator
                    width: 40
                    height: 40
                    visible:root.response ==""
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 0
                    anchors.topMargin: 10
                    wheelEnabled: false
                    focusPolicy: Qt.NoFocus
                }

                MyMessage{
                    id: llmTextRec
                    visible:root.response !=""
                    anchors.left: llmImageRec.right
                    anchors.top: parent.top
                    anchors.leftMargin: 2
                    anchors.topMargin: 10
                    maxWidth: root.width -90
                    isLLM: true
                    myText: root.response
                    isFinished: root.isFinished
                    isLoadModel: root.isLoadModel
                    executionTime: root.executionTime
                    numberOfToken:root.numberOfToken

                    Connections {
                        target: llmTextRec
                        function onRegenerateOrEdit(text_edit){
                            root.regenerateResponse();
                        }
                        function onNextMessage(){
                            root.nextResponse()
                        }
                        function onBeforMessage(){
                            root.beforResponse()
                        }
                    }
                    numberOfMessage: root.numberOfResponse
                    numberOfRegenerateOrEdit: root.numberOfRegenerate

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

                Text {
                    id: llmTimeText
                    visible:root.response !=""
                    color: root.chatMessageTitleTextColor
                    text: root.responseTime
                    anchors.left: llmImageRec.right
                    anchors.bottom: llmTextRec.top
                    anchors.leftMargin: 5
                    anchors.bottomMargin: 2

                    font.pointSize: 8
                    font.family: root.fontFamily
                }
            }
        }
    }
}
