import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'
import './components'

Item {
    id: control
    clip:true

    function calculationCellNumber(){
        if(gridView.width >1650)
            return 5;
        else if(gridView.width >1300)
            return 4;
        else if(gridView.width >950)
            return 3;
        else if(gridView.width >550)
            return 2;
        else
            return 1;
    }

    function calculationCellWidth(){
        if(gridView.width >1650)
            return gridView.width/calculationCellNumber();
        else if(gridView.width >1300)
            return gridView.width/calculationCellNumber();
        else if(gridView.width >950)
            return gridView.width/calculationCellNumber();
        else if(gridView.width >550)
            return gridView.width/calculationCellNumber();
        else
            return Math.max(gridView.width,300);
    }

    HuggingfaceGridView {
        id: gridView
        visible: (gridView.count !== 0) && (window.modelPageView === "gridView")
    }
    HuggingfaceListView {
        id: listView
        visible: (gridView.count !== 0) && (window.modelPageView === "listView")
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
