import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import '../../../../../component_library/style' as Style
import "../../../../../component_library/button"

Row{
    anchors.fill: parent

    OnlineDelegateInfoBox{
        id:typeBox
        myText: qsTr("Type")
        myValue: model.type
        width: (parent.width/3)-7
    }

    Rectangle{
        id:line1
        width: 1
        height: parent.height
        color: Style.Colors.boxBorder
    }

    OnlineDelegateInfoBox{
        id: contextWindowsBox
        myText: qsTr("Context Windows")
        myValue: model.contextWindows
        width: (parent.width/3) + 11
    }

    Rectangle{
        id:line2
        width: 1
        height: parent.height
        color: Style.Colors.boxBorder
    }

    OnlineDelegateInfoBox{
        id:outputBox
        myText: qsTr("Output")
        myValue: model.output
        width: (parent.width/3) - 4
    }
}
