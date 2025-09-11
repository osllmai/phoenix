import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.1 as T
import '../../../style' as Style
import '../../../button'

T.Button {
    id: control

    onClicked: {
        onlineModelList.selectCurrentModelRequest(model.id)
        console.log("Selected:", model.name, "id:", model.id)
    }

    property bool checkselectItem: (onlineModelList.currentModel.id === model.id)

    contentItem: Label{
        text: "   " + model.name
        color: Style.Colors.textInformation
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        id: backgroundId
        color: Style.Colors.background
        border.width: 1; border.color: Style.Colors.boxBorder
        radius: 10
    }
}
