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
        Layout.fillWidth: true
    }
    TextField {
        text: root.field.value
        enabled: !root.isRunning
        Layout.fillWidth: true
        onEditingFinished: block.step.setFieldValue(modelData.name, text)
    }
}
