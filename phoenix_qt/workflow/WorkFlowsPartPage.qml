import QtQuick
import QtQuick.Controls

Page {
    clip: true

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: WorkFlowsPage {
            onItemClicked:{
                stackView.push(Qt.resolvedUrl("BlockEditorPage.qml"));
            }
        }
    }
}
