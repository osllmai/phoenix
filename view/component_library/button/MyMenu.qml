import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls.Basic

import "../../component_library/style" as Style

T.Button {
    id: control
    height: control.rowView? 35: 70

    property int iconImplicitWidth: 0
    property int textImplicitWidth: 0

    width: (control.myText !== "" ? control.textImplicitWidth : 0)
         + ((control.myIcon !== "" && control.rowView) ? control.iconImplicitWidth : 10)
         + 20

    leftPadding: 4; rightPadding: 4
    autoExclusive: false
    checkable: true

    property string myText: ""
    property string myIcon: ""
    property int iconType: Style.RoleEnum.IconType.Primary
    property bool rowView: true

    property color backgroundColor: Style.Colors.buttonFeatureNormal
    property color borderColor: Style.Colors.buttonFeatureBorderNormal
    property color textColor: Style.Colors.buttonFeatureTextNormal
    property bool fontBold: false

    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevice.Mouse
        cursorShape: Qt.PointingHandCursor
    }

    background: null

    contentItem: Rectangle {
        id: backgroundId
        width: parent.width - 3
        height: parent.height - 3
        anchors.centerIn: parent
        color: control.backgroundColor
        border.width: 1
        border.color: control.borderColor
        radius: 12
        clip: true

        Loader {
            id: contentLoader
            anchors.centerIn: parent
            sourceComponent: control.rowView ? rowComponent : columnComponent
        }
    }

    Component {
        id: rowComponent
        Row {
            spacing: 4
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            MyIcon {
                id: iconId
                width: 30; height: 30
                visible: control.myIcon !== ""
                myIcon: control.myIcon
                iconType: control.iconType
                enabled: false
                Component.onCompleted: control.iconImplicitWidth = width
                onWidthChanged: control.iconImplicitWidth = width
                anchors.verticalCenter: parent.verticalCenter
            }
            Label {
                id: textId
                text: control.myText
                color: control.textColor
                font.pixelSize: 12
                font.bold: control.fontBold
                anchors.verticalCenter: control.myIcon !== ""? iconId.verticalCenter: parent.verticalCenter
                visible: control.width>60 || (control.myIcon === "")
                clip: true
                Component.onCompleted: control.textImplicitWidth = implicitWidth
                onImplicitWidthChanged: control.textImplicitWidth = implicitWidth
            }
        }
    }

    Component {
        id: columnComponent
        Column {
            spacing: 2
            anchors.centerIn: parent
            MyIcon {
                id: iconId
                width: 35; height: 35
                visible: control.myIcon !== ""
                myIcon: control.myIcon
                iconType: control.iconType
                enabled: false
                Component.onCompleted: control.iconImplicitWidth = width
                onWidthChanged: control.iconImplicitWidth = width
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                id: textId
                text: control.myText
                color: control.textColor
                font.pixelSize: 12
                font.bold: control.fontBold
                // visible: control.width > 60 || (control.myIcon === "")
                Component.onCompleted: control.textImplicitWidth = implicitWidth
                onImplicitWidthChanged: control.textImplicitWidth = implicitWidth
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    property bool isNormal: !control.hovered && !control.pressed && !control.enabled
    property bool isHover: control.hovered && !control.pressed && !control.checked
    property bool isPressed: control.pressed && !control.checked
    property bool isChecked: control.checked

    states: [
        State {
            name: "normal"
            when: control.isNormal
            PropertyChanges {
                target: control
                backgroundColor: Style.Colors.buttonFeatureNormal
                borderColor: Style.Colors.buttonFeatureBorderNormal
                textColor: Style.Colors.buttonFeatureTextNormal
                fontBold: false
            }
        },
        State {
            name: "hover"
            when: control.isHover
            PropertyChanges {
                target: control
                backgroundColor: Style.Colors.buttonFeatureHover
                borderColor: Style.Colors.buttonFeatureBorderHover
                textColor: Style.Colors.buttonFeatureTextHover
                fontBold: false
            }
        },
        State {
            name: "pressed"
            when: control.isPressed
            PropertyChanges {
                target: control
                backgroundColor: Style.Colors.buttonFeatureHover
                borderColor: Style.Colors.buttonFeatureBorderPressed
                textColor: Style.Colors.buttonFeatureTextHover
                fontBold: false
            }
        },
        State {
            name: "checked"
            when: control.isChecked
            PropertyChanges {
                target: control
                backgroundColor: control.pressed ? Style.Colors.buttonFeatureBorderPressed : Style.Colors.buttonFeatureSelected
                borderColor: Style.Colors.buttonFeatureBorderSelected
                textColor: Style.Colors.buttonFeatureTextHover
                fontBold: true
            }
        }
    ]
}
