import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Phoenix

Block {
    id: block
    title: "Prompt"

    background: BlockBackground {}

    header: BlockHeader {
        title: block.title
        descript: "Create a prompt template with dynamic variables."
        icon: "qrc:/res/icons/prompt.svg"
    }

    contentItem: ColumnLayout {
        Label {
            text: "Template"
            Layout.fillWidth: true
        }
        TextField {
            Layout.fillWidth: true
        }

        Label {
            text: "Context"
            Layout.fillWidth: true
        }
        TextField {
            Layout.fillWidth: true
        }

        Label {
            text: "Question"
            Layout.fillWidth: true
        }
        TextField {
            Layout.fillWidth: true
        }
    }

    SimpleRelationHandle {
        type: RelationHandle.Output

        anchors {
            right: parent.right
            rightMargin: -15
            top: parent.top
            topMargin: 25
        }
    }

    SimpleRelationHandle {
        type: RelationHandle.Input
        anchors {
            left: parent.left
            leftMargin: -15
            top: parent.top
            topMargin: 25
        }
    }
}
