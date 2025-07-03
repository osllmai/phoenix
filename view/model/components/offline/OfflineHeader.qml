import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

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
    property bool isSearchInColumn: window.isDesktopSize

    width: parent.width
    height: phoenixId.height + fillterBox.height + (headerId.isSearchInColumn? 0: searchBox2Id.height + 10)
    clip:true

    signal search(var text)

    Column{
        id: columnId
        anchors.fill: parent
        anchors.leftMargin: 30
        spacing: 10
        Label {
            id: phoenixId
            text: qsTr("Offline Model")
            color: Style.Colors.textTitle
            font.pixelSize: 20
            font.styleName: "Bold"
        }

        SearchButton{
            id: searchBox2Id
            visible: !headerId.isSearchInColumn
            Connections{
                target: searchBoxId
                function onSearch(myText){
                    offlineModelListFilter.setFilterFixedString(myText)
                }
            }
        }

        Row{
            id: fillterBox
            width: parent.width
            spacing: 10
            SearchButton{
                id: searchBoxId
                visible: headerId.isSearchInColumn
                Connections{
                    target: searchBoxId
                    function onSearch(myText){
                        offlineModelListFilter.setFilterFixedString(myText)
                    }
                }
            }
            Column{
                width: headerId.isSearchInColumn? parent.width - searchBoxId.width - 40: parent.width - 20
                height: 2*searchBoxId.height + 20

                Item{
                    width: parent.width
                    height: searchBoxId.height +10

                    ListView{
                        id: companyList
                        anchors.fill: parent
                        spacing: 5
                        cacheBuffer: Math.max(0, companyList.contentWidth)

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
                                name: "Speech"
                                type: "Speech"
                            }
                            ListElement {
                                name: "Chat"
                                type: "Text Generation"
                            }
                            ListElement {
                                name: "Favorite"
                                type: "Favorite"
                            }
                            ListElement {
                                name: "All"
                                type: "All"
                            }
                        }
                        delegate: MyButton {
                            id: delegateId
                            myText: model.name
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
                Item{
                    width: parent.width
                    height: searchBoxId.height + 10

                    ListView{
                        id: viewList
                        anchors.fill: parent
                        spacing: 5
                        cacheBuffer: Math.max(0, viewList.contentWidth)

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
    }
}
