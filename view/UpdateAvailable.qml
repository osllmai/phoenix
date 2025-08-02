import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import './component_library/style' as Style
import './component_library/button'

Rectangle{
    id: backgroundId
    width: 300
    height: 150
    property int visibleX: parent.width - backgroundId.width - 20
    property int hiddenX: parent.width
    property bool isHiding: false

    x: hiddenX   // start off screen
    visible: false
    y: parent.height - backgroundId.height - 45
    radius: 10
    border.width: 1
    border.color: Style.Colors.boxBorder
    color: Style.Colors.background
    z: 200

    NumberAnimation {
        id: hideAnim
        target: backgroundId
        property: "x"
        to: hiddenX
        duration: 300
        easing.type: Easing.InCubic
        onFinished: {
            backgroundId.visible = false
            isHiding = false
        }
    }

    Behavior on x {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    function showAnimated() {
        backgroundId.visible = true
        backgroundId.x = visibleX
    }

    function hideAnimated() {
        isHiding = true
        hideAnim.start()
    }

    onVisibleChanged: {
        if (visible && !isHiding) {
            x = visibleX
        }
    }

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
                text: "New Update Available"
                color: Style.Colors.textTitle
                font.pixelSize: 14
                font.styleName: "Bold"
                anchors.verticalCenter: closeBox.verticalCenter
            }
            MyIcon{
                id: closeBox
                width: 30; height: 30
                myIcon: "qrc:/media/icon/close.svg"
                myTextToolTip: "Close"
                isNeedAnimation: true
                onClicked: backgroundId.hideAnimated()
            }
        }
        Label {
            id: informationId
            text: "A newer version of Phoenix is available. Would you like to download and install the update now?"
            color: Style.Colors.textInformation
            clip: true
            width: parent.width
            height: parent.height - buttonBoxId.height - titleBoxId.height - 20
            font.pixelSize: 12
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
        }

        Row{
            id: buttonBoxId
            spacing: 5
            anchors.right: parent.right

            MyButton {
                id: botton1
                myText: "Not Now"
                bottonType: Style.RoleEnum.BottonType.Secondary
                onClicked: backgroundId.hideAnimated()
            }

            MyButton {
                id: botton2
                myText: "Download Update"
                bottonType: Style.RoleEnum.BottonType.Primary
                onClicked: {
                    updateChecker.checkForUpdates()
                    backgroundId.hideAnimated()
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
