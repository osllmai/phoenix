import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import '../../../../../component_library/style' as Style
import "../../../../../component_library/button"

T.Popup {
    Rectangle{
        id:systemMonitorRec
        anchors.fill: parent
        color: Style.Colors.background
        radius: 4
        border.color: Style.Colors.boxBorder
        border.width: 1

        layer.enabled: true
        layer.effect: Glow {
            samples: 40
            color:  Style.Colors.boxBorder
            spread: 0.1
            transparentBorder: true
         }
        ListView{
            id: companyList
            width: companyList.contentWidth
            height: parent.height
            anchors.margins: 10
            spacing: 5

            layoutDirection: Qt.RightToLeft
            orientation: Qt.Horizontal
            snapMode: ListView.SnapToItem

            interactive: contentWidth > width
            boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

            ScrollBar.horizontal: ScrollBar {
                policy: ScrollBar.AsNeeded
            }
            clip: true

            model: ListModel {
                ListElement {
                    name: "All"
                    type: "All"
                }
                ListElement {
                    name: "Huggingface"
                    type: "Huggingface"
                }
                ListElement {
                    name: "Favorite"
                    type: "Favorite"
                }
            }
            delegate: MyButton {
                id: delegateId
                myText: model.name
                height: searchBoxId.height
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureBlue
                isNeedAnimation: true
                checkable: true
                checked: headerId.filtter === model.type
                selected: headerId.filtter === model.type
                onClicked:{
                    if(model.type ==="All" || model.type ==="Favorite"){
                        offlineModelListFilter.filter(model.type)
                    }else{
                        offlineModelListFilter.type = model.type
                    }
                    headerId.filtter= model.type
                }
            }
        }

    }
}
