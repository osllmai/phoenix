import QtQuick 2.15
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import '../style' as Style

Dialog {
    id: dialogId
    x: (window.width - width) / 2
    y: (window.height - height) / 2
    width: 300
    height: 180

    property var titleText
    property var about

    signal buttonAction1()
    signal buttonAction2()

    property var textBotton1
    property var textBotton2

    property int typeBotton1: Style.RoleEnum.BottonType.Secondary
    property int typeBotton2: Style.RoleEnum.BottonType.Danger

    property int locationText: Text.AlignHCenter

    focus: true
    modal: true

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        width: window.width
        height: window.height - 40
        y: 40
        color: Style.Colors.overlayDrawer
    }

    background: null
    contentItem:Rectangle{
        id: backgroundId
        anchors.fill: parent
        radius: 10
        border.width: 1
        border.color: Style.Colors.boxBorder
        color: Style.Colors.background

        Column{
            anchors.fill: parent
            anchors.margins: 16
            spacing: 10
            Row{
                id: titleBoxId
                height: 35
                spacing: parent.width - titleId.width - closeBox.width
                Label {
                    id: titleId
                    text: dialogId.titleText
                    color: Style.Colors.textTitle
                    font.pixelSize: 20
                    font.styleName: "Bold"
                    anchors.verticalCenter: closeBox.verticalCenter
                }
                MyIcon{
                    id: closeBox
                    width: 30; height: 30
                    myIcon: "qrc:/media/icon/close.svg"
                    myTextToolTip: "Close"
                    isNeedAnimation: true
                    onClicked: dialogId.close()
                }
            }
            Label {
                id: informationId
                text: dialogId.about
                color: Style.Colors.textInformation
                clip: true
                width: parent.width
                height: parent.height - buttonBoxId.height - titleBoxId.height - 20
                font.pixelSize: 14
                horizontalAlignment: dialogId.locationText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }
            Row{
                id: buttonBoxId
                spacing: 5
                anchors.right: parent.right

                MyButton{
                    id: botton1
                    myText: dialogId.textBotton1
                    bottonType: dialogId.typeBotton1
                    onClicked:{
                       buttonAction1()
                    }
                }
                MyButton{
                    id: botton2
                    myText: dialogId.textBotton2
                    bottonType: dialogId.typeBotton2
                    onClicked:{
                        buttonAction2()
                    }
                }
            }
        }
        layer.enabled: true
        layer.effect: Glow {
             samples: 40
             color:  Style.Colors.boxBorder
             spread: 0.1
             transparentBorder: true
         }
    }
}
