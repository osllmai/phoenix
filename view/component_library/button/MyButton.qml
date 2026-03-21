import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import '../style' as Style
import "MyButtonStyle.js" as BStyle

T.Button {
    id: control
    width: calculateWidthBotton()+6; height: 35
    Component.onCompleted: BStyle.init(Style.Colors)

    // ---------- measurements used instead of direct ids ----------
    property real measuredTextWidth: 0
    property real measuredTextHeight: 0
    property real measuredPrimaryIconWidth: 0
    property real measuredPrimaryIconHeight: 0
    property real measuredIconWidth: 0
    property real measuredIconHeight: 0

    // ---------- visual state properties (driven by _st bindings below) ----------
    property color controlTextColor
    property bool controlTextBold
    property color controlProgressTextColor
    property bool controlProgressTextBold
    property color controlProgressGradient0
    property color controlProgressGradient1
    property color controlProgressBackground

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

    // ---------- tooltip Loader ----------
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

    // ---------- background ----------
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

    // ---------- computed current visual state ----------
    readonly property int _st: {
        if (!enabled) return Style.RoleEnum.State.Disabled
        if (selected || (checked && checkable)) return Style.RoleEnum.State.Selected
        if (pressed) return Style.RoleEnum.State.Pressed
        if (hovered) return Style.RoleEnum.State.Hover
        return Style.RoleEnum.State.Normal
    }
    readonly property bool _isAnimated: isNeedAnimation && (_st === Style.RoleEnum.State.Hover || _st === Style.RoleEnum.State.Pressed || _st === Style.RoleEnum.State.Selected)
    readonly property bool _isBold: _st === Style.RoleEnum.State.Selected
    readonly property int _progressTextBt: _isBold ? bottonType : Style.RoleEnum.BottonType.Primary

    // ---------- bind background via computed state ----------
    Binding { target: backgroundId; property: "color";         value: BStyle.choiceBackgroundColor(bottonType, _st) }
    Binding { target: backgroundId; property: "border.color";  value: BStyle.choiceBorderColor(bottonType, _st) }
    Binding { target: backgroundId; property: "width";         value: _isAnimated ? control.width : control.width-3 }
    Binding { target: backgroundId; property: "height";        value: _isAnimated ? control.height : control.height-3 }

    controlTextColor:           BStyle.choiceTextColor(bottonType, _st)
    controlTextBold:            _isBold
    controlProgressTextColor:   BStyle.choiceTextColor(_progressTextBt, _st)
    controlProgressTextBold:    _isBold
    controlProgressGradient0:   BStyle.choiceBackgroundColorGradient0(bottonType, _st)
    controlProgressGradient1:   BStyle.choiceBackgroundColorGradient1(bottonType, _st)
    controlProgressBackground:  BStyle.choiceBackgroundColor(bottonType, _st)
}
