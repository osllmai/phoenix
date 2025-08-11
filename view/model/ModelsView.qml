import QtQuick 2.15

import "./components"

Item {

    function setModelPages(page, filter){
        headerId.setModelPages(page)
        modelBodyId.setFilter(page, filter)
    }

    ModelHeader{
        id: headerId
        Connections{
            target: headerId
        }
    }
    ModelBody{
        id:modelBodyId
        anchors.fill: parent
        clip:true
    }
}
