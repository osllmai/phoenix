import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import '../style' as Style

T.Button {
    id: control
    width: calculateWidthBotton()+6; height: 35

    // ---------- measurements used instead of direct ids ----------
    property real measuredTextWidth: 0
    property real measuredTextHeight: 0
    property real measuredPrimaryIconWidth: 0
    property real measuredPrimaryIconHeight: 0
    property real measuredIconWidth: 0
    property real measuredIconHeight: 0

    // ---------- visual state properties (changed by states) ----------
    property color controlTextColor: "black"
    property bool controlTextBold: false

    property color controlProgressTextColor: "black"
    property bool controlProgressTextBold: false

    property color controlProgressGradient0: "transparent"
    property color controlProgressGradient1: "transparent"
    property color controlProgressBackground: "transparent"

    // ---------- existing functions (kept, but using measured widths) ----------
    function calculateWidthBotton(){
        if(bottonType == Style.RoleEnum.BottonType.Progress){
            return parent.width;
        }
        switch(iconType){
        case Style.RoleEnum.IconType.Primary:
            return (((control.myText != "") && (control.textIsVisible))? (control.measuredTextWidth + (control.myIcon != ""? control.measuredPrimaryIconWidth : 0) + 16): control.height);
        case Style.RoleEnum.IconType.Image:
            return (((control.myText != "") && (control.textIsVisible))? (control.measuredTextWidth + (control.myIcon != ""? control.measuredPrimaryIconWidth : 0) + 16): control.height);
        default:
            return (((control.myText != "") && (control.textIsVisible))? (control.measuredTextWidth + (control.myIcon != ""? control.measuredIconWidth : 0) + 16): control.height);
        }
    }
    function calculateHeightText(){
        if(bottonType == Style.RoleEnum.BottonType.Progress){
            return 35;
        }
        switch(iconType){
        case Style.RoleEnum.IconType.Primary:
            return control.measuredPrimaryIconHeight;
        case Style.RoleEnum.IconType.Image:
            return control.measuredPrimaryIconHeight;
        default:
            return control.measuredIconHeight;
        }
    }

    padding: 5

    property string myText: ""
    property string myTextToolTip: ""
    property string myIcon: ""
    property double progressBarValue: 0
    property bool textIsVisible: true
    property bool isNeedAnimation: false
    property int bottonType: Style.RoleEnum.BottonType.Primary
    property int iconType: Style.RoleEnum.IconType.Primary
    property int myRadius: 8

    checkable: false
    checked: false
    property bool selected:  false

    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevice.Mouse
        cursorShape: Qt.PointingHandCursor
    }

    Timer {
        id: resetTimer
        interval: 150
        repeat: false
        onTriggered: {
            if(control.state === "pressed")
                control.state = "hover"
        }
    }

    // ---------- tooltip Loader (kept) ----------
    Loader {
        id: tooltipLoader
        active: control.hovered
                && (control.myTextToolTip !== "")
                && (!control.textIsVisible || control.myText === "")
        sourceComponent: MyToolTip {
            toolTipText: control.myTextToolTip
            visible: control.hovered
        }
    }

    // ---------- background always exists ----------
    background: Rectangle {
        id: backgroundId
        width: parent.width-3; height: parent.height-3
        anchors.centerIn: parent
        radius: control.myRadius
        border.width: 1

        Behavior on width { NumberAnimation { duration: (control.isNeedAnimation && backgroundId.width >= control.width-3)? 200: 0 } }
        Behavior on height { NumberAnimation { duration: (control.isNeedAnimation && backgroundId.height >= control.height-3)? 200: 0 } }

        // ---------- Progress Loader ----------
        Loader {
            id: progressLoader
            anchors.fill: parent
            active: control.bottonType == Style.RoleEnum.BottonType.Progress
            sourceComponent: Item {
                anchors.fill: parent
                clip: true

                Rectangle {
                    id: progressBarId
                    anchors.fill: parent
                    anchors.left: parent.left
                    property color gradientColor0: control.controlProgressGradient0
                    property color gradientColor1: control.controlProgressGradient1
                    property color background: control.controlProgressBackground
                    clip: true
                    radius: 12

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: progressBarId.gradientColor0 }
                        GradientStop { position: control.progressBarValue; color: progressBarId.gradientColor1 }
                        GradientStop { position: Math.min(control.progressBarValue+0.001, 1); color: progressBarId.background }
                        GradientStop { position: 1.0; color: progressBarId.background }
                    }
                }

                Label {
                    id: progressBarTextId
                    height: control.calculateHeightText()
                    property double progressFixedNumber: Number(control.progressBarValue*100).toFixed(2)
                    text: control.hovered ? "Cancel" : "%" + progressFixedNumber
                    font.pixelSize: 12
                    color: control.controlProgressTextColor
                    font.bold: control.controlProgressTextBold
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.centerIn: parent
                }
            }
        }

        // ---------- Normal content Loader (icon + optional primary icon + text) ----------
        Loader {
            id: normalLoader
            anchors.centerIn: parent
            // anchors.left: parent.left
            active: control.bottonType != Style.RoleEnum.BottonType.Progress
            sourceComponent: Row{
                visible: control.bottonType != Style.RoleEnum.BottonType.Progress
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                MyIcon {
                    id: iconId
                    width: 30; height: 30
                    visible: control.myIcon != "" &&  control.iconType != Style.RoleEnum.IconType.Primary
                    myIcon: control.myIcon
                    iconType: control.iconType
                    enabled: false
                    Component.onCompleted: {
                        // update measured icon sizes
                        control.measuredIconWidth = iconId.width
                        control.measuredIconHeight = iconId.height
                    }
                    onWidthChanged: control.measuredIconWidth = iconId.width
                    onHeightChanged: control.measuredIconHeight = iconId.height
                }
                ToolButton {
                    id: primaryIconId
                    visible: control.myIcon != "" && control.iconType == Style.RoleEnum.IconType.Primary
                    background: null
                    width: 30; height: 30
                    icon {
                        source: control.myIcon
                        color: control.controlTextColor
                        width:30; height:30
                    }

                    Component.onCompleted: {
                        control.measuredPrimaryIconWidth = primaryIconId.width
                        control.measuredPrimaryIconHeight = primaryIconId.height
                    }
                    onWidthChanged: control.measuredPrimaryIconWidth = primaryIconId.width
                    onHeightChanged: control.measuredPrimaryIconHeight = primaryIconId.height
                }
                Item{
                    id:textBoxId
                    width: textId.width + ((control.myIcon != "")? 10: 0)
                    height: textId.height
                    visible: (control.myText != "") && (control.textIsVisible)

                    Label {
                        id: textId
                        height: control.calculateHeightText()
                        text: control.myText
                        font.pixelSize: 12
                        color: control.controlTextColor
                        font.bold: control.controlTextBold
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Component.onCompleted: {
                            control.measuredTextWidth = textId.width
                            control.measuredTextHeight = textId.height
                        }
                        onWidthChanged: control.measuredTextWidth = textId.width
                        onHeightChanged: control.measuredTextHeight = textId.height
                    }
                }
            }
        }
    }

    // ---------- convenience boolean properties ----------
    property bool isNormal: !selected && ((!control.checked && control.checkable) || !control.checkable) && !control.hovered && !control.pressed && control.enabled
    property bool isHover: !selected && ((!control.checked && control.checkable) || !control.checkable) && control.hovered && !control.pressed && control.enabled
    property bool isPressed: control.pressed && control.enabled
    property bool isDisabled: !control.enabled
    property bool isSelected: (control.selected || (control.checked && control.checkable)) && control.enabled

    // ---------- STATES: modify backgroundId (always present) and control.* properties ----------
    states: [
        State {
            name: "normal"
            when: control.isNormal
            PropertyChanges {
                target: backgroundId
                color: control.choiceBackgroundColor(bottonType, Style.RoleEnum.State.Normal)
                border.color: control.choiceBorderColor(bottonType, Style.RoleEnum.State.Normal)
                width: control.width-3; height: control.height-3
            }
            PropertyChanges {
                target: control
                controlTextColor: control.choiceTextColor(bottonType, Style.RoleEnum.State.Normal)
                controlTextBold: false

                controlProgressTextColor: control.choiceTextColor(Style.RoleEnum.BottonType.Primary, Style.RoleEnum.State.Normal)
                controlProgressTextBold: false

                controlProgressGradient0: control.choiceBackgroundColorGradient0(bottonType, Style.RoleEnum.State.Normal)
                controlProgressGradient1: control.choiceBackgroundColorGradient1(bottonType, Style.RoleEnum.State.Normal)
                controlProgressBackground: control.choiceBackgroundColor(bottonType, Style.RoleEnum.State.Normal)
            }
        },
        State {
            name: "hover"
            when: control.isHover
            PropertyChanges {
                target: backgroundId
                color: control.choiceBackgroundColor(bottonType, Style.RoleEnum.State.Hover)
                border.color: control.choiceBorderColor(bottonType, Style.RoleEnum.State.Hover)
                width: control.isNeedAnimation? control.width: control.width-3; height: control.isNeedAnimation? control.height: control.height-3
            }
            PropertyChanges {
                target: control
                controlTextColor: control.choiceTextColor(bottonType, Style.RoleEnum.State.Hover)
                controlTextBold: false

                controlProgressTextColor: control.choiceTextColor(Style.RoleEnum.BottonType.Primary, Style.RoleEnum.State.Hover)
                controlProgressTextBold: false

                controlProgressGradient0: control.choiceBackgroundColorGradient0(bottonType, Style.RoleEnum.State.Hover)
                controlProgressGradient1: control.choiceBackgroundColorGradient1(bottonType, Style.RoleEnum.State.Hover)
                controlProgressBackground: control.choiceBackgroundColor(bottonType, Style.RoleEnum.State.Hover)
            }
        },
        State {
            name: "pressed"
            when: control.isPressed
            PropertyChanges {
                target: backgroundId
                color: control.choiceBackgroundColor(bottonType, Style.RoleEnum.State.Pressed)
                border.color: control.choiceBorderColor(bottonType, Style.RoleEnum.State.Pressed)
                width: control.isNeedAnimation? control.width: control.width-3; height: control.isNeedAnimation? control.height: control.height-3
            }
            PropertyChanges {
                target: control
                controlTextColor: control.choiceTextColor(bottonType, Style.RoleEnum.State.Pressed)
                controlTextBold: false

                controlProgressTextColor: control.choiceTextColor(Style.RoleEnum.BottonType.Primary, Style.RoleEnum.State.Pressed)
                controlProgressTextBold: false

                controlProgressGradient0: control.choiceBackgroundColorGradient0(bottonType, Style.RoleEnum.State.Pressed)
                controlProgressGradient1: control.choiceBackgroundColorGradient1(bottonType, Style.RoleEnum.State.Pressed)
                controlProgressBackground: control.choiceBackgroundColor(bottonType, Style.RoleEnum.State.Pressed)
            }
        },
        State {
            name: "selected"
            when: control.isSelected
            PropertyChanges {
                target: backgroundId
                color: control.choiceBackgroundColor(bottonType, Style.RoleEnum.State.Selected)
                border.color: control.choiceBorderColor(bottonType, Style.RoleEnum.State.Selected)
                width: control.isNeedAnimation? control.width: control.width-3; height: control.isNeedAnimation? control.height: control.height-3
            }
            PropertyChanges {
                target: control
                controlTextColor: control.choiceTextColor(bottonType, Style.RoleEnum.State.Selected)
                controlTextBold: true

                controlProgressTextColor: control.choiceTextColor(bottonType, Style.RoleEnum.State.Selected)
                controlProgressTextBold: true

                controlProgressGradient0: control.choiceBackgroundColorGradient0(bottonType, Style.RoleEnum.State.Selected)
                controlProgressGradient1: control.choiceBackgroundColorGradient1(bottonType, Style.RoleEnum.State.Selected)
                controlProgressBackground: control.choiceBackgroundColor(bottonType, Style.RoleEnum.State.Selected)
            }
        },
        State {
            name: "disabled"
            when: control.isDisabled
            PropertyChanges {
                target: backgroundId
                color: control.choiceBackgroundColor(bottonType, Style.RoleEnum.State.Disabled)
                border.color: control.choiceBorderColor(bottonType, Style.RoleEnum.State.Disabled)
                width: control.width-3; height: control.height-3
            }
            PropertyChanges {
                target: control
                controlTextColor: control.choiceTextColor(bottonType, Style.RoleEnum.State.Disabled)
                controlTextBold: false

                controlProgressTextColor: control.choiceTextColor(Style.RoleEnum.BottonType.Primary, Style.RoleEnum.State.Disabled)
                controlProgressTextBold: false

                controlProgressGradient0: control.choiceBackgroundColorGradient0(bottonType, Style.RoleEnum.State.Disabled)
                controlProgressGradient1: control.choiceBackgroundColorGradient1(bottonType, Style.RoleEnum.State.Disabled)
                controlProgressBackground: control.choiceBackgroundColor(bottonType, Style.RoleEnum.State.Disabled)
            }
        }
    ]

    function choiceBackgroundColor(buttonType, state) {
        switch (state) {
                case Style.RoleEnum.State.Normal:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryNormal;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryNormal;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerNormal;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureNormal;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressNormal;
                        default:
                            return Style.Colors.buttonPrimaryNormal;
                    }
                case Style.RoleEnum.State.Hover:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryHover;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryHover;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerHover;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureHover;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressHover;
                        default:
                            return Style.Colors.buttonPrimaryHover;
                    }
                case Style.RoleEnum.State.Pressed:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryPressed;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryPressed;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerPressed;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeaturePressed;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressPressed;
                        default:
                            return Style.Colors.buttonPrimaryPressed;
                    }
                case Style.RoleEnum.State.Disabled:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryDisabled;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryDisabled;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerDisabled;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureDisabled;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressDisabled;
                        default:
                            return Style.Colors.buttonPrimaryDisabled;
                    }
                case Style.RoleEnum.State.Selected:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimarySelected;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondarySelected;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerSelected;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureSelected;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressSelected;
                        default:
                            return Style.Colors.buttonPrimarySelected;
                    }
                default:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryNormal;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryNormal;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerNormal;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureNormal;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressBorderNormal;
                        default:
                            return Style.Colors.buttonPrimaryNormal;
                    }
            }
    }

    function choiceBackgroundColorGradient0(buttonType, state) {
        switch (state) {
                case Style.RoleEnum.State.Normal:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressNormalGradient0;
                        default:
                            return Style.Colors.buttonPrimaryNormal;
                    }
                case Style.RoleEnum.State.Hover:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressHoverGradient0;
                        default:
                            return Style.Colors.buttonPrimaryHover;
                    }
                case Style.RoleEnum.State.Pressed:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressPressedGradient0;
                        default:
                            return Style.Colors.buttonPrimaryPressed;
                    }
                case Style.RoleEnum.State.Disabled:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressDisabledGradient0;
                        default:
                            return Style.Colors.buttonPrimaryDisabled;
                    }
                case Style.RoleEnum.State.Selected:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressSelectedGradient0;
                        default:
                            return Style.Colors.buttonPrimarySelected;
                    }
                default:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressNormalGradient0;
                        default:
                            return Style.Colors.buttonPrimaryNormal;
                    }
            }
    }

    function choiceBackgroundColorGradient1(buttonType, state) {
        switch (state) {
                case Style.RoleEnum.State.Normal:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressNormalGradient1;
                        default:
                            return Style.Colors.buttonPrimaryNormal;
                    }
                case Style.RoleEnum.State.Hover:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressHoverGradient1;
                        default:
                            return Style.Colors.buttonPrimaryHover;
                    }
                case Style.RoleEnum.State.Pressed:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressPressedGradient1;
                        default:
                            return Style.Colors.buttonPrimaryPressed;
                    }
                case Style.RoleEnum.State.Disabled:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressDisabledGradient1;
                        default:
                            return Style.Colors.buttonPrimaryDisabled;
                    }
                case Style.RoleEnum.State.Selected:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressSelectedGradient1;
                        default:
                            return Style.Colors.buttonPrimarySelected;
                    }
                default:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressNormalGradient1;
                        default:
                            return Style.Colors.buttonPrimaryNormal;
                    }
            }
    }

    function choiceTextColor(buttonType, state) {
        switch (state) {
                case Style.RoleEnum.State.Normal:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextNormal;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryTextNormal;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextNormal;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureTextNormal;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressBorderNormal;
                        default:
                            return Style.Colors.buttonPrimaryTextNormal;
                    }
                case Style.RoleEnum.State.Hover:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextHover;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryTextHover;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextHover;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureTextHover;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressBorderNormal;
                        default:
                            return Style.Colors.buttonPrimaryTextHover;
                    }
                case Style.RoleEnum.State.Pressed:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextPressed;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryTextPressed;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextPressed;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureTextPressed;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressBorderNormal;
                        default:
                            return Style.Colors.buttonPrimaryTextPressed;
                    }
                case Style.RoleEnum.State.Disabled:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextDisabled;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryTextDisabled;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextDisabled;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureTextDisabled;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressBorderNormal;
                        default:
                            return Style.Colors.buttonPrimaryTextDisabled;
                    }
                case Style.RoleEnum.State.Selected:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextSelected;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryTextSelected;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextSelected;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureTextSelected;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressBorderNormal;
                        default:
                            return Style.Colors.buttonPrimaryTextSelected;
                    }
                default:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryTextNormal;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryTextNormal;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerTextNormal;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureTextNormal;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressBorderNormal;
                        default:
                            return Style.Colors.buttonPrimaryTextNormal;
                    }
            }
    }

    function choiceBorderColor(buttonType, state) {
        switch (state) {
                case Style.RoleEnum.State.Normal:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryBorderNormal;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryBorderNormal;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerBorderNormal;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureBorderNormal;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressBorderNormal;
                        default:
                            return Style.Colors.buttonPrimaryBorderNormal;
                    }
                case Style.RoleEnum.State.Hover:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryBorderHover;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryBorderHover;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerBorderHover;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureBorderHover;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressBorderNormal;
                        default:
                            return Style.Colors.buttonPrimaryBorderHover;
                    }
                case Style.RoleEnum.State.Pressed:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryBorderPressed;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryBorderPressed;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerBorderPressed;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureBorderPressed;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressBorderNormal;
                        default:
                            return Style.Colors.buttonPrimaryBorderPressed;
                    }
                case Style.RoleEnum.State.Disabled:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryBorderDisabled;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryBorderDisabled;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerBorderDisabled;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureBorderDisabled;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressBorderNormal;
                        default:
                            return Style.Colors.buttonPrimaryBorderDisabled;
                    }
                case Style.RoleEnum.State.Selected:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryBorderSelected;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryBorderSelected;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerBorderSelected;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureBorderSelected;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressBorderNormal;
                        default:
                            return Style.Colors.buttonPrimaryBorderSelected;
                    }
                default:
                    switch(buttonType){
                        case Style.RoleEnum.BottonType.Primary:
                            return Style.Colors.buttonPrimaryBorderNormal;
                        case Style.RoleEnum.BottonType.Secondary:
                            return Style.Colors.buttonSecondaryBorderNormal;
                        case Style.RoleEnum.BottonType.Danger:
                            return Style.Colors.buttonDangerBorderNormal;
                        case Style.RoleEnum.BottonType.Feature:
                            return Style.Colors.buttonFeatureBorderNormal;
                        case Style.RoleEnum.BottonType.Progress:
                            return Style.Colors.buttonProgressBorderNormal;
                        default:
                            return Style.Colors.buttonPrimaryBorderNormal;
                    }
            }
    }
}
