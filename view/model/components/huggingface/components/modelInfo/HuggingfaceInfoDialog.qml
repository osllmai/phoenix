import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import "../../../../../component_library/style" as Style
import "../../../../../component_library/button"
import "./components"

Dialog {
    id: settingsDialogId
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: Math.min(550, parent.width - 40)
    height: Math.min(450, parent.height - 40)

    property bool isDesktopSize: width >= 630
    onIsDesktopSizeChanged: {
        settingsDialogId.close()
        if (settingsDialogId.isDesktopSize) {
            settingsDialogId.isOpenMenu = true
        }
    }

    property bool isOpenMenu: true
    onIsOpenMenuChanged: {
        if (settingsDialogId.isOpenMenu) {
            if (settingsDialogId.isDesktopSize) {
                settingsMenuId.width = 200
            } else {
                settingsDialogId.open()
            }
        } else {
            if (settingsDialogId.isDesktopSize) {
                settingsMenuId.width = 60
            } else {
                settingsDialogId.open()
            }
        }
    }

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
    contentItem: Rectangle {
        id: backgroundId
        anchors.fill: parent
        radius: 10
        border.width: 1
        border.color: Style.Colors.boxBorder
        color: Style.Colors.background

        Loader {
            id: contentLoader
            anchors.fill: parent
            anchors.margins: 20
            active: true
            sourceComponent: {
                if (huggingfaceModelList.hugginfaceInfo) {
                    if (huggingfaceModelList.hugginfaceInfo.successModelProcess)
                        return successComponent
                    else if (huggingfaceModelList.hugginfaceInfo.loadModelProcess)
                        return loadingComponent
                    else
                        return failComponent
                }
                return null
            }
        }

        // ===== Components =====
        Component {
            id: successComponent
            HugginfaceDialogView {
                anchors.fill: parent
                anchors.margins: 24
            }
        }

        Component {
            id: failComponent
            Item {
                anchors.fill: parent
                Label {
                    text: "connectionFail"
                    color: Style.Colors.textInformation
                    font.pixelSize: 50
                    font.italic: true
                    anchors.centerIn: parent
                }
            }
        }

        Component {
            id: loadingComponent
            Item {
                anchors.fill: parent
                Loader {
                    anchors.centerIn: parent
                    active: true
                    sourceComponent: BusyIndicator {
                        running: true
                        width: 60
                        height: 60

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
                                    ctx.strokeStyle = Style.Colors.iconPrimaryHoverAndChecked
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
        }

        layer.enabled: true
        layer.effect: Glow {
            samples: 40
            color: Style.Colors.boxBorder
            spread: 0.1
            transparentBorder: true
        }
    }
}
