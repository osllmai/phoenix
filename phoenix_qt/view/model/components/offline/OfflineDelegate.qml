import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import "../../../component_library/button"

T.Button {
    id: control
    width: 250
    height: 250

    property var model

    background:null

    contentItem:Rectangle{
        id: backgroundId
        anchors.fill: parent
        radius: 10
        border.width: 1
        border.color: Style.Colors.boxBorder

        gradient: Gradient {
            GradientStop {
                position: 0
                color: control.hovered? Style.Colors.boxHoverGradient0: Style.Colors.boxNormalGradient0
            }

            GradientStop {
                position: 1
                color: control.hovered? Style.Colors.boxHoverGradient1: Style.Colors.boxNormalGradient1
            }
            orientation: Gradient.Vertical
        }

        Column{
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10
            Row{
                id: headerId
                width: parent.width
                ToolButton {
                    id: logoModelId
                    background: null
                    icon{
                        source: "qrc:/media/image_company/" + control.model.company.icon
                        color: Style.Colors.iconHoverAndChecked
                        width:28; height:28
                    }
                }
                Text {
                    id: titleId
                    width: parent.width - logoModelId.width - likeIconId.width
                    text: control.model.name
                    color: Style.Colors.textTitle
                    anchors.verticalCenter: logoModelId.verticalCenter
                    font.pixelSize: 14
                    font.styleName: "Bold"
                }
                ToolButton {
                    id: likeIconId
                    background: null
                    anchors.verticalCenter: logoModelId.verticalCenter
                    icon{
                        source: control.model.isLike? "qrc:/media/icon/like.svg": "qrc:/media/icon/disLike.svg"
                        color: Style.Colors.like
                        width:20; height:20
                    }
                }
            }
            Item{
                id: aboutId
                height: parent.height - headerId.height - buttonListId.height - informationAboutDownloadId.height - 30
                width: parent.width
                clip: true
                Text{
                    id:informationId
                    text: control.model.information
                    color: Style.Colors.textInformation
                    clip: true
                    anchors.left: parent.left; anchors.right: parent.right
                    font.pixelSize: 10
                    horizontalAlignment: Text.AlignJustify
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }
            }
            Rectangle{
                id: informationAboutDownloadId
                height: 45; width: parent.width
                radius: 10
                border.color: Style.Colors.boxBorder
                border.width: 1
                color: "#00ffffff"
                Row{
                    anchors.fill: parent
                    Column{
                        id:fileSizeBox
                        width: (parent.width/4)-8
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 5
                        Text {
                            id: fileSizeText
                            color: Style.Colors.textInformation
                            text: qsTr("File size")
                            font.styleName: "Bold"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pointSize: 8
                        }
                        Text {
                            id: fileSizeValue
                            color: Style.Colors.textInformation
                            text: control.model.fileSize + " GB"
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
                        width: (parent.width/4)+ 17
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 5
                        Text {
                            id: ramRequiredText
                            color: Style.Colors.textInformation
                            text: qsTr("RAM requierd")
                            font.styleName: "Bold"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pointSize: 8
                        }
                        Text {
                            id: ramRequiredValue
                            color: Style.Colors.textInformation
                            text: control.model.ramRamrequired + " GB"
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
                        width: (parent.width/4)
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 5
                        Text {
                            id: parameterersText
                            color: Style.Colors.textInformation
                            text: qsTr("Parameters")
                            font.styleName: "Bold"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pointSize: 8
                        }
                        Text {
                            id: parameterersValue
                            color: Style.Colors.textInformation
                            text: control.model.parameters
                            font.pointSize: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Rectangle{
                        id:line3
                        width: 1
                        height: parent.height
                        color: Style.Colors.boxBorder
                    }
                    Column{
                        id: quantBox
                        width: (parent.width/4)-20
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 5
                        Text {
                            id: quantText
                            color: Style.Colors.textInformation
                            text: qsTr("Quant")
                            font.styleName: "Bold"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pointSize: 8
                        }
                        Text {
                            id: quantValue
                            color: Style.Colors.textInformation
                            text: control.model.quant
                            font.pointSize: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            Rectangle{
                id: buttonListId
                height: goToGithubId.height
                width: parent.width
                color: "#00ffffff"
                MyButton{
                    id:goToGithubId
                    width: (parent.width-10)/2
                    anchors.left: parent.left
                    myText: "GitHub"
                    bottonType: Style.RoleEnum.BottonType.Primary
                    Connections {
                        target: goToGithubId
                        function onClicked(){
                        }
                    }
                }
                MyButton{
                    id:goToNotebookId
                    width: (parent.width-10)/2
                    anchors.right: parent.right
                    myText: "Notebook"
                    bottonType: Style.RoleEnum.BottonType.Primary
                    Connections {
                        target: goToNotebookId
                        function onClicked(){
                        }
                    }
                }
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
