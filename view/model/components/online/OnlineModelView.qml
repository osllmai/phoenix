import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects
import '../../../component_library/style' as Style

Item {
    function setFilter(filter){
        headerId.filtter = filter
    }

    OnlineHeader{
        id: headerId
        width: parent.width - (window.isDesktopSize? 375: 210)
        anchors.top: parent.top; anchors.topMargin: 12
        anchors.right: parent.right; anchors.rightMargin:12
    }
    OnlineBody{
        id:onlineBodyId
        anchors.top: headerId.bottom; anchors.topMargin: 8
        anchors.bottom: parent.bottom
        anchors.left: parent.left; anchors.right: parent.right
        clip:true
    }
}
