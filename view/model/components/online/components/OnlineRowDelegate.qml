import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Layouts
import '../../../../component_library/style' as Style
import "../../../../component_library/button"
import "./components"

T.Button {
    id: control
    width: 250
    height: 250

    background:null

    contentItem:Rectangle{
        id: backgroundId
        anchors.fill: parent
        radius: 10
        border.width: 1
        border.color: Style.Colors.boxBorder
        color: Style.Colors.boxHover

        Row{
            id: headerId
            visible: window.isDesktopSize
            width: 220
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            MyIcon {
                id: logoModelId
                myIcon: "qrc:/media/image_company/" + model.icon
                iconType: Style.RoleEnum.IconType.Image
                enabled: false
                width: 32; height: 32
            }

            OnlineDelegateTitleAndCopyButton{
                width: parent.width - logoModelId.width
                height: parent.height
            }
        }

        Rectangle{
            id: informationAboutDownloadId
            visible: window.isDesktopSize && (2*(parent.width - informationAboutDownloadId.width - headerId.width - downloadButtonId.width - 20))/3 >20
            height: 45; width: 300
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: headerId.right
            anchors.leftMargin: (2*(parent.width - informationAboutDownloadId.width - headerId.width - downloadButtonId.width - 20))/3
            radius: 10
            border.color: Style.Colors.boxBorder
            border.width: 1
            color: "#00ffffff"
            Row{
                anchors.fill: parent

                OnlineDelegateInfoBox{
                    id:typeBox
                    myText: qsTr("Type")
                    myValue: model.type
                    width: (parent.width/3)-7
                }

                Rectangle{
                    id:line1
                    width: 1
                    height: parent.height
                    color: Style.Colors.boxBorder
                }

                OnlineDelegateInfoBox{
                    id: contextWindowsBox
                    myText: qsTr("Context Windows")
                    myValue: model.contextWindows
                    width: (parent.width/3) + 11
                }

                Rectangle{
                    id:line2
                    width: 1
                    height: parent.height
                    color: Style.Colors.boxBorder
                }

                OnlineDelegateInfoBox{
                    id:outputBox
                    myText: qsTr("Output")
                    myValue: model.output
                    width: (parent.width/3) - 4
                }
            }
        }

        ApikeyButton{
            id: downloadButtonId
            visible: window.isDesktopSize
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            isFillWidthDownloadButton:false
        }

        Column{
            visible: !window.isDesktopSize
            anchors.fill: parent
            anchors.margins: 10
            Row{
                id: header2Id
                width: parent.width

                MyIcon {
                    id: logoModel2Id
                    myIcon: "qrc:/media/image_company/" + model.icon
                    iconType: Style.RoleEnum.IconType.Image
                    enabled: false
                    width: 30; height: 30
                }
                OnlineDelegateTitleAndCopyButton{
                    width: parent.width - logoModel2Id.width
                    height: parent.height
                }
            }

            ApikeyButton{
                id: downloadButton2Id
                anchors.right: parent.right
                anchors.rightMargin: 5
                isFillWidthDownloadButton:false
            }
        }

        layer.enabled: control.hovered? true: false
        layer.effect: Glow {
             samples: 40
             color:  Style.Colors.boxBorder
             spread: 0.1
             transparentBorder: true
         }
    }
}
