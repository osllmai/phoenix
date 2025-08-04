import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import '../component_library/style' as Style
import '../component_library/button'

T.Popup {
    Rectangle{
        id:systemMonitorRec
        anchors.fill: parent
        color: Style.Colors.background
        radius: 4
        border.color: Style.Colors.boxBorder
        border.width: 1

        ListView{
            id: listView
            anchors.fill: parent
            anchors.margins: 10
            cacheBuffer: Math.max(0, listView.contentHeight)

            interactive: listView.contentHeight > listView.height
            boundsBehavior: listView.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

            flickDeceleration: 200
            maximumFlickVelocity: 12000

            ScrollBar.vertical: ScrollBar {
                policy: listView.contentHeight > listView.height
                        ? ScrollBar.AlwaysOn
                        : ScrollBar.AlwaysOff
            }
            clip: true
            model: offlineModelListIsDownloadingFilter
            delegate: Item{
                width: listView.width; height: 48

                DownloadingDelegate {
                    id: indoxItem
                   anchors.fill: parent; anchors.margins: indoxItem.hovered? 3: 5
                   Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
               }
            }
        }

        layer.enabled: true
        layer.effect: Glow {
            samples: 40
            color:  Style.Colors.boxBorder
            spread: 0.1
            transparentBorder: true
         }
    }
}
