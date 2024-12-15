import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Phoenix

Item {
    id: root
    property int cardWidth: 200
    property int cardHeight: 230

    signal itemClicked(string data)

    WorkflowTemplatesStorage {
        id: templatesStorage
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent

        GridLayout {
            columns: (scrollView.width - 20) / (root.cardWidth + 20)
            width: parent.width
            columnSpacing: 20
            rowSpacing: 20

            Button {
                text: "Blank workflow"

                Layout.preferredHeight: root.cardHeight
                Layout.preferredWidth: root.cardWidth
                Layout.alignment: Qt.AlignCenter

                onClicked: root.itemClicked(title)
            }
            Repeater {
                model: templatesStorage.templates
                delegate: Button {
                    text: modelData.title

                    Layout.preferredHeight: root.cardHeight
                    Layout.preferredWidth: root.cardWidth
                    Layout.alignment: Qt.AlignCenter

                    onClicked: root.itemClicked(title)
                }
            }
        }
    }

}
