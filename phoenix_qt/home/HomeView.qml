import QtQuick 2.15

import "./components"

Item {
    HomeHeader{
        id: headerId
        width: parent.width; height: 60
    }
    FeatureList{
        id: featureListId
        anchors.left: parent.left; anchors.right: parent.right
        anchors.top: headerId.bottom; anchors.bottom: parent.bottom
    }
}
