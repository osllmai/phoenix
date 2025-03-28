import QtQuick 2.15

QtObject {
    enum Menu{
        PageMenu,
        ButtonMenu
    }

    enum BottonType{
        Primary,
        Secondary,
        Danger,
        Feature,
        Progress
    }

    enum IconType{
        Primary,
        Image,
        FeatureBlue,
        FeatureRed,
        FeatureOrange,
        FeatureMagenta,
        FeatureYellow,
        FeatureGreen,
        Like
    }

    enum State{
        Normal,
        Hover,
        Pressed,
        Disabled,
        Selected
    }
}
