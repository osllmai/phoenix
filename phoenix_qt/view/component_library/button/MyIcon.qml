import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import '../style' as Style

ToolButton {
    id: control
    width: (control.hovered && isNeedAnimation)? 36:33; height:  (control.hovered && isNeedAnimation)? 36:33

    property var myIcon
    property int iconType: Style.RoleEnum.IconType.Primary
    property bool isNeedAnimation: false

    property var myTextToolTip: ""

    background: Rectangle{
        id: backgroundId
        width: parent.width-6; height: parent.height-3
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 2
        color: control.choiceBackgroundColor(control.iconType)
        radius: 12
    }

    Behavior on width{ NumberAnimation{ duration: (control.isNeedAnimation && backgroundId.width >= control.width-3)? 200: 0}}
    Behavior on height{ NumberAnimation{ duration: (control.isNeedAnimation && backgroundId.height >= control.height-3)? 200: 0}}

    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevice.Mouse
        cursorShape: Qt.PointingHandCursor
    }

    icon{
        source: control.myIcon
        color: control.hovered? control.choiceHoverAndCheckedColor(control.iconType):
                                            control.choiceNormalColor(control.iconType);
        width: backgroundId.width; height: backgroundId.height
    }

    ToolTip{
        visible: control.hovered && (control.myTextToolTip != "")
        delay: 500
        timeout: 10000
        contentItem: Text {
                text: control.myTextToolTip
                // width: 100
                // wrapMode: Text.WordWrap
                color:Style.Colors.toolTipText
                font.pixelSize: 10
            }

        background: Rectangle{
            id: backgroundId2
            width: parent.width; height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 2
            color: Style.Colors.toolTipBackground
            border.color: Style.Colors.toolTipGlowAndBorder
            radius: 4
            layer.enabled: true
            layer.effect: Glow {
                 samples: 30
                 color: Style.Colors.toolTipGlowAndBorder
                 spread: 0.4
                 transparentBorder: true
             }
        }
    }

    function choiceNormalColor(iconType) {
        switch (iconType) {
            case Style.RoleEnum.IconType.Primary:
                return enabled? Style.Colors.iconPrimaryNormal: Style.Colors.iconPrimaryHoverAndChecked;
            case Style.RoleEnum.IconType.Image:
                return "#00ffffff";
            case Style.RoleEnum.IconType.FeatureBlue:
                return enabled? Style.Colors.iconFeatureBlueNormal: Style.Colors.iconFeatureBlueHoverAndChecked;
            case Style.RoleEnum.IconType.FeatureRed:
                return enabled? Style.Colors.iconFeatureRedNormal: Style.Colors.iconFeatureRedHoverAndChecked;
            case Style.RoleEnum.IconType.FeatureOrange:
                return enabled? Style.Colors.iconFeatureOrangeNormal: Style.Colors.iconFeatureOrangeHoverAndChecked;
            case Style.RoleEnum.IconType.FeatureMagenta:
                return enabled? Style.Colors.iconFeatureMagentaNormal: Style.Colors.iconFeatureMagentaHoverAndChecked;
            case Style.RoleEnum.IconType.FeatureYellow:
                return enabled? Style.Colors.iconFeatureYellowNormal: Style.Colors.iconFeatureYellowHoverAndChecked;
            case Style.RoleEnum.IconType.FeatureGreen:
                return enabled? Style.Colors.iconFeatureGreenNormal: Style.Colors.iconFeatureGreenHoverAndChecked;
            case Style.RoleEnum.IconType.Like:
                return enabled? Style.Colors.like: Style.Colors.like;
            default:
                return enabled? Style.Colors.iconPrimaryNormal: Style.Colors.iconPrimaryHoverAndChecked;
        }
    }

    function choiceHoverAndCheckedColor(iconType) {
        switch (iconType) {
            case Style.RoleEnum.IconType.Primary:
                return Style.Colors.iconPrimaryHoverAndChecked;
            case Style.RoleEnum.IconType.Image:
                return "#00ffffff";
            case Style.RoleEnum.IconType.FeatureBlue:
                return Style.Colors.iconFeatureBlueHoverAndChecked;
            case Style.RoleEnum.IconType.FeatureRed:
                return Style.Colors.iconFeatureRedHoverAndChecked;
            case Style.RoleEnum.IconType.FeatureOrange:
                return Style.Colors.iconFeatureOrangeHoverAndChecked;
            case Style.RoleEnum.IconType.FeatureMagenta:
                return Style.Colors.iconFeatureMagentaHoverAndChecked;
            case Style.RoleEnum.IconType.FeatureYellow:
                return Style.Colors.iconFeatureYellowHoverAndChecked;
            case Style.RoleEnum.IconType.FeatureGreen:
                return Style.Colors.iconFeatureGreenHoverAndChecked;
            case Style.RoleEnum.IconType.Like:
                return Style.Colors.like;
            default:
                return Style.Colors.iconPrimaryHoverAndChecked;
        }
    }

    function choiceBackgroundColor(iconType) {
        switch (iconType) {
            case Style.RoleEnum.IconType.Primary:
                return "#00ffffff";
            case Style.RoleEnum.IconType.Image:
                return "#00ffffff";
            case Style.RoleEnum.IconType.FeatureBlue:
                return Style.Colors.iconFeatureBlueBackground;
            case Style.RoleEnum.IconType.FeatureRed:
                return Style.Colors.iconFeatureRedBackground;
            case Style.RoleEnum.IconType.FeatureOrange:
                return Style.Colors.iconFeatureOrangeBackground;
            case Style.RoleEnum.IconType.FeatureMagenta:
                return Style.Colors.iconFeatureMagentaBackground;
            case Style.RoleEnum.IconType.FeatureYellow:
                return Style.Colors.iconFeatureYellowBackground;
            case Style.RoleEnum.IconType.FeatureGreen:
                return Style.Colors.iconFeatureGreenBackground;
            case Style.RoleEnum.IconType.Like:
                return "#00ffffff";
            default:
                return "#00ffffff";
        }
    }
}
