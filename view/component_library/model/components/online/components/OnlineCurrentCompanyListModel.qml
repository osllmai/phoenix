import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import '../../../../style' as Style
import "../../../../button"

T.Popup {
    id: control
    width: 300
    height: 250

    property var myModel

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
            implicitHeight: Math.min(contentHeight, 240)
            model: control.myModel

            delegate: Item{
                width: listView.width - 10; height: 45

                OnlineCurrentCompanyListModelDelegate {
                   id: indoxItem
                   anchors.fill: parent; anchors.margins: indoxItem.hovered? 2: 4
                   Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
                   MouseArea {
                       anchors.fill: parent
                       onClicked: {
                           control.myModel.selectCurrentModelRequest(model.id)
                       }
                   }
                   checkselectItem: (control.myModel.currentModel.name === model.name)?true:false
               }
            }
        }
    }
}
