import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import '../../component_library/style' as Style
import "./command_line"
import "./model"
import "code"

RowLayout {

    SplitView {
        id: mainSplitView
        Layout.fillWidth: true
        Layout.fillHeight: true
        orientation: Qt.Vertical

        handle: Rectangle {
             id: mainHandleDelegate
             implicitWidth: 0
             implicitHeight: 0
             color: Style.Colors.boxBorder

             containmentMask: Item {
                 y: (mainHandleDelegate.height - height) / 2
                 height: 20
                 width: mainSplitView.width
             }
         }

        SplitView {
            id: splitView
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            SplitView.minimumHeight: 200
            orientation: Qt.Horizontal

            handle: Rectangle {
                 id: handleDelegate
                 implicitWidth: 0
                 implicitHeight: 0
                 color: Style.Colors.boxBorder

                 containmentMask: Item {
                     x: (handleDelegate.width - width) / 2
                     width: 20
                     height: splitView.height
                 }
             }

            ModelDeveloperView {
                id: modelDeveloperId
                SplitView.preferredWidth: parent.width / 3
                SplitView.minimumWidth: 300
                SplitView.fillHeight: true
                visible: window.width>1150
            }

            CodeDeveloper {
                id: curlDeveloperId
                SplitView.fillWidth: true
                SplitView.fillHeight: true
                SplitView.minimumWidth: 400
            }
        }

        CommandLineInterface {
            id: commandLineInterfaceId
            SplitView.preferredHeight: parent.height / 3
            SplitView.minimumHeight: 200
            SplitView.fillWidth: true
        }
    }
}
