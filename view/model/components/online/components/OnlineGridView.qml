import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style
import '../../../../component_library/button'
import "./components"

Column{
    ListView{
        id: listView
        height: 90
        width: listView.contentWidth
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 5
        // cacheBuffer: Math.max(0, listView.contentWidth)

        layoutDirection: Qt.LeftToRight
        orientation: Qt.Horizontal
        snapMode: ListView.SnapToItem

        interactive: contentWidth > width
        boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

        ScrollBar.vertical: ScrollBar {
            policy: listView.contentHeight > listView.height
                    ? ScrollBar.AlwaysOn
                    : ScrollBar.AlwaysOff
        }
        clip: true

        model: onlineCompanyList

        header:MyMenu {
            id: indoxrouter
            myText: window.isDesktopSize? "Indox Router": ""
            myIcon: "qrc:/media/image_company/indoxRoter.png"
            iconType: Style.RoleEnum.IconType.Image
            rowView: false
            Connections {
                target: indoxrouter
                function onClicked(){
                    gridView.model = onlineCompanyList
                }
            }
        }

        delegate:MyMenu {
            id: offlineModel
            myText: window.isDesktopSize? model.name: ""
            myIcon: model.icon
            iconType: Style.RoleEnum.IconType.Image
            rowView: false
            Connections {
                target: offlineModel
                function onClicked() {
                    gridView.model = onlineModelList

                    apikeyButton.modelId = model.id
                    apikeyButton.modelName = model.name
                    // apikeyButton.modelType = model.type
                    apikeyButton.modelIcon = model.icon
                    // apikeyButton.modelPromptTemplate = model.promptTemplate
                    // apikeyButton.modelSystemPrompt = model.systemPrompt
                    apikeyButton.modelKey = model.key
                    apikeyButton.installModel = model.installModel
                }

            }
        }
    }

    ApikeyButton{
        id: apikeyButton
        width: 300
    }

    GridView {
        id: gridView
        visible: gridView.count !== 0
        height: parent.height - listView.height
        width: parent.width
        cacheBuffer: Math.max(0, gridView.contentHeight)

        cellWidth: gridView.calculationCellWidth()
        cellHeight: gridView.model === onlineCompanyList? 160: 250

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

        model: onlineCompanyList

        delegate: Item {
            width: gridView.cellWidth
            height: gridView.cellHeight

            Loader {
                anchors.fill: parent
                sourceComponent: gridView.model === onlineCompanyList
                                ? companyDelegate
                                : boxDelegate
            }

            Component {
                id: companyDelegate
                OnlineCompanyBoxDelegate {
                    anchors.fill: parent
                    anchors.margins: 18
                    Behavior on anchors.margins { NumberAnimation { duration: 200 } }
                }
            }

            Component {
                id: boxDelegate
                OnlineBoxDelegate {
                    anchors.fill: parent
                    anchors.margins: 18
                    Behavior on anchors.margins { NumberAnimation { duration: 200 } }
                }
            }
        }
    }
}
