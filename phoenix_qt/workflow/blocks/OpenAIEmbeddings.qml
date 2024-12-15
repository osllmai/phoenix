import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Phoenix
import '..'

AbstractBlock {
    id: block
    title: "OpenAI embeddings"
    descript: qsTr("Generate embeddings using OpenAI models.")

    contentItem: ColumnLayout {
        Label {
            text: qsTr("Model")
        }
        ComboBox {
            model: [qsTr("text-embedding-3-small"), qsTr("text-embedding-3-large"), qsTr("text-embedding-ada-002")]
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("OpenAI API Key")
        }
        TextField {
        }
    }
}
