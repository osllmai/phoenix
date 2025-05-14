import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import '../../component_library/style' as Style
import "./command_line"
import "./model"
import "curl"

RowLayout {

    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ModelDeveloperView {
                id: modelDeveloperId
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            CurlDeveloper {
                id: curlDeveloperId
                Layout.preferredWidth: 2 * parent.width / 3
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
