import QtQuick 2.15
import QtQuick.Controls 2.15
import '../component_library/style' as Style
import '../component_library/button'
import "./components"

Item{
    id: titleBoxId
    height: 50
    width: parent.width

    OpenMenuSettingsButton{
        id: openMenuId
        anchors.left:parent.left; anchors.leftMargin: 10
        anchors.top: parent.top; anchors.topMargin: 10
    }

    MyIcon{
        id: closeBox
        anchors.right: parent.right; anchors.rightMargin: 10;
        anchors.top: parent.top; anchors.topMargin: 10;
        width: 30; height: 30
        myIcon: "qrc:/media/icon/close.svg"
        myTextToolTip: "Close"
        isNeedAnimation: true
        onClicked: drawerId.close()
    }
}
