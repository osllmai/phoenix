import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Phoenix

Block {
    title: "Chat output"

    background: BlockBackground {}

    header: BlockHeader {
        title: block.title
        descript: "Display a chat message in the Playground."
        icon: "qrc:/res/icons/chat.svg"
    }

    contentItem: ColumnLayout {
        Label {
            text: "Text"
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
