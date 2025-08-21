import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Layouts
import '../../../../../component_library/style' as Style
import "../../../../../component_library/button"

Row{
    anchors.fill: parent

    HuggingfaceDelegateInfoBox{
        myText: qsTr("Type")
        myValue: model.piplineTag
        width: (parent.width/4)+12
    }

    Rectangle{
        width: 1
        height: parent.height
        color: Style.Colors.boxBorder
    }

    HuggingfaceDelegateInfoBox{
        myText: qsTr("Likes")
        myValue: model.likes
        width: (parent.width/4) - 20
    }

    Rectangle{
        width: 1
        height: parent.height
        color: Style.Colors.boxBorder
    }

    HuggingfaceDelegateInfoBox{
        myText: qsTr("Downloads")
        myValue: model.downloads
        width: (parent.width/4) - 2
    }

    Rectangle{
        width: 1
        height: parent.height
        color: Style.Colors.boxBorder
    }

    HuggingfaceDelegateInfoBox{
        myText: qsTr("LibraryName")
        myValue: model.libraryName
        width: (parent.width/4) + 10
    }
}
