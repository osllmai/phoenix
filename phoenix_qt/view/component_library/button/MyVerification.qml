import QtQuick 2.15
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects

Dialog {
    id: notificationDialog
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: 250
    height: 200

    property var title
    property var about

    signal bottonAction1()
    signal bottonAction2()

    property var textBotton1
    property var textBotton2

    focus: true
    modal: true

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        color: Style.Theme.colorOverlay
    }

    background:Rectangle{
        id: modelSettings
        anchors.fill:  parent
        border.color: Style.Theme.backgroungColor
        radius:4
        visible: true

        gradient: Gradient {
            GradientStop {
                position: 0
                color: Style.Theme.backgroundPageColor
            }
            GradientStop {
                position: 1
                color: Style.Theme.backgroungColor
            }
            orientation: Gradient.Vertical
        }

        Text {
            id: titleId
            color: Style.Theme.titleTextColor
            text: control.title
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.topMargin: 20
            font.pixelSize: control.titleFontSize
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.styleName: "Bold"
            font.family: Style.Theme.fontFamily
        }

        Text{
            id:informationId
            text: control.about
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: titleId.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.topMargin: 20
            anchors.bottomMargin: 20 + bottonId1.height
            font.pixelSize: control.informationFontSize
            horizontalAlignment: Text.AlignJustify
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
            font.family: Style.Theme.fontFamily
            color: Style.Theme.informationTextColor
        }

        MyButton{
            id: bottonId1
            width: (parent.width-50)/2
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            Connections {
                target: bottonId1
                function onClicked(){
                    control.bottonAction1()
                }
            }
        }
        MyButton{
            id:bottonId2
            width: (parent.width-50)/2
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 20
            anchors.bottomMargin: 20
            Connections {
                target: bottonId2
                function onClicked(){
                    control.bottonAction2()
                }
            }
        }
    }
}
