import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Phoenix
import '..'
import '../form' as Form

Block {
    id: block
    title: "Astra DB"

    padding: 20
    // height: implicitHeight
    width: 300

    header :BlockHeader {
        title: block.title
        descript: qsTr("Generate embeddings using OpenAI models.")
        icon: 'qrc:/res/icons/ds.svg'
    }

    background: BlockBackground {  }

    contentItem: ColumnLayout {
        Label {
            text: qsTr("AstraDB Application token")
            Layout.fillWidth: true
        }
        TextField {
            Layout.fillWidth: true
        }

        Label {
            text: "Database"
        }
        ComboBox {
            model: [qsTr("text-embedding-3-small"), qsTr("text-embedding-3-large"), qsTr("text-embedding-ada-002")]
            Layout.fillWidth: true
        }

        Label {
            text: "Collection"
            enabled: false
        }
        ComboBox {
            enabled: false
            Layout.fillWidth: true
        }


        Label {
            text: qsTr("OpenAI API Key")
        }
        ComboBox {
            model: ["Embedding Model", "Astra Vectorize"]
            Layout.fillWidth: true
        }
        // Form.TextFieldInput {
        //     Layout.fillWidth: true
        // }
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
