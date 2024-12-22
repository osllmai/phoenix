import QtQuick 6.7
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects

Item{
    id: control
    // width: 250
    // height: 200
    // x: -50
    // y: -80
    // closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    function open(){
        notificationDialog.open()
    }
    function close(){
        notificationDialog.close()
    }

    property color backgroundPageColor
    property color backgroungColor
    property color glowColor
    property color boxColor
    property color headerColor
    property color normalButtonColor
    property color selectButtonColor
    property color hoverButtonColor
    property color fillIconColor

    property color titleTextColor
    property color informationTextColor
    property color selectTextColor

    property var fontFamily

    property int titleFontSize: 14
    property int informationFontSize: 12

    signal bottonAction1()
    signal bottonAction2()

    property var title
    property var about
    property var textBotton1
    property var textBotton2

    Dialog {
        id: notificationDialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 250
        height: 200

        parent: Overlay.overlay

        focus: true
        modal: true


        background:Rectangle{
            id: modelSettings
            anchors.fill:  parent
            border.color: control.backgroungColor
            radius:4
            visible: true

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: control.backgroundPageColor
                }
                GradientStop {
                    position: 1
                    color: control.backgroungColor
                }
                orientation: Gradient.Vertical
            }

            Text {
                id: titleId
                color: control.titleTextColor
                text: control.title
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.topMargin: 20
                font.pixelSize: control.titleFontSize
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.styleName: "Bold"
                font.family: control.fontFamily
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
                font.family: control.fontFamily
                color: control.informationTextColor
            }

            MyButton{
                id: bottonId1
                width: (parent.width-50)/2
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 20
                anchors.bottomMargin: 20
                myTextId: control.textBotton1
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
                myTextId: control.textBotton2
                Connections {
                    target: bottonId2
                    function onClicked(){
                        console.log("hi")
                        control.bottonAction2()
                    }
                }
            }
            layer.enabled: true
            layer.effect: Glow {
                 samples: 40
                 color: control.glowColor
                 spread: 0.4
                 transparentBorder: true
             }
        }
    }

}
