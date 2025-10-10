import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

import './components'

Item {
    id: onlineBodyId
    clip:true

    property string onlineModelPage:"Indox Router"
    property var currentProvider: onlineCompanyListFilter
    property int providerId
    property string providerName: ""
    property string providerIcon: ""
    property string providerSystemPrompt: ""
    property string providerKey: ""
    property bool installProvider: false

    Loader {
        id: modelViewLoader
        anchors.fill: parent
        sourceComponent: window.modelPageView === "gridView" ? gridComponent : listComponent
    }

    Component {
        id: gridComponent
        OnlineGridView {
            id: gridView
        }
    }

    Component {
        id: listComponent
        OnlineListView {
            id: listView
        }
    }
}
