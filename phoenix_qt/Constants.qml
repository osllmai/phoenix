import QtCore
import QtQuick
import QtQuick.Controls.Basic

QtObject {
    property int width: 1229
    property int height: 685

    property var theme: "light"

    //dark theme
    property color darkBackgroundPage: "#242424"
    property color darkBackgroungAndGlow: "#1f1f1f"
    property color darkBox: "#242424"
    property color darkHeader: "#333333"
    property color darkNormalButton: "#3d3d3d"
    property color darkSelectButton: "#57b9fc"
    property color darkHoverButton: "#5f5f5f"
    property color darkfillIcon: "#57b9fc"
    property color darkIcon: "#ffffff"

    property color darkInformationText: "#ffffff"
    property color darkTitleText: "#57b9ee"
    property color darkSelectText: "#000000"

    //light theme
    property color lightBackgroundPage: "#ffffff"
    property color lightBackgroungAndGlow: "#ebebeb"
    property color lightBox: "#f3f3f3"
    property color lightHeader: "#f5f5f5"
    property color lightNormalButton: "#f5f5f5"
    property color lightSelectButton: "#ffffff"
    property color lightHoverButton: "#ffffff"
    property color lightFillIcon: "#5b5fc7"
    property color lightIcon: "#747474"

    property color lightTitleText: "#000000"
    property color lightInformationText: "#747474"
    property color lightSelectText: "#000000"


    //classic theme
    property color classic1: "#5b5fc7"
    property color classic2: "#e8ebfa"
    property color classic3: "#ebebeb"
    property color classic4: "#fafafa"
    property color classic5: "#ffffff"

    property color classicText1: "#ffffff"
    property color classicText2: "#ffffff"
    property color classicText3: "#ffffff"


    //small font
    property int smallPixelSizeText1: 10
    property int smallPixelSizeText2: 12
    property int smallPixelSizeText3: 14
    property int smallPixelSizeText4: 16


    //big font
    property int bigPixelSizeText1: 12
    property int bigPixelSizeText2: 14
    property int bigPixelSizeText3: 16
    property int bigPixelSizeText4: 18

    //font family
    property var fontFamilyTimesNewRoman: "Times New Roman"

    //general
    property color backgroundPageColor: theme == "light"? lightBackgroundPage: darkBackgroundPage
    property color backgroungAndGlowColor: theme == "light"? lightBackgroungAndGlow: darkBackgroungAndGlow
    property color boxColor: theme == "light"? lightBox: darkBox
    property color headerColor: theme == "light"? lightHeader: darkHeader
    property color normalButtonColor: theme == "light"? lightNormalButton: darkNormalButton
    property color selectButtonColor: theme == "light"? lightSelectButton: darkSelectButton
    property color hoverButtonColor: theme == "light"? lightHoverButton: darkHoverButton
    property color fillIconColor: theme == "light"? lightFillIcon: darkfillIcon
    property color iconColor: theme == "light"? lightIcon: darkIcon

    property color titleTextColor: theme == "light"? lightTitleText: darkTitleText
    property color informationTextColor: theme == "light"? lightInformationText: darkInformationText
    property color selectTextColor: theme == "light"? lightSelectText: darkSelectText

    property int pixelSizeText1: 10
    property int pixelSizeText2: 12
    property int pixelSizeText3: 14
    property int pixelSizeText4: 16

    property var fontFamily: "Times New Roman"
}
