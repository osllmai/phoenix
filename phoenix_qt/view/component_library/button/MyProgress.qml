import QtQuick 2.15
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import '../style' as Style

Rectangle {
    id: control
    height: 30
    width: cpuText.width + progressBarCPU.width + progressBarTextCPU.width + 10 + 6
    property var myText
    property double myValue
    property int textLenght: 45

    Row{
        anchors.centerIn: parent
        anchors.margins: 3
        spacing: 5

        Text {
            id: cpuText
            text: control.myText
            width: control.textLenght
            color: Style.Colors.progressBarText
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 9
        }
        ProgressBar {
            id: progressBarCPU
            width: 100
            height: 6
            value: control.myValue
            anchors.verticalCenter: parent.verticalCenter
            background: Rectangle {
                color: Style.Colors.progressBarBackground
                implicitHeight: 6
                radius: 2
            }

            contentItem: Item {
                implicitHeight: 6
                Rectangle {
                    width: progressBarCPU.visualPosition * parent.width
                    height: 6
                    radius: 2
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: Style.Colors.progressBarGradient0 }
                        GradientStop { position: 1.0; color: Style.Colors.progressBarGradient1 }
                    }
                    Behavior on width{ NumberAnimation{ duration: 200}}
                }
            }
        }
        Text {
            id: progressBarTextCPU
            text: "% " + Number(control.myValue * 100).toFixed(2)
            color: Style.Colors.progressBarText
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 9
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
