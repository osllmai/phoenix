import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Layouts
import '../../../../../component_library/style' as Style
import "../../../../../component_library/button"

Row{
    anchors.fill: parent

    OfflineDelegateInfoBox{
        id:fileSizeBox
        myText: qsTr("File size")
        myValue: model.fileSize + " GB"
        width: (parent.width/4)-8
    }

    Rectangle{
        id:line1
        width: 1; height: parent.height
        color: Style.Colors.boxBorder
    }

    OfflineDelegateInfoBox{
        id:ramRequiredBox
        myText: qsTr("RAM requierd")
        myValue: model.ramRamrequired + " GB"
        width: (parent.width/4)+ 17
    }

    Rectangle{
        id:line2
        width: 1; height: parent.height
        color: Style.Colors.boxBorder
    }

    OfflineDelegateInfoBox{
        id:parameterersBox
        myText: qsTr("Parameters")
        myValue: model.parameters
        width: (parent.width/4)
    }

    Rectangle{
        id:line3
        width: 1; height: parent.height
        color: Style.Colors.boxBorder
    }

    OfflineDelegateInfoBox{
        id:quantBox
        myText: qsTr("Quant")
        myValue: model.quant
        width: (parent.width/4)-20
    }
}
