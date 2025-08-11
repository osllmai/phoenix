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
    property bool isSearchInColumn: window.isDesktopSize

    width: parent.width
    height: fillterBox.height + (headerId.isSearchInColumn? 0: searchBox2Id.height)
    clip:true

    signal search(var text)

    Column{
        id: columnId
        anchors.fill: parent
        anchors.leftMargin: 10
        spacing: 10
        // SearchButton{
        //     id: searchBox2Id
        //     visible: !headerId.isSearchInColumn
        //     Connections{
        //         target: searchBoxId
        //         function onSearch(myText){
        //             offlineModelListFilter.setFilterFixedString(myText)
        //         }
        //     }
        // }

        SearchOfflineModel{
            id: searchBox2Id
            visible: !headerId.isSearchInColumn
        }

        Row{
            id: fillterBox
            width: parent.width
            spacing: 20
            // SearchButton{
            //     id: searchBoxId
            //     width: parent.width - companyList.width - viewList.width - 20 - 10
            //     visible: headerId.isSearchInColumn
            //     Connections{
            //         target: searchBoxId
            //         function onSearch(myText){
            //             offlineModelListFilter.setFilterFixedString(myText)
            //         }
            //     }
            // }

            SearchOfflineModel{
                id: searchBoxId
                width: parent.width - companyList.width - viewList.width - 20 - 10
                visible: headerId.isSearchInColumn
            }

            Row{
                height: searchBoxId.height
                spacing: 10

                MyComboBox {
                    id: companyList
                    width: 130
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

                // ListView{
                //     id: companyList
                //     width: companyList.contentWidth
                //     height: parent.height
                //     spacing: 5
                //     cacheBuffer: Math.max(0, companyList.contentWidth)

                //     layoutDirection: Qt.RightToLeft
                //     orientation: Qt.Horizontal
                //     snapMode: ListView.SnapToItem

                //     interactive: contentWidth > width
                //     boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

                //     ScrollBar.horizontal: ScrollBar {
                //         policy: ScrollBar.AsNeeded
                //     }
                //     clip: true

                //     model: ListModel {
                //         ListElement {
                //             name: "Speech"
                //             type: "Speech"
                //         }
                //         ListElement {
                //             name: "Chat"
                //             type: "Text Generation"
                //         }
                //         ListElement {
                //             name: "Favorite"
                //             type: "Favorite"
                //         }
                //         ListElement {
                //             name: "All"
                //             type: "All"
                //         }
                //     }
                //     delegate: MyButton {
                //         id: delegateId
                //         myText: model.name
                //         height: searchBoxId.height
                //         bottonType: Style.RoleEnum.BottonType.Feature
                //         iconType: Style.RoleEnum.IconType.FeatureBlue
                //         isNeedAnimation: true
                //         checkable: true
                //         checked: headerId.filtter === model.type
                //         selected: headerId.filtter === model.type
                //         onClicked:{
                //             if(model.type ==="All" || model.type ==="Favorite"){
                //                 offlineModelListFilter.filter(model.type)
                //             }else{
                //                 offlineModelListFilter.type = model.type
                //             }
                //             headerId.filtter= model.type
                //         }
                //     }
                // }

                ListView{
                    id: viewList
                    width: viewList.contentWidth
                    height: parent.height
                    spacing: 5
                    // cacheBuffer: Math.max(0, viewList.contentWidth)

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
                        width: searchBoxId.height; height: searchBoxId.height
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
