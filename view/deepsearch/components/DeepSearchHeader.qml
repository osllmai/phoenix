import QtQuick 2.15
import "../../component_library/button"
import '../../component_library/style' as Style
import "../../menu"

Item{
    id:headerId

    property string filtter: "Scientific article"
    onFiltterChanged: {

    }

    width: parent.width
    height: 55
    clip:true

    signal search(var text)

    Row{
        id: fillterBox
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Item{
            height: 35
            width: parent.width -  companyList.width - viewList.width - 20 - 10
            SearchButton{
                id: searchBoxId
                width: parent.width
                height: 35
                Connections{
                    target: searchBoxId
                    function onSearch(myText){
                        arxivModel.searchQuery = myText
                    }
                }
            }
        }

        MyComboBox {
            id: companyList
            width: 160
            model: [
                "Scientific article", "Video & Image", "Statistical data","Blog & News"
            ]
            displayText: headerId.filtter
            onActivated: {
                var selectedType = model[currentIndex]



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
