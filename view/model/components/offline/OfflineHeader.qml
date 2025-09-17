import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'
import './components'

Item{
    id:headerId

    property string filtter: "All"
    onFiltterChanged: {
        if(headerId.filtter ==="All" || headerId.filtter ==="Favorite"){
            offlineModelListFilter.filter(headerId.filtter)
        }else{
            offlineModelListFilter.type = headerId.filtter
        }
    }

    width: parent.width
    height: 35
    clip:true

    signal search(var text)

    Row{
        id: fillterBox
        width: parent.width
        spacing: 10

        Item{
            height: 35
            width: parent.width -  companyList.width - viewList.width - 20 - 10
            SearchOfflineModel{
                id: searchBoxId
                width: Math.min(parent.width , 450)
                anchors.horizontalCenter: parent.horizontalCenter
                Connections{
                    target: searchBoxId
                    function onSearch(myText){
                        offlineModelListFilter.setFilterFixedString(myText)
                        offlineModelListFinishedDownloadFilter.setFilterFixedString(myText)
                    }
                }
            }
        }

        MyComboBox {
            id: companyList
            width: parent.width<380? 35 :110
            model: [
                "All",
                "Favorite",
                "Text Generation",
                "Speech"
            ]
            displayText: headerId.filtter
            onActivated: {
                var selectedType = model[currentIndex]
                if (selectedType === "All" || selectedType === "Favorite") {
                    offlineModelListFilter.filter(selectedType)
                } else {
                    offlineModelListFilter.type = selectedType
                }
                headerId.filtter = selectedType
            }
        }

        ListView{
            id: viewList
            anchors.verticalCenter: companyList.verticalCenter
            width: 65
            height: 30
            spacing: 5

            layoutDirection: Qt.RightToLeft
            orientation: Qt.Horizontal
            snapMode: ListView.SnapToItem

            clip: true

            model: ListModel {
                ListElement {
                    modelPageView: "gridView"
                    icon: "qrc:/media/icon/gridView.svg"
                }
                ListElement {
                    modelPageView: "listView"
                    icon: "qrc:/media/icon/listView.svg"
                }
            }
            delegate: MyButton {
                id: delegateViewId
                width: 30; height: 30
                myIcon: model.icon
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.Primary
                isNeedAnimation: true
                checkable: true
                checked: window.modelPageView === model.modelPageView
                selected: window.modelPageView === model.modelPageView
                onClicked:{
                    if(window.modelPageView !== model.modelPageView){
                        window.modelPageView = model.modelPageView
                    }
                }
            }
        }
    }
}
