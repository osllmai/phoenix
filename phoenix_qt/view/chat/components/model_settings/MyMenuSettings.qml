import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import '../../../component_library/style' as Style

T.Button {
    id: control
    width: (parent.width-10)/2; height: 30
    property var myText

    autoExclusive: false
    checkable: true
    signal actionClicked()

    background: Rectangle{
        id: backgroundId
        anchors.fill: parent
        color: Style.Colors.menu
        Text {
            id: textId
            color: Style.Colors.menuNormalIcon
            text: control.myText
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 12
            font.styleName: "Bold"
        }
    }

    states: [
        State {
            name: "normal"
            when: !control.pressed && !control.checked &&!control.hovered

            PropertyChanges {
                target: textId
                color: Style.Colors.menuNormalIcon
            }
            PropertyChanges {
                target: backgroundId
                color: "#00ffffff"
            }
        },
        State {
            name: "hover"
            when: control.hovered && !control.checked && !control.pressed

            PropertyChanges {
                target: textId
                color: Style.Colors.menuHoverAndCheckedIcon
            }
            PropertyChanges {
                target: backgroundId
                color: Style.Colors.menu
            }
        },
        State {
            name: "checked"
            when: control.checked

            PropertyChanges {
                target: textId
                color: Style.Colors.menuHoverAndCheckedIcon
            }
            PropertyChanges {
                target: backgroundId
                color: Style.Colors.menu
            }
        }
    ]
}
