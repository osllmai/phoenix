import QtQuick 2.15

import "./components"

Item {

    function setModelPages(page, filter){
        headerId.setModelPages(page)
        modelBodyId.setFilter(page, filter)
    }

    DeepSearchHeader{
        id: headerId
        Connections{
            target: headerId
        }
    }
    DeepSearchBody{
        id:modelBodyId
        height: parent.height - headerId.height
        width: parent.width
        anchors.top: headerId.bottom
    }
}
