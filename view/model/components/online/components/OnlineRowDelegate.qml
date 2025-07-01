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
            width: 250
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

            Label {
                id: titleId
                visible: !titleAndCopy.visible
                text: model.name
                color: Style.Colors.textTitle
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - logoModelId.width - copyId.width
                font.pixelSize: 14
                font.styleName: "Bold"
                clip: true
                elide: Label.ElideRight
                MouseArea {
                    id: infoMouseArea
                    anchors.fill: titleId
                    hoverEnabled: true

                    onPositionChanged: {
                        toolTip.x = mouseX
                        toolTip.y = mouseY
                    }

                    MyToolTip{
                        id: toolTip
                        toolTipText: model.information
                    }
                }
            }
            MyCopyButton{
                id: copyId
                visible: !titleAndCopy.visible
                myText: TextArea{text: "localModel/"+model.modelName;}
                anchors.verticalCenter: titleId.verticalCenter
                clip: true
            }

            Row{
                id: titleAndCopy
                visible: parent.width - logoModelId.width - title2Id.implicitWidth - copy2Id.width > 0
                width: parent.width - logoModelId.width
                anchors.verticalCenter: logoModelId.verticalCenter
                clip: true
                Label {
                    id: title2Id
                    text: model.name
                    color: Style.Colors.textTitle
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 14
                    font.styleName: "Bold"
                    clip: true
                    elide: Label.ElideRight
                    MouseArea {
                        id: infoMouseArea2
                        anchors.fill: title2Id
                        hoverEnabled: true

                        onPositionChanged: {
                            toolTip.x = mouseX
                            toolTip.y = mouseY
                        }

                        MyToolTip{
                            id: toolTip2
                            toolTipText: model.information
                        }
                    }
                }
                MyCopyButton{
                    id: copy2Id
                    myText: TextArea{text: "localModel/"+model.modelName;}
                    anchors.verticalCenter: title2Id.verticalCenter
                    clip: true
                }
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
                Column{
                    id:fileSizeBox
                    width: (parent.width/3)-7
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2
                    Label {
                        id: fileSizeText
                        color: Style.Colors.textInformation
                        text: qsTr("Type")
                        font.styleName: "Bold"
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: 8
                    }
                    Label {
                        id: fileSizeValue
                        color: Style.Colors.textInformation
                        text: model.type
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: 8
                    }
                }
                Rectangle{
                    id:line1
                    width: 1
                    height: parent.height
                    color: Style.Colors.boxBorder
                }
                Column{
                    id: ramRequiredBox
                    width: (parent.width/3) + 11
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2
                    Label {
                        id: ramRequiredText
                        color: Style.Colors.textInformation
                        text: qsTr("Context Windows")
                        font.styleName: "Bold"
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: 8
                    }
                    Label {
                        id: ramRequiredValue
                        color: Style.Colors.textInformation
                        text: model.contextWindows
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: 8
                    }
                }
                Rectangle{
                    id:line2
                    width: 1
                    height: parent.height
                    color: Style.Colors.boxBorder
                }
                Column{
                    id: parameterersBox
                    width: (parent.width/3) - 4
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2
                    Label {
                        id: parameterersText
                        color: Style.Colors.textInformation
                        text: qsTr("Output")
                        font.styleName: "Bold"
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: 8
                    }
                    Label {
                        id: parameterersValue
                        color: Style.Colors.textInformation
                        text: model.output
                        font.pointSize: 8
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
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
                Row{
                    width: parent.width - logoModel2Id.width
                    anchors.verticalCenter: logoModel2Id.verticalCenter
                    clip: true
                    Label {
                        id: title3Id
                        text: model.name
                        color: Style.Colors.textTitle
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 14
                        font.styleName: "Bold"
                        clip: true
                        elide: Label.ElideRight
                        MouseArea {
                            id: infoMouseArea3
                            anchors.fill: title3Id
                            hoverEnabled: true

                            onPositionChanged: {
                                toolTip.x = mouseX
                                toolTip.y = mouseY
                            }

                            MyToolTip{
                                id: toolTip3
                                toolTipText: model.information
                            }
                        }
                    }
                    MyCopyButton{
                        id: copy3Id
                        myText: TextArea{text: "localModel/"+model.modelName;}
                        anchors.verticalCenter: title3Id.verticalCenter
                        clip: true
                    }
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
