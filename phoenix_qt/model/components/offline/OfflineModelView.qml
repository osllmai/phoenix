import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import '../../../component_library/style' as Style

Item {
    OfflineHeader{
        id: headerId
        width: parent.width; height: 80
    }
    OfflineList{
        id:appBodyId
        anchors.top: headerId.bottom; anchors.bottom: parent.bottom
        anchors.left: parent.left; anchors.right: parent.right
        clip:true
    }
    ToolButton {
        id: iconButtonId
        anchors.right: parent.right; anchors.rightMargin: 75 - (iconButtonId.width/2)
        anchors.bottom: parent.bottom; anchors.bottomMargin: 55 - (iconButtonId.height/2)
        width:iconButtonId.hovered? 55: 50; height: iconButtonId.hovered? 55: 50
        Behavior on width{ NumberAnimation{ duration: 150}}
        Behavior on height{ NumberAnimation{ duration: 150}}
        background: Rectangle {
            radius: 50
            color: iconButtonId.hovered? Style.Colors.buttonPrimaryHover: Style.Colors.buttonPrimaryNormal
            layer.enabled: true
            layer.effect: Glow {
                 samples: 60
                 color:  Style.Colors.boxBorder
                 spread: 0.3
                 transparentBorder: true
             }
        }
        icon{
            source: "../../../media/icon/add.svg"
            color: "white"
            width: iconButtonId.width ; height: iconButtonId.height
        }
    }
}
