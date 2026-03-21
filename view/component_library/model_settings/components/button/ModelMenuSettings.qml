import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import QtQuick.Templates 2.1 as T

import '../../../style' as Style
import '../../../button'
import "../../../button/MyButtonStyle.js" as BStyle

 T.Button{
    id: control
    width: parent.width; height: 35
    Component.onCompleted: BStyle.init(Style.Colors)

    property var myText
    property bool isOpen

    property bool isNeedAnimation: false
    property int bottonType: Style.RoleEnum.BottonType.Feature
    property int iconType: Style.RoleEnum.IconType.FeatureBlue

    function selectIcon(){
        if(isOpen){
            return "qrc:/media/icon/up.svg";
        }else{
            return "qrc:/media/icon/down.svg";
        }
    }

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

    background: Rectangle{
        id: backgroundId
        width: parent.width; height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        radius: 8
        border.width: control.isOpen?1:0
        Row{
            anchors.fill: parent
            leftPadding: 10
            Label {
                id: textId
                width: parent.width - iconOpenId.width - 10 ; height: parent.height
                text: control.myText
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 10
                color: Style.Colors.textTitle

            }
            MyIcon {
                id: iconOpenId
                myIcon: control.selectIcon()
                iconType: Style.RoleEnum.IconType.Primary
                enabled: false
            }
        }
        Rectangle{
            visible: !control.isOpen
            height: 1; width: parent.width
            anchors.bottom: parent.bottom
            color: Style.Colors.boxBorder
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

    Binding { target: backgroundId; property: "color";         value: BStyle.choiceBackgroundColor(bottonType, _st) }
    Binding { target: backgroundId; property: "border.color";  value: BStyle.choiceBorderColor(bottonType, _st) }
    Binding { target: backgroundId; property: "width";         value: _isAnimated ? control.width : control.width-3 }
    Binding { target: backgroundId; property: "height";        value: _isAnimated ? control.height : control.height-3 }
    Binding { target: textId;       property: "color";         value: _st === Style.RoleEnum.State.Selected ? BStyle.choiceTextColor(bottonType, _st) : BStyle.choiceTextColor(bottonType, Style.RoleEnum.State.Normal) }
}
