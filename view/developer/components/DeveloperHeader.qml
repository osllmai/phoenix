import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../component_library/style' as Style
import "../../component_library/button"
import "./model"
import "../../menu"

Item{
    id:headerId
    signal openModelSettingsDrawer()
    signal openHistoryDrawer()

    clip: true

    Row{
        spacing: 10
        anchors.left: parent.left; anchors.leftMargin: 24
        anchors.top: parent.top; anchors.topMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        MyOpenMenuButton{
            id: openMenuId
        }

        MySwitch{
            id: switchId
            checked: switchId.checked
            anchors.verticalCenter: openMenuId.verticalCenter
            onCheckedChanged:{
                codeDeveloperList.start()
            }
        }

        MySwitch{
            id: switchId2
            checked: switchId.checked
            anchors.verticalCenter: openMenuId.verticalCenter
            onCheckedChanged:{
                codeDeveloperList.start()
            }
        }

        ModelDeveloperComboBox{
            id: currentModelComboBoxId
            visible: window.width<=1150
        }
    }

    Row{
        spacing: 10
        anchors.right: parent.right; anchors.rightMargin: 24
        anchors.top: parent.top; anchors.topMargin: 12
        anchors.verticalCenter: parent.verticalCenter

        Rectangle{
            height: parent.height
            width: 150
            color: "#00ffffff"
            border.color: Style.Colors.boxBorder
            radius: 8

            Row{
                id: reacheblePort
                anchors.fill: parent
                anchors.leftMargin: 10

                Label {
                    id: textId2
                    text: "https://127.0.0.1:"+ codeDeveloperList.port
                    color: Style.Colors.textInformation
                    width: parent.width - switchId2.width
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 10
                }
            }
        }
        Rectangle{
            height: parent.height
            width: 150
            color: "#00ffffff"
            border.color: Style.Colors.boxBorder
            radius: 8

            Row{
                id: reacheblePort2
                anchors.fill: parent
                anchors.leftMargin: 10

                Label {
                    id: textId3
                    text: "https://127.0.0.1:"+ codeDeveloperList.port
                    color: Style.Colors.textInformation
                    width: parent.width - switchId2.width
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 10
                }
            }
        }

        MyButton{
            id: openModelSettingsId
            myIcon: "qrc:/media/icon/settings.svg"
            bottonType: Style.RoleEnum.BottonType.Secondary
           visible: window.width<=1500
            Connections {
                target: openModelSettingsId
                function onClicked(){
                    headerId.openModelSettingsDrawer()
                }
            }
        }
    }
}
