import QtQuick 2.15
import QtQuick.Controls 2.15
import '../style' as Style

ToolButton {
    id: control
    width:30; height:30

    property var myIcon
    property int iconType: Style.RoleEnum.IconType.Primary

    background: Rectangle{
        anchors.fill: parent
        anchors.margins: 2
        color: control.choiceBackgroundColor(control.iconType)
        radius: 12
    }

    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevice.Mouse
        cursorShape: Qt.PointingHandCursor
    }

    icon{
        source: control.myIcon
        color: control.hovered? control.choiceHoverAndCheckedColor(control.iconType):
                                            control.choiceNormalColor(control.iconType);
        width: control.width; height: control.height
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
            default:
                return "#00ffffff";
        }
    }
}
