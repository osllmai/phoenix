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
            id: offlineModel
            myText: model.name
            myIcon: model.icon
            iconType: Style.RoleEnum.IconType.Image
            rowView: false
            autoExclusive: false
            checked: onlineBodyId.onlineModelPage === model.name


            Connections {
                target: offlineModel
                function onClicked() {
                    if (model.name === "Indox Router") {
                        onlineBodyId.currentModel = onlineCompanyListFilter
                    } else {
                        onlineBodyId.currentModel = onlineModelList
                    }
                    onlineBodyId.onlineModelPage = model.name

                    apikeyButton.modelId = model.id
                    apikeyButton.modelName = model.name
                    apikeyButton.modelIcon = model.icon
                    apikeyButton.modelKey = model.key
                    apikeyButton.installModel = model.installModel
                    apikeyButton.check = false
                }
            }

            property string installModel: model.installModel
            onInstallModelChanged: {
                if (onlineBodyId.onlineModelPage === model.name) {
                    apikeyButton.installModel = model.installModel
                }
            }
        }
    }

    ApikeyButton{
        id: apikeyButton
        width: 300
        anchors.left: parent.left
        anchors.leftMargin: 20
    }

    ListView {
        id: gridView
        visible: gridView.count !== 0
        height: parent.height - listView.height - apikeyButton.height
        width: parent.width

        interactive: gridView.contentHeight > gridView.height
        boundsBehavior: gridView.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

        flickDeceleration: 80
        maximumFlickVelocity: 30000

        ScrollBar.vertical: ScrollBar {
            policy: gridView.contentHeight > gridView.height
                    ? ScrollBar.AlwaysOn
                    : ScrollBar.AlwaysOff
        }
        clip: true

        model: onlineBodyId.currentModel

        delegate: Item {
            visible: model.name !== "Indox Router"
            width: gridView.width
            height: window.isDesktopSize? 65:90

            Loader {
                    anchors.fill: parent
                    active: model.name !== "Indox Router"
                    sourceComponent: gridView.model === onlineCompanyListFilter
                                    ? companyDelegate
                                    : boxDelegate
                }

            Component {
                id: companyDelegate
                OnlineCompanyRowDelegate {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.topMargin: 5
                    anchors.bottomMargin: 5
                }
            }

            Component {
                id: boxDelegate
                OnlineRowDelegate {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.topMargin: 5
                    anchors.bottomMargin: 5
                }
            }
        }
    }
}
