pragma Singleton

import QtQuick 2.15

Item{
    QtObject{
        id: textColor
        readonly property var light: ["#FFFFFF", "#B3B9C4", "#F7F8F9", "#44546F","#2C3E5D", "#172B4D", "#000000"]
        readonly property var dark: ["#000000", "#8C9BAB", "#9BB4CA80", "#9FADBC", "#B6C2CF", "#B6C2CF", "#FFFFFF" ]
    }
    property var currentTextColor: textColor.light
    property alias textColor: textColor

    QtObject{
        id: backgroundColor
        readonly property var light: ["#FFFFFF", "#F7F8F9", "#F1F2F4", "#DCDFE4", "#758195"]
        readonly property var dark: ["#161A1D", "#1D2125", "#22272B", "#2C333A", "#738496"]
    }
    property var currentBackgroundColor: backgroundColor.light
    property alias backgroundColor: backgroundColor

    QtObject{
        id: primaryColor
        readonly property var light: ["#F3F0FF", "#9F8FEF", "#6E5DC6", "#352C63", "#2B273F"]
        readonly property var dark: ["#2B273F", "#6E5DC6", "#9F8FEF", "#DFD8FD", "#F3F0FF"]
    }
    property var currentPrimaryColor: primaryColor.light
    property alias primaryColor: primaryColor

    QtObject{
        id: errorColor
        readonly property var light: ["#FFECEB", "#F87168", "#C9372C", "#5D1F1A", "#42221F"]
        readonly property var dark: ["#42221F", "#C9372C", "#F87168", "#FFD5D2", "#FFECEB"]
    }
    property var currentErrorColor: errorColor.light
    property alias errorColor: errorColor

    QtObject{
        id: successColor
        readonly property var light: ["#DCFFF1", "#4BCE97", "#1F845A", "#164B35", "#1C3329"]
        readonly property var dark: ["#1C3329", "#1F845A", "#4BCE97", "#164B35", "#DCFFF1"]
    }
    property var currentSuccessColor: successColor.light
    property alias successColor: successColor

    QtObject{
        id: warningColor
        readonly property var light: ["#FFF7D6", "#E2B203", "#B38600", "#533F04", "#332E1B"]
        readonly property var dark: ["#332E1B", "#B38600", "#E2B203", "#F8E6A0", "#FFF7D6"]
    }
    property var currentwarningColor: warningColor.light
    property alias warningColor: warningColor

    QtObject{
        id: infoColor
        readonly property var light: ["#E9F2FF", "#579DFF", "#0C66E4", "#09326C", "#1C2B41"]
        readonly property var dark: ["#1C2B41", "#0C66E4", "#579DFF", "#CCE0FF", "#E9F2FF"]
    }
    property var currentInfoColor: infoColor.light
    property alias infoColor: infoColor

    QtObject{
        id: colorForBlueLayers
        readonly property var light: ["#091E4208", "#091E420F", "#091E424F", "#091E424F", "#091E427D"]
        readonly property var dark: ["#BCD6F00A", "#A1BDD914", "#A6C5E229", "#BFDBF847", "#9BB4CA80"]
    }
    property var currentColorForBlueLayers: colorForBlueLayers.light
    property alias colorForBlueLayers: colorForBlueLayers

    QtObject{
        id: orangeColor
        readonly property var light: ["#FFF3EB", "#FEC195", "#A54800", "#702E00", "#38291E"]
        readonly property var dark: ["#38291E", "#A54800", "#FEC195", "#FEDEC8", "#FFF3EB"]
    }
    property var currentOrangeColor: orangeColor.light
    property alias orangeColor: orangeColor

    QtObject{
        id: magentaColor
        readonly property var light: ["#FFECF8", "#F797D2", "#943D73", "#50253F", "#3D2232"]
        readonly property var dark: ["#3D2232", "#943D73", "#F797D2", "#FDD0EC", "#FFECF8"]
    }
    property var currentMagentaColor: magentaColor.light
    property alias magentaColor: magentaColor

    QtObject{
        id: avatarBGDynamicColor
        readonly property var light: ["#82B536", "#F15B50", "#F38A3F", "#CF9F02", "#2ABB7F", "#42B2D7", "#388BFF", "#8F7EE7", "#DA62AC", "#DCDFE4"]
        readonly property var dark: ["#82B536", "#F15B50", "#F38A3F", "#CF9F02", "#2ABB7F", "#42B2D7", "#388BFF", "#8F7EE7", "#DA62AC", "#2C333A"]
    }
    property var currentAvatarBGDynamicColor: avatarBGDynamicColor.light
    property alias avatarBGDynamicColor: avatarBGDynamicColor

    QtObject{
        id: overlayColor
        readonly property var light: [/*"#091E420F"*/ "#47c8c8c8"]
        readonly property var dark: ["#b80a0a0a"]
    }
    property var currentOverlayColor: overlayColor.light
    property alias overlayColor: overlayColor


    //----------------------------------*************--------------------------------//
    //----------------------------------AppMenu Colors--------------------------------//
    readonly property color menuNormalIcon: currentBackgroundColor[4]
    readonly property color menuHoverAndCheckedIcon: currentPrimaryColor[2]
    readonly property color menuHoverBackground: currentBackgroundColor[2]
    readonly property color menuShowCheckedRectangle: currentPrimaryColor[2]
    readonly property color menuBackground: currentBackgroundColor[2]
    //-------------------------------end AppMenu Colors------------------------------//


    //---------------------------------------*******--------------------------------------//
    //----------------------------------------general---------------------------------------//
    //app
    readonly property color background: currentBackgroundColor[0]

    //menuApp Color
    readonly property color menu: currentBackgroundColor[1]

    //ovrlay Color
    readonly property color overlay: currentOverlayColor[0]

    //toolTip color
    readonly property color toolTipText: currentTextColor[6]
    readonly property color toolTipBackground: currentBackgroundColor[1]
    readonly property color toolTipGlowAndBorder: currentBackgroundColor[4]

    //text color
    readonly property color textTitle: currentTextColor[6]
    readonly property color textInformation: currentTextColor[5]

    //icon color
    readonly property color iconNormal: currentBackgroundColor[4]
    readonly property color iconHoverAndChecked: currentPrimaryColor[2]

    //botton primary color
    readonly property color buttonPrimaryNormal: currentPrimaryColor[2]
    readonly property color buttonPrimaryHover: currentPrimaryColor[3]
    readonly property color buttonPrimaryPressed: currentPrimaryColor[4]
    readonly property color buttonPrimaryDisabled: currentPrimaryColor[1]
    readonly property color buttonPrimarySelected: currentPrimaryColor[0]
    readonly property color buttonPrimaryBorderNormal: currentPrimaryColor[2]
    readonly property color buttonPrimaryBorderHover: currentPrimaryColor[3]
    readonly property color buttonPrimaryBorderPressed: currentPrimaryColor[4]
    readonly property color buttonPrimaryBorderDisabled: currentPrimaryColor[1]
    readonly property color buttonPrimaryBorderSelected: currentPrimaryColor[0]
    readonly property color buttonPrimaryTextNormal: currentTextColor[0]
    readonly property color buttonPrimaryTextHover: currentTextColor[0]
    readonly property color buttonPrimaryTextPressed: currentTextColor[0]
    readonly property color buttonPrimaryTextDisabled: currentTextColor[3]
    readonly property color buttonPrimaryTextSelected: currentTextColor[1]

    //botton Secondary color
    readonly property color buttonSecondaryNormal: currentPrimaryColor[0]
    readonly property color buttonSecondaryHover: currentBackgroundColor[3]
    readonly property color buttonSecondaryPressed: currentPrimaryColor[1]
    readonly property color buttonSecondaryDisabled: currentPrimaryColor[1]
    readonly property color buttonSecondarySelected: currentPrimaryColor[0]
    readonly property color buttonSecondaryBorderNormal: currentPrimaryColor[0]
    readonly property color buttonSecondaryBorderHover: currentPrimaryColor[2]
    readonly property color buttonSecondaryBorderPressed: currentPrimaryColor[3]
    readonly property color buttonSecondaryBorderDisabled: currentPrimaryColor[1]
    readonly property color buttonSecondaryBorderSelected: currentPrimaryColor[2]
    readonly property color buttonSecondaryTextNormal: currentTextColor[3]
    readonly property color buttonSecondaryTextHover: currentTextColor[4]
    readonly property color buttonSecondaryTextPressed: currentTextColor[5]
    readonly property color buttonSecondaryTextDisabled: currentTextColor[6]
    readonly property color buttonSecondaryTextSelected: currentPrimaryColor[2]

    //botton danger color
    readonly property color buttonDangerNormal: currentErrorColor[2]
    readonly property color buttonDangerHover: currentErrorColor[3]
    readonly property color buttonDangerPressed: currentErrorColor[4]
    readonly property color buttonDangerDisabled: currentErrorColor[1]
    readonly property color buttonDangerSelected: currentErrorColor[0]
    readonly property color buttonDangerBorderNormal: currentErrorColor[2]
    readonly property color buttonDangerBorderHover: currentErrorColor[3]
    readonly property color buttonDangerBorderPressed: currentErrorColor[4]
    readonly property color buttonDangerBorderDisabled: currentErrorColor[1]
    readonly property color buttonDangerBorderSelected: currentErrorColor[0]
    readonly property color buttonDangerTextNormal: currentTextColor[0]
    readonly property color buttonDangerTextHover: currentTextColor[0]
    readonly property color buttonDangerTextPressed: currentTextColor[0]
    readonly property color buttonDangerTextDisabled: currentTextColor[3]
    readonly property color buttonDangerTextSelected: currentTextColor[1]

    //box color
    readonly property color boxNormalGradient0: currentBackgroundColor[1]
    readonly property color boxNormalGradient1: currentBackgroundColor[3]
    readonly property color boxHoverGradient0: currentBackgroundColor[1]
    readonly property color boxHoverGradient1: currentBackgroundColor[3]
    readonly property color boxBorder: currentBackgroundColor[3]
    readonly property color boxHover: currentBackgroundColor[1]

    //like color
    readonly property color like: currentErrorColor[1]

    //------------------------------------end general--------------------------------------//
}
