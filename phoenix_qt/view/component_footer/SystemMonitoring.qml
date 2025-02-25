import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import '../component_library/style' as Style
import '../component_library/button'

T.Popup {
    id: systemMonitorPupup
    width: 220
    height: 80

    background: Rectangle{
        id:systemMonitorRec
        anchors.fill: parent
        color: Style.Colors.boxNormalGradient0
        radius: 4
        border.color: Style.Colors.boxBorder
        border.width: 1

        Column{
            anchors.centerIn: parent

            MyProgress{
                myText: "CPU"
                myValue: systemMonitor.cpuInfo/10000
            }
            MyProgress{
                myText: "Memory"
                myValue: systemMonitor.memoryInfo/10000
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
