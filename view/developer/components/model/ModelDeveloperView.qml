import QtQuick
import '../../../component_library/model'

Item {
    id: control
    clip: true

    ModelSelectView{
        id: modelComboBoxId
        anchors.fill: parent
        anchors.margins: 10
    }
}
