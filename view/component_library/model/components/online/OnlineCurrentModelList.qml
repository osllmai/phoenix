import QtQuick 2.15
import QtQuick.Controls 2.15
import "./components"

ListView {
    id: listView

    height: listView.contentHeight
    width: parent.width

    property int currentId: -1

    interactive: listView.contentHeight > listView.height
    boundsBehavior: listView.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

    delegate: Item {
        width: listView.width
        height: 45

        OnlineCurrentModelDelegate {
            id: indoxItem
            anchors.fill: parent
            anchors.margins: hovered ? 2 : 4
            Behavior on anchors.margins { NumberAnimation { duration: 200 } }
            selected: (model.id === listView.currentId) && (offlineModelInformation.opened)

            onHoveredChanged: {
                if (hovered) {
                    offlineModelInformation.close()
                    onlineIndoxRouter.close()

                    var globalPos = indoxItem.mapToItem(listView, 0, 0)

                    if (model.name !== "Indox Router") {
                        offlineModelInformation.myModel = onlineModelList
                        offlineModelInformation.x = listView.width + 20
                        offlineModelInformation.y = globalPos.y
                        offlineModelInformation.open()
                    } else {
                        onlineIndoxRouter.myModel = onlineCompanyListFilter
                        onlineIndoxRouter.x = listView.width + 20
                        onlineIndoxRouter.y = globalPos.y
                        onlineIndoxRouter.open()
                    }
                    listView.currentId = model.id
                }
            }
        }
    }

    OnlineCurrentCompanyListModel {
        id: offlineModelInformation
        modal: false
        focus: true
    }

    OnlineCurrentIndoxRouterCompanyyList {
        id: onlineIndoxRouter
        modal: false
        focus: true
    }
}
