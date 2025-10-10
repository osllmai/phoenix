import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style
import '../../../../component_library/button'
import "./components"

Column{
    spacing: 5
    ListView {
        id: listView
        height: 90
        width: Math.min(parent.width - 40, listView.contentWidth)
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 5
        layoutDirection: Qt.LeftToRight
        orientation: ListView.Horizontal
        snapMode: ListView.SnapToItem
        interactive: contentWidth > width
        boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds
        clip: true

        ScrollBar.horizontal: ScrollBar {
            policy: listView.contentWidth > listView.width
                    ? ScrollBar.AlwaysOn
                    : ScrollBar.AlwaysOff
        }

        model: onlineCompanyList

        delegate: MyMenu {
            id: companyMenu
            myText: model.name
            myIcon: model.icon
            iconType: Style.RoleEnum.IconType.Image
            rowView: false
            autoExclusive: true
            checked: onlineBodyId.onlineModelPage === model.name

            onClicked: {
                onlineBodyId.currentProvider = model.name === "Indox Router"
                                                ? onlineCompanyListFilter
                                                : onlineModelList
                onlineBodyId.onlineModelPage = model.name
                onlineBodyId.installProvider = model.installModel

                onlineBodyId.providerName = model.name
                onlineBodyId.providerIcon = model.icon
                onlineBodyId.providerKey = model.key
                onlineBodyId.providerId = model.id
            }

            Component.onCompleted: {
                if (model.name === "Indox Router" && onlineBodyId.onlineModelPage === "Indox Router") {
                    companyMenu.checked = true
                    onlineBodyId.currentProvider = model.name === "Indox Router"
                                                   ? onlineCompanyListFilter
                                                   : onlineModelList
                    onlineBodyId.onlineModelPage = model.name
                    onlineBodyId.installProvider = model.installModel
                    onlineBodyId.providerName = model.name
                    onlineBodyId.providerIcon = model.icon
                    onlineBodyId.providerKey = model.key
                    onlineBodyId.providerId = model.id
                }
            }

            property string installProvider: model.installModel
            onInstallProviderChanged: {
                if (onlineBodyId.onlineModelPage === model.name) {
                    onlineBodyId.installProvider = model.installModel
                }
            }
        }
    }

    ApikeyButton{
        id: apikeyButton
        width: 380
        anchors.left: parent.left
        anchors.leftMargin: 20
    }

    GridView {
        id: gridView
        visible: gridView.count !== 0
        height: parent.height - listView.height  - apikeyButton.height
        width: parent.width
        cacheBuffer: Math.max(0, gridView.contentHeight)

        cellWidth: gridView.calculationCellWidth()
        cellHeight: (gridView.model === onlineCompanyListFilter? 150: 180) + (onlineBodyId.installProvider?30:0)

        interactive: gridView.contentHeight > gridView.height
        boundsBehavior: gridView.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

        flickDeceleration: 80
        maximumFlickVelocity: 30000

        ScrollBar.vertical: ScrollBar {
            policy: gridView.contentHeight > gridView.height
                    ? ScrollBar.AlwaysOn
                    : ScrollBar.AlwaysOff
        }

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
        clip: true

        model: onlineBodyId.currentProvider

        delegate: Item {
            width: model.name !== "Indox Router"? gridView.cellWidth: 0
            height: model.name !== "Indox Router"? gridView.cellHeight: 0
            visible: model.name !== "Indox Router"

            Loader {
                    anchors.fill: parent
                    active: model.name !== "Indox Router"
                    sourceComponent: gridView.model === onlineCompanyListFilter
                                    ? companyDelegate
                                    : boxDelegate
                }

            Component {
                id: companyDelegate
                OnlineCompanyBoxDelegate {
                    anchors.fill: parent
                    anchors.margins: 12
                    Behavior on anchors.margins { NumberAnimation { duration: 200 } }
                }
            }

            Component {
                id: boxDelegate
                OnlineBoxDelegate {
                    anchors.fill: parent
                    anchors.margins: 12
                    Behavior on anchors.margins { NumberAnimation { duration: 200 } }
                }
            }
        }
    }
}
