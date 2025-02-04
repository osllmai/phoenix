import QtQuick 2.15

import "./components"

Item {
    ModelHeader{
        id: headerId
        Connections{
            target: headerId
            function onCurrentPage(numberPage){
                appBodyId.currentIndex = numberPage;
            }
        }
    }
    ModelBody{
        id:appBodyId
        anchors.top: headerId.bottom; anchors.bottom: parent.bottom
        anchors.left: parent.left; anchors.right: parent.right
        clip:true
    }
}
