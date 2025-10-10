import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import '../../../../style' as Style
import "../../../../button"

T.Popup {
    id: control
    width: 140
    height: listView.implicitHeight + 10

    property var myModel
    property int currentId: -1

    onClosed: {
        if (offlineModelInformation.visible)
            offlineModelInformation.close()
    }

    background:null
    contentItem: Rectangle{
        color: Style.Colors.background
        anchors.fill: parent
        border.width: 1
        border.color: Style.Colors.boxBorder
        radius: 8

        ListView {
            id: listView
            anchors.fill: parent
            anchors.margins: 5
            clip: true
            interactive: contentHeight > height
            boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds
            ScrollBar.vertical: ScrollBar {
                policy: listView.contentHeight > listView.height
                        ? ScrollBar.AlwaysOn
                        : ScrollBar.AlwaysOff
            }
            ScrollIndicator.vertical: ScrollIndicator { }
            implicitHeight: Math.min(listView.contentHeight, 240)
            model: control.myModel

            delegate: Item{
                width: listView.width - 10; height: 40

                OnlineCurrentCompanyListModelDelegate {
                   id: indoxItem
                   anchors.fill: parent; anchors.margins: indoxItem.hovered? 2: 4
                   Behavior on anchors.margins{ NumberAnimation{ duration: 200}}

                   checkselectItem: (onlineCompanyList.currentIndoxRouterCompany.name === model.name)?true:false
                   selected: (model.id === control.currentId) && (offlineModelInformation.opened)

                   onHoveredChanged: {
                       if (hovered) {
                           offlineModelInformation.close()

                           var globalPos = indoxItem.mapToItem(listView, 0, 0)

                           offlineModelInformation.myModel = onlineModelList
                           control.currentId = model.id
                           offlineModelInformation.x = listView.width + 20
                           offlineModelInformation.y = globalPos.y
                           offlineModelInformation.open()

                       }
                   }
                   onClicked: {
                       offlineModelInformation.setComanyForIndoxRouter()
                       if (modelSelectViewId.modelSelect) {
                           modelSelectViewId.setModelRequest(
                               modelSelectViewId.modelId,
                               modelSelectViewId.modelName,
                               modelSelectViewId.modelIcon,
                               "",
                               ""
                           )
                       }
                   }
               }
            }
            OnlineCurrentCompanyListModel {
                id: offlineModelInformation
                modal: false
                focus: true
                Connections {
                    target: offlineModelInformation
                    function onSetComanyForIndoxRouter() {
                        onlineCompanyList.selectCurrentIndoxRouterCompanyRequest(control.currentId)
                    }
                }
            }
        }
    }
}
