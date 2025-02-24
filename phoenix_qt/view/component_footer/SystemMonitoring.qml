import QtQuick 2.15
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import '../component_library/style' as Style

T.Popup {
    id: systemMonitorPupup
    width: 180
    height: 70

    background:Rectangle{
        color: "white"
        radius: 4
        anchors.fill: parent

        Rectangle{
            id:systemMonitorRec
            anchors.fill: parent
            color: "#ffffff"
            radius: 4
            border.color: "#cbcbcb"

            Rectangle {
                id: cpuRec
                height: 30
                color: "#00ffffff"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 7
                anchors.topMargin: 2

                Text {
                    id: cpuText
                    text: qsTr("CPU")
                    width: memoryText.width
                    color: "black"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    font.pointSize: 9
                }
                ProgressBar {
                    id: progressBarCPU
                    width: 100
                    height: 6
                    value: /*phoenixController.cpuInfo/100*/0.6
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: cpuText.right
                    anchors.leftMargin: 5
                    background: Rectangle {
                        color: "#c0c0c0"
                        implicitHeight: 6
                        radius: 2
                        border.color: "#c0c0c0"
                        border.width: 2
                    }

                    contentItem: Item {
                        implicitHeight: 6
                        Rectangle {
                            width: progressBarCPU.visualPosition * parent.width
                            height: 6
                            radius: 2
                            color: "#047eff"
                            border.color: "#047eff"
                            border.width: 2
                        }
                    }
                }
                Text {
                    id: progressBarTextCPU
                    text: "% 60" /*+ phoenixController.cpuInfo*/
                    color: "black"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: progressBarCPU.right
                    anchors.leftMargin: 5
                    font.pixelSize: 9
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Rectangle {
                id: memoryRec
                height: 30
                color: "#00ffffff"
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 7
                anchors.bottomMargin: 2

                Text {
                    id: memoryText
                    text: qsTr("Memory")
                    color: "black"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    font.pointSize: 9
                }
                ProgressBar {
                    id: progressBarMemory
                    width: 100
                    height: 6
                    value: /*phoenixController.memoryInfo /100*/ 0.5
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: memoryText.right
                    anchors.leftMargin: 5
                    background: Rectangle {
                        color: "#c0c0c0"
                        implicitHeight: 6
                        radius: 2
                        border.color: "#c0c0c0"
                        border.width: 2
                    }

                    contentItem: Item {
                        implicitHeight: 6
                        Rectangle {
                            width: progressBarMemory.visualPosition * parent.width
                            height: 6
                            radius: 2
                            color: "#047eff"
                            border.color: "#047eff"
                            border.width: 2
                        }
                    }
                }
                Text {
                    id: progressBarTextMemory
                    text: "% 90" /*+ phoenixController.memoryInfo*/
                    color: "black"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: progressBarMemory.right
                    anchors.leftMargin: 5
                    font.pixelSize: 9
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            layer.enabled: true
            layer.effect: Glow {
                 samples: 30
                 color: "#cbcbcb"
                 spread: 0.3
                 transparentBorder: true
             }
        }
    }
}
