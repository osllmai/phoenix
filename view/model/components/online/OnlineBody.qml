import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

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
        visible: gridView.count !== 0 && (window.modelPageView === "gridView")
    }
    OnlineListView {
        id: listView
        visible: listView.count !== 0 && (window.modelPageView === "listView")
    }

    Item{
        id:emptyHistory
        visible: gridView.count === 0
        anchors.fill: parent
        MyIcon {
            id: notFoundModelIconId
            myIcon: "qrc:/media/icon/notFoundModel.svg"
            iconType: Style.RoleEnum.IconType.Image
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            enabled: false
            width: 120; height: 120
        }
    }
}
