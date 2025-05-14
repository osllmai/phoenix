import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "./components"

RowLayout {

    ColumnLayout{
        Layout.fillWidth: true
        Layout.fillHeight: true

        DeveloperHeader{
            id: headerId
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            Connections{
                target: headerId
                function onOpenModelSettingsDrawer(){
                    modelSettingsId.open()
                }

                function onOpenHistoryDrawer(){
                    historyId.open()
                }
            }
        }
        DeveloperBody{
            id: developerBodyId
            Layout.fillWidth: true
            Layout.fillHeight: true
            Connections{
                target: developerBodyId
                function onOpenModelList(){
                    headerId.openModelComboBox();
                }
            }
        }
        ModelSettingsDrawerDeveloper{
            id: modelSettingsId
        }
    }
    ModelSettingsDeveloper {
        id: modelSettingSpaceId
        Layout.preferredWidth: 320
        Layout.fillHeight: true
    }
}
