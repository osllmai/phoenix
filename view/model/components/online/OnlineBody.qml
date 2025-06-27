import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import './components'

Item {
    id: control
    clip:true

    function calculationCellWidth(){
        if(gridView.width >1650)
            return gridView.width/5;
        else if(gridView.width >1300)
            return gridView.width/4;
        else if(gridView.width >950)
            return gridView.width/3;
        else if(gridView.width >550)
            return gridView.width/2;
        else
            return Math.max(gridView.width,300);
    }

    OnlineGridView {
        id: gridView
        visible: gridView.count !== 0 && false
    }
    OnlineListView {
        id: listView
        visible: listView.count !== 0 && true
    }
    Item{
        id:emptyHistory
        visible: gridView.count === 0
        anchors.fill: parent
        Label {
            id: textId
            text: "OnlineModel List is empty."
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: Style.Colors.textInformation
            font.pixelSize: 14
            clip: true
        }
    }
}
