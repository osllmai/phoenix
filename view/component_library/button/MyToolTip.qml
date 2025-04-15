import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import '../style' as Style

ToolTip {
    id: toolTip
    visible: infoMouseArea.containsMouse
    width: 300
    delay: 2000
    timeout: 5000

    property string toolTipText
    property bool toolTipInCenter: false

    contentItem: Label {
        id: toolTipId
        text: toolTip.toolTipText
        wrapMode: Text.Wrap
        color: Style.Colors.toolTipText
        font.pixelSize: 10
        horizontalAlignment: toolTip.toolTipInCenter? Text.AlignHCenter: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        width: Math.min(toolTip.width, toolTipId.width+10)
        height: toolTipId.height + 10
        color: Style.Colors.toolTipBackground
        border.color: Style.Colors.toolTipGlowAndBorder
        radius: 4
        layer.enabled: true
        layer.effect: Glow {
            samples: 30
            color: Style.Colors.toolTipGlowAndBorder
            spread: 0.4
            transparentBorder: true
        }
    }
}
