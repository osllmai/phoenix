import QtQuick 2.15
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 6.6
import '../../../../component_library/style' as Style
import '../../../../component_library/button'

Item {
    id: logoModelId
    width: 50; height: 50

    Loader{
        anchors.centerIn: parent
        active: model.icon !== "qrc:/media/image_company/user.svg"
        sourceComponent: MyIcon {
            anchors.centerIn: parent
            myIcon: model.icon
            iconType: Style.RoleEnum.IconType.Image
            enabled: false
            width: 35; height: 35
        }
    }

    Loader{
        anchors.centerIn: parent
        active: model.icon === "qrc:/media/image_company/user.svg"
        sourceComponent: ToolButton {
            anchors.centerIn: parent
            width: 35; height: 35
            background: null
            icon{
                source: model.icon
                color: Style.Colors.menuHoverAndCheckedIcon
                width:24; height:24
            }
        }
    }

    Loader {
        id: busyLoader
        anchors.centerIn: parent
        active: control.generateProcess
        sourceComponent: BusyIndicator {
            running: true
            width: 50; height: 50

            contentItem: Item {
                implicitWidth: 50
                implicitHeight: 50

                Canvas {
                    id: spinnerCanvas
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.beginPath()
                        ctx.arc(width / 2, height / 2, width / 2 - 2, 0, Math.PI * 1.5)
                        ctx.lineWidth = 2
                        ctx.strokeStyle = Style.Colors.iconPrimaryHoverAndChecked;
                        ctx.stroke()
                    }
                    Component.onCompleted: requestPaint()
                }

                RotationAnimator on rotation {
                    from: 0
                    to: 360
                    duration: 1000
                    loops: Animation.Infinite
                    running: true
                }
            }
        }
    }
}
