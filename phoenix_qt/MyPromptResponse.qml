import QtQuick 2.15
// import QtQuick.Templates 2.1 as T
// import QtQuick.Layouts
// import Qt5Compat.GraphicalEffects

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


    property bool isFinished: true
    property var prompt
    property var response

    Rectangle{
        id: backgroundId
        color: "#00ffffff"
        radius: 0
        anchors.fill: parent

        Rectangle{
            id: columnDelegate
            width: parent.width
            height: userBox.height + llmBox.height
            color: "#00ffffff"
            Rectangle{
                id: userBox
                height: userTextRec.height +30
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                color: "#00ffffff"

                Rectangle{
                    id: userImageRec
                    width: 30
                    height: 30
                    color: "#00ffffff"
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 0
                    anchors.topMargin: 23
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
                    anchors.topMargin: 20
                    maxWidth: root.width - 90
                    isFinished: true
                    isLLM: false
                    myText: root.prompt

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
                    text: qsTr("Oct 20, 2024, 02:07:37 PM")
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
                height: llmTextRec.height +30
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: userBox.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0
                color: "#00ffffff"

                Rectangle{
                    id: llmImageRec
                    width: 30
                    height: 30
                    color: "#00ffffff"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 0
                    anchors.topMargin: 23
                    Image{
                        id: llmImage
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
                    id: llmTextRec
                    anchors.left: llmImageRec.right
                    anchors.top: parent.top
                    anchors.leftMargin: 2
                    anchors.topMargin: 20
                    maxWidth: root.width -90
                    isFinished: isFinished
                    isLLM: true
                    myText: root.response

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
                    color: root.chatMessageTitleTextColor
                    text: qsTr("Oct 20, 2024, 02:07:37 PM")
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
