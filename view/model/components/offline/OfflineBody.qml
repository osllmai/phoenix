import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'
import './components'

Item {
    id: control
    clip:true

    Loader {
        id: modelViewLoader
        anchors.fill: parent
        sourceComponent: window.modelPageView === "gridView" ? gridComponent : listComponent
    }

    Component {
        id: gridComponent
        OfflineGridView {
            id: gridView
        }
    }

    Component {
        id: listComponent
        OfflineListView {
            id: listView
        }
    }
}
