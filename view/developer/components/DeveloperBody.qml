import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import '../../component_library/style' as Style
import "./command_line"
import "./model"
import "code"

RowLayout {

    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ModelDeveloperView {
                id: modelDeveloperId
                Layout.preferredWidth: parent.width / 3
                Layout.fillHeight: true
                visible: window.width>1150
            }

            CodeDeveloper {
                id: curlDeveloperId
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

        CommandLineInterface {
            id: commandLineInterfaceId
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height / 3
        }
    }
}
