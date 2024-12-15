import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Phoenix
import '..'

Block {
    id: block

    title: "Parse code"

    background: BlockBackground {}

    header: BlockHeader {
        title: block.title
        descript: "Convert Data into plain text following a specified template."
        icon: "qrc:/res/icons/code.svg"
    }

    contentItem: ColumnLayout {
        Label {
            text: "Template"
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
