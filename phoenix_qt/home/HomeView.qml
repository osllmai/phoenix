import QtQuick 2.15

import "./Components"

Item {
    Header{
        id: headerId
        width: parent.width; height: 80
    }
    FeatureList{
        id: featureListId
        anchors.left: parent.left; anchors.right: parent.right
        anchors.top: headerId.bottom; anchors.bottom: parent.bottom
    }
}
