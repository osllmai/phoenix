import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects
import '../../../component_library/style' as Style

Item {
    OnlineHeader{
        id: headerId
    }
    OnlineList{
        id:appBodyId
        anchors.top: headerId.bottom; anchors.bottom: parent.bottom
        anchors.left: parent.left; anchors.right: parent.right
        clip:true
    }
}
