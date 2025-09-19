import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'
import './components'

Item{
    id:headerId

    width: parent.width
    height: /*fillterBox.height*/35
    clip:true

    signal search(var text)


    Row{
        id: fillterBox
        width: parent.width
        spacing: 10

        Item{
            id: searchAreaId
            height: 35
            width: parent.width  - viewList.width - 20 - 10
            SearchHuggingfaceModel{
                id: searchBoxId
                width: Math.min(parent.width , 550)
                anchors.horizontalCenter: parent.horizontalCenter
                Connections{
                    target: searchBoxId
                    function onSearch(myText){
                        huggingfaceModelListFilter.setFilterFixedString(myText)
                    }
                }
            }
        }

        ListView{
            id: viewList
            anchors.verticalCenter: searchAreaId.verticalCenter
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
                width: /*searchBoxId.height*/ 30; height: /*searchBoxId.height*/30
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
