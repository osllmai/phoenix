import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Phoenix

ColumnLayout{
    id: root
    property WorkFlowStepField field
    property bool isRunning
    Label {
        text: root.field.name
        font.bold: true
        Layout.fillWidth: true
    }
    Label {
        text: root.field.value
        Layout.fillWidth: true
        textFormat: Text.MarkdownText
    }
}
