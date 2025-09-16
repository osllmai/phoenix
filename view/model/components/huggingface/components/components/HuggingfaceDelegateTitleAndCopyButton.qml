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
        // visible: !titleAndCopy.visible
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
        // visible: !titleAndCopy.visible
        myText: TextArea{text: "localModel/"+model.name;}
        anchors.verticalCenter: titleId.verticalCenter
        anchors.right: parent.right
        clip: true
    }
    // Row{
    //     id: titleAndCopy
    //     visible: parent.width - title2Id.implicitWidth - copy2Id.width > 0
    //     width: parent.width
    //     anchors.verticalCenter: parent.verticalCenter
    //     clip: true
    //     Label {
    //         id: title2Id
    //         text: model.name
    //         color: Style.Colors.textTitle
    //         anchors.verticalCenter: parent.verticalCenter
    //         font.pixelSize: 14
    //         font.styleName: "Bold"
    //         clip: true
    //         elide: Label.ElideRight
    //     }
    //     MyCopyButton{
    //         id: copy2Id
    //         myText: TextArea{text: "localModel/"+model.name;}
    //         anchors.verticalCenter: title2Id.verticalCenter
    //         clip: true
    //     }
    // }

}
