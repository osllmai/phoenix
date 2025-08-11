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
        anchors.left: parent.left; anchors.leftMargin: 12
        anchors.top: parent.top; anchors.topMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        MyOpenMenuButton{
            id: openMenuId
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

        MyButton{
            id: openModelSettingsId
            myIcon: "qrc:/media/icon/settings.svg"
            myTextToolTip: "Model Settings"
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
