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
        readonly property var light: [ "#47c8c8c8", "#b80a0a0a"]
        readonly property var dark: ["#b80a0a0a", "#b80a0a0a"]
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
    readonly property color overlay: currentOverlayColor[1]
    readonly property color overlayDrawer: currentOverlayColor[0]

    //toolTip color
    readonly property color toolTipText: currentTextColor[6]
    readonly property color toolTipBackground: currentBackgroundColor[0]
    readonly property color toolTipGlowAndBorder: currentBackgroundColor[3]

    //text color
    readonly property color textTitle: currentTextColor[6]
    readonly property color textInformation: currentTextColor[5]

    //icon color
    readonly property color iconPrimaryNormal: currentBackgroundColor[4]
    readonly property color iconPrimaryHoverAndChecked: currentPrimaryColor[2]

    readonly property color iconFeatureBlueNormal: currentInfoColor[1]
    readonly property color iconFeatureBlueHoverAndChecked: currentInfoColor[2]
    readonly property color iconFeatureBlueBackground: currentInfoColor[0]

    readonly property color iconFeatureRedNormal: currentErrorColor[1]
    readonly property color iconFeatureRedHoverAndChecked: currentErrorColor[2]
    readonly property color iconFeatureRedBackground: currentErrorColor[0]

    readonly property color iconFeatureOrangeNormal: currentOrangeColor[1]
    readonly property color iconFeatureOrangeHoverAndChecked: currentOrangeColor[2]
    readonly property color iconFeatureOrangeBackground: currentOrangeColor[0]

    readonly property color iconFeatureMagentaNormal: currentMagentaColor[1]
    readonly property color iconFeatureMagentaHoverAndChecked: currentMagentaColor[2]
    readonly property color iconFeatureMagentaBackground: currentMagentaColor[0]

    readonly property color iconFeatureYellowNormal: currentwarningColor[1]
    readonly property color iconFeatureYellowHoverAndChecked: currentwarningColor[2]
    readonly property color iconFeatureYellowBackground: currentwarningColor[0]

    readonly property color iconFeatureGreenNormal: currentSuccessColor[1]
    readonly property color iconFeatureGreenHoverAndChecked: currentSuccessColor[2]
    readonly property color iconFeatureGreenBackground: currentSuccessColor[0]

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

    //botton Secondary color
    readonly property color buttonFeatureNormal: "#00ffffff"
    readonly property color buttonFeatureHover: currentBackgroundColor[2]
    readonly property color buttonFeaturePressed: currentPrimaryColor[1]
    readonly property color buttonFeatureDisabled: currentPrimaryColor[1]
    readonly property color buttonFeatureSelected: currentBackgroundColor[1]
    readonly property color buttonFeatureBorderNormal: currentBackgroundColor[2]
    readonly property color buttonFeatureBorderHover: currentBackgroundColor[3]
    readonly property color buttonFeatureBorderPressed: currentPrimaryColor[2]
    readonly property color buttonFeatureBorderDisabled: currentPrimaryColor[0]
    readonly property color buttonFeatureBorderSelected: currentPrimaryColor[1]
    readonly property color buttonFeatureTextNormal: currentTextColor[3]
    readonly property color buttonFeatureTextHover: currentTextColor[4]
    readonly property color buttonFeatureTextPressed: currentTextColor[5]
    readonly property color buttonFeatureTextDisabled: currentTextColor[6]
    readonly property color buttonFeatureTextSelected: currentPrimaryColor[2]

    //botton progress color
    readonly property color buttonProgressNormal: currentPrimaryColor[1]
    readonly property color buttonProgressHover: currentPrimaryColor[2]
    readonly property color buttonProgressPressed: currentPrimaryColor[2]
    readonly property color buttonProgressDisabled: currentPrimaryColor[1]
    readonly property color buttonProgressSelected: currentPrimaryColor[1]
    readonly property color buttonProgressNormalGradient0: currentPrimaryColor[2]
    readonly property color buttonProgressHoverGradient0: currentPrimaryColor[3]
    readonly property color buttonProgressPressedGradient0: currentPrimaryColor[3]
    readonly property color buttonProgressDisabledGradient0: currentPrimaryColor[0]
    readonly property color buttonProgressSelectedGradient0: currentPrimaryColor[0]
    readonly property color buttonProgressNormalGradient1: currentPrimaryColor[3]
    readonly property color buttonProgressHoverGradient1: currentPrimaryColor[4]
    readonly property color buttonProgressPressedGradient1: currentPrimaryColor[4]
    readonly property color buttonProgressDisabledGradient1: currentPrimaryColor[3]
    readonly property color buttonProgressSelectedGradient1: currentPrimaryColor[3]
    readonly property color buttonProgressBorderNormal: currentPrimaryColor[1]
    readonly property color buttonProgressBorderHover: currentPrimaryColor[2]
    readonly property color buttonProgressBorderPressed: currentPrimaryColor[3]
    readonly property color buttonProgressBorderDisabled: currentPrimaryColor[0]
    readonly property color buttonProgressBorderSelected: currentPrimaryColor[0]
    readonly property color buttonProgressTextNormal: currentTextColor[0]
    readonly property color buttonProgressTextHover: currentTextColor[0]
    readonly property color buttonProgressTextPressed: currentTextColor[0]
    readonly property color buttonProgressTextDisabled: currentTextColor[3]
    readonly property color buttonProgressTextSelected: currentTextColor[1]


    //box color
    readonly property color boxNormalGradient0: currentBackgroundColor[1]
    readonly property color boxNormalGradient1: currentBackgroundColor[3]
    readonly property color boxHoverGradient0: currentBackgroundColor[1]
    readonly property color boxHoverGradient1: currentBackgroundColor[3]
    readonly property color boxBorder: currentBackgroundColor[3]
    readonly property color boxChecked: currentPrimaryColor[0]
    readonly property color boxHover: currentBackgroundColor[1]

    //like color
    readonly property color like: currentErrorColor[1]

    //progressBar
    readonly property color progressBarText: currentTextColor[6]
    readonly property color progressBarBackground: currentPrimaryColor[0]
    readonly property color progressBarGradient0: currentPrimaryColor[1]
    readonly property color progressBarGradient1: currentPrimaryColor[3]

    //------------------------------------end general--------------------------------------//
}
