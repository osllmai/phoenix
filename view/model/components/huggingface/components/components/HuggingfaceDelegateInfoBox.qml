import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Layouts
import '../../../../../component_library/style' as Style
import "../../../../../component_library/button"

Column{
    id:control
    width: parent.width
    anchors.verticalCenter: parent.verticalCenter
    spacing: 5

    property string myText
    property string myValue

    Label {
        id: fileSizeText
        color: Style.Colors.textInformation
        text: control.myText
        font.styleName: "Bold"
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 8
    }
    Label {
        id: fileSizeValue
        color: Style.Colors.textInformation
        text: control.myValue
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 8
        clip: true
    }
}
