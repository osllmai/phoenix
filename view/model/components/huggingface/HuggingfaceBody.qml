import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'
import './components'
import "./components/modelInfo"

Item {
    id: control
    clip:true

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
    HuggingfaceInfoDialog{
        id: huggingfaceDialogId
    }
}
