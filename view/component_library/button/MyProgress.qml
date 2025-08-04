import QtQuick 2.15
import QtQuick.Controls.Basic
import QtQuick.Templates 2.1 as T
import Qt5Compat.GraphicalEffects
import '../style' as Style

T.Button  {
    id: control
    height: 30
    width: (control.myIcon ==""?0:iconId.width+5) + (cpuText.visible? cpuText.width: 0) + progressBarCPU.width + progressBarTextCPU.width + 10 + 6

    property string myText: ""
    property double myValue: 0.0
    property string myIcon: ""
    property int textLenght: 45
    property int iconType: Style.RoleEnum.IconType.Primary
    enabled: false

    background: null
    Row{
        anchors.centerIn: parent
        anchors.margins: 3
        spacing: 5

        MyIcon {
            id: iconId
            width: 30; height: 30
            visible: control.myIcon != ""
            myIcon: control.myIcon
            iconType: control.iconType
            enabled: false
        }
        Label {
            id: cpuText
            visible: (myText !== "")?true:false
            text: control.myText
            width: control.textLenght
            color: Style.Colors.progressBarText
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 9
            clip: true
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
                    Behavior on width{ NumberAnimation{ duration: 900}}
                }
            }
        }
        Label {
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
