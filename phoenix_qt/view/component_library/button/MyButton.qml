import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import '../style' as Style

T.Button {
    id: control
    width: calculateWidthBotton()+3; height: 35

    function calculateWidthBotton(){
        switch(iconType){
        case Style.RoleEnum.IconType.Primary:
            return (textBoxId.visible? (textId.width + primaryIconId.width + 16): control.height);
        case Style.RoleEnum.IconType.Image:
            return (textBoxId.visible? (textId.width + imageIconId.width + 16): control.height);
        default:
            return (textBoxId.visible? (textId.width + iconId.width + 16): control.height);
        }
    }
    function calculateHeightText(){
        switch(iconType){
        case Style.RoleEnum.IconType.Primary:
            return primaryIconId.height;
        case Style.RoleEnum.IconType.Image:
            return imageIconId.height;
        default:
            return iconId.height;
        }
    }

    padding: 5

    property var myText: ""
    property var myIcon: ""
    property bool textIsVisible: true
    property bool isNeedAnimation: false
    property int bottonType: Style.RoleEnum.BottonType.Primary
    property int iconType: Style.RoleEnum.IconType.Primary

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
            if(control.state == "pressed")
                control.state = "hover"
        }
    }
    background: Rectangle{
        id: backgroundId
        width: parent.width-3; height: parent.height-3
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        radius: 12
        border.width: 1

        Behavior on width{ NumberAnimation{ duration: (control.isNeedAnimation && backgroundId.width >= control.width-3)? 200: 0}}
        Behavior on height{ NumberAnimation{ duration: (control.isNeedAnimation && backgroundId.height >= control.height-3)? 200: 0}}

        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            Image {
                id: imageIconId
                visible: control.myIcon != "" && control.iconType == Style.RoleEnum.IconType.Image
                source: control.myIcon
            }
            MyIcon {
                id: iconId
                width: 30; height: 30
                visible: control.myIcon != "" && control.iconType != Style.RoleEnum.IconType.Image && control.iconType != Style.RoleEnum.IconType.Primary
                myIcon: control.myIcon
                iconType: control.iconType
                enabled: false
            }
            ToolButton {
                id: primaryIconId
                visible: control.myIcon != "" && control.iconType == Style.RoleEnum.IconType.Primary
                background: null
                icon{
                    source: control.myIcon
                    color: textId.color
                    width:18; height:18
                }
            }
            Item{
                id:textBoxId
                width: textId.width + ((control.myIcon != "")? 10: 0)
                height: textId.height
                visible: (control.myText != "") && (control.textIsVisible)
                Text {
                    id: textId
                    height: control.calculateHeightText()
                    text: control.myText
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

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
                        default:
                            return Style.Colors.buttonPrimaryBorderNormal;
                    }
            }
    }

    property bool isNormal: !control.hovered && !control.pressed && control.enabled
    property bool isHover: control.hovered && !control.pressed && control.enabled
    property bool isPressed: control.pressed && control.enabled
    property bool isDisabled: !control.enabled

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
                target: textId
                color: control.choiceTextColor(bottonType, Style.RoleEnum.State.Normal)
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
                target: textId
                color: control.choiceTextColor(bottonType, Style.RoleEnum.State.Normal)
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
                target: textId
                color: control.choiceTextColor(bottonType, Style.RoleEnum.State.Normal)
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
                target: textId
                color: control.choiceTextColor(bottonType, Style.RoleEnum.State.Normal)
            }
        }
    ]
}
