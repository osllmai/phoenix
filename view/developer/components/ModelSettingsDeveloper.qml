import QtQuick 2.15
import '../../component_library/style' as Style
import "./model_settings"

Item {
    Rectangle {
        id: instructionsBox
        anchors.fill: parent
        anchors.margins: 10
        color: Style.Colors.boxHover
        radius: 12
        ModelSettingsBodyDeveloper{
            id: historyBadyId
            anchors.fill:parent; anchors.margins: 10
        }
    }
}
