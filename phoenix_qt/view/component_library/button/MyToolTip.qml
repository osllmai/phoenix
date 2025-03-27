import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import '../style' as Style

ToolTip {
    id: toolTip
    visible: infoMouseArea.containsMouse
    width: 400
    delay: 2000
    timeout: 5000

    property string toolTipText

    contentItem: Label {
        id: toolTipId
        width: toolTip.width
        text: toolTip.toolTipText
        wrapMode: Text.Wrap
        color: Style.Colors.toolTipText
        font.pixelSize: 10
    }

    background: Rectangle {
        width: toolTipId.width + 20
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
