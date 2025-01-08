pragma Singleton

import QtQuick

QtObject {
    property string theme: "light"

    //dark theme
    property color darkBackgroundPage: /*"#242424"*/ "#333333"
    property color darkBackgroung: "#1f1f1f"
    property color darkGlow: /*"#d7d7d7"*/  "#1f1f1f"
    property color darkBox: /*"#1f1f1f"*/  "#333333"
    property color darkHeader: /*"#333333"*/ "#242424"
    property color darkNormalButton:/* "#242424"*/ "#333333"
    property color darkSelectButton:/* "#57b9fc"*/ "#1f1f1f"
    property color darkHoverButton: "#5f5f5f"
    property color darkFillIcon:  "#5b5fc7" /* "#57b9fc"*/
    property color darkMenuIcon:/* "#57b9fc"*/  "#ffffff"
    property color darkIcon: "#ffffff"
    property color darkColorOverlay: "#b80a0a0a"

    property color darkInformationText: "#ffffff"
    property color darkTitleText: "#cbcdff"
    property color darkSelectText: "#000000"

    //dark theme for chat page
    property color darkChatBackgroung: "#242424"
    property color darkChatBackgroungConverstation: "#333333"
    property color darkChatMessageBackgroung:"#333333"
    property color darkChatMessageTitleText: "#cbcdff"
    property color darkChatMessageInformationText: "#ffffff"
    property bool darkChatMessageIsGlow: true


    //light theme
    property color lightBackgroundPage: "#ffffff"
    property color lightBackgroung: "#ebebeb"
    property color lightGlow: "#d7d7d7"
    property color lightBox: /*"#ebebeb"*/  "#f5f5f5"
    property color lightHeader: "#f5f5f5"
    property color lightNormalButton: "#f5f5f5"
    property color lightSelectButton: "#ffffff"
    property color lightHoverButton: "#ffffff"
    property color lightFillIcon: "#5b5fc7"
    property color lightMenuIcon: "#747474"
    property color lightIcon: "#5b5fc7"
    property color lightColorOverlay: "#99bfbfbf"

    property color lightTitleText: "#000000"
    property color lightInformationText: "#474747"
    property color lightSelectText: "#000000"


    //light theme for chat page
    property color lightChatBackgroung: "#f5f5f5"
    property color lightChatBackgroungConverstation: "#ffffff"
    property color lightChatMessageBackgroung: "#ebebeb"
    property color lightChatMessageTitleText: "#474747"
    property color lightChatMessageInformationText: "#000000"
    property bool lightChatMessageIsGlow: false


    //general
    property color backgroundPageColor: theme == "light"? lightBackgroundPage: darkBackgroundPage
    property color backgroungColor: theme == "light"? lightBackgroung: darkBackgroung
    property color glowColor: theme == "light"? lightGlow: darkGlow
    property color boxColor: theme == "light"? lightBox: darkBox
    property color headerColor: theme == "light"? lightHeader: darkHeader
    property color normalButtonColor: theme == "light"? lightNormalButton: darkNormalButton
    property color selectButtonColor: theme == "light"? lightSelectButton: darkSelectButton
    property color hoverButtonColor: theme == "light"? lightHoverButton: darkHoverButton
    property color fillIconColor: theme == "light"? lightFillIcon: darkFillIcon
    property color menuIconColor: theme == "light"? lightMenuIcon: darkMenuIcon
    property color iconColor: theme == "light"? lightIcon: darkIcon
    property color colorOverlay: theme == "light"? lightColorOverlay: darkColorOverlay

    property color titleTextColor: theme == "light"? lightTitleText: darkTitleText
    property color informationTextColor: theme == "light"? lightInformationText: darkInformationText
    property color selectTextColor: theme == "light"? lightSelectText: darkSelectText

    //theme for chat page
    property color chatBackgroungColor: theme == "light"? lightChatBackgroung: darkChatBackgroung
    property color chatBackgroungConverstationColor: theme == "light"? lightChatBackgroungConverstation: darkChatBackgroungConverstation
    property color chatMessageBackgroungColor: theme == "light"? lightChatMessageBackgroung: darkChatMessageBackgroung
    property color chatMessageTitleTextColor: theme == "light"? lightChatMessageTitleText: darkChatMessageTitleText
    property color chatMessageInformationTextColor: theme == "light"? lightChatMessageInformationText: darkChatMessageInformationText
    property bool chatMessageIsGlow: theme == "light"?lightChatMessageIsGlow: darkChatMessageIsGlow

    property var fontFamily: "Times New Roman"
}
