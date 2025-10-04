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
    height:/* fillterBox.height*/35
    clip:true

    signal search(var text)

    Row{
        anchors.right: parent.right
        width: viewList.width + botton.width +10
        height: parent.height
        spacing: 10

        MyButton {
            id: botton
            height: 30
            myText: "Buy API Key"
            myIcon: "qrc:/media/image_company/indoxRoter.png"
            iconType: Style.RoleEnum.IconType.Image
            bottonType: Style.RoleEnum.BottonType.Primary
            anchors.verticalCenter: viewList.verticalCenter
            onClicked: {
                Qt.openUrlExternally("https://indoxrouter.com/en-US/keys")
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
