import QtQuick 2.15

import "./Components"

Item {
    ModelHeader{
        id: headerId
        width: parent.width; height: 80
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
