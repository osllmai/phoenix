import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'
import './components'

Item{
    id: headerId

    property string filtter: "All"
    onFiltterChanged: {
        if(headerId.filtter ==="All" || headerId.filtter ==="Favorite"){
            onlineModelListFilter.filter(headerId.filtter)
        }else{
            onlineModelListFilter.type = headerId.filtter
        }
    }

    width: parent.width
    height: fillterBox.height
    clip:true

    signal search(var text)

    Row{
        id: fillterBox
        width: parent.width
        spacing: 10
        SearchButton{
            id: searchBoxId
            width: parent.width - companyList.width - viewList.width - 20 - 10
            Connections{
                target: searchBoxId
                function onSearch(myText){
                    onlineModelListFilter.setFilterFixedString(myText)
                }
            }
        }
        Row{
            height: searchBoxId.height
            spacing: 10

            MyComboBox {
                id: companyList
                width: 110
                model: [
                    "All",
                    "Favorite",
                    "Text Generation",
                    "Image",
                    "Vision",
                    "Embeddings"
                ]
                displayText: headerId.filtter
                onActivated: {
                    var selectedType = model[currentIndex]
                    if(selectedType ==="All" || selectedType ==="Favorite"){
                        onlineModelListFilter.filter(selectedType)
                    }else{
                        onlineModelListFilter.type = selectedType
                    }
                    headerId.filtter= selectedType
                }
            }

            ListView{
                id: viewList
                width: viewList.contentWidth
                height: parent.height
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
}
