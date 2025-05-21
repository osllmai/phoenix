import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../component_library/style' as Style
import "../../component_library/button"
import "../../chat/components/model"
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
        Rectangle{
            height: parent.height
            width: 200
            color: switchId.checked? Style.Colors.boxSuccessColor: "#00ffffff"
            border.color: Style.Colors.boxBorder
            radius: 8

            Row{
                id: settingsSliderBox
                anchors.fill: parent
                anchors.leftMargin: 10

                Label {
                    id:textId
                    text: "Status: " + (switchId.checked?"Running": "Stopped")
                    color: Style.Colors.textInformation
                    width: parent.width - switchId.width
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 10
                }

                MySwitch{
                    id: switchId
                    checked: false
                    anchors.verticalCenter: parent.verticalCenter
                    onCheckedChanged:{
                        codeDeveloperList.start()
                    }
                }
            }
        }
        ModelComboBox{
            id: currentModelComboBoxId
        }
    }

    Row{
        spacing: 10
        anchors.right: parent.right; anchors.rightMargin: 24
        anchors.top: parent.top; anchors.topMargin: 12
        anchors.verticalCenter: parent.verticalCenter

        Rectangle{
            height: parent.height
            width: 300
            color: "#00ffffff"
            border.color: Style.Colors.boxBorder
            radius: 8

            Row{
                id: reacheblePort
                anchors.fill: parent
                anchors.leftMargin: 10

                Label {
                    id: textId2
                    text: "Reachable at: https://127.0.0.1:"+ codeDeveloperList.port
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
            Connections {
                target: openModelSettingsId
                function onClicked(){
                    headerId.openModelSettingsDrawer()
                }
            }
        }
    }
}
