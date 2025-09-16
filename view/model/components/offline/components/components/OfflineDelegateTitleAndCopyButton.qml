import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Layouts
import '../../../../../component_library/style' as Style
import "../../../../../component_library/button"

Item {
    Label {
        id: titleId
        text: model.name
        color: Style.Colors.textTitle
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - copyId.width
        font.pixelSize: 14
        font.styleName: "Bold"
        clip: true
        elide: Label.ElideRight
    }
    MyCopyButton{
        id: copyId
        myText: TextArea{text: model.modelName;}
        anchors.verticalCenter: titleId.verticalCenter
        anchors.right: parent.right
        clip: true
    }
}
