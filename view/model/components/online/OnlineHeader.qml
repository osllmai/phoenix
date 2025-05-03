import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

Item{
    id:headerId
    width: parent.width
    height: phoenixId.height + fillterBox.height  + 18
    clip:true
    signal search(var text)

    property string filtter: "All"

    Column{
        id: columnId
        anchors.fill: parent
        anchors.leftMargin: 30
        spacing: 10
        Label {
            id: phoenixId
            text: qsTr("Online Model")
            color: Style.Colors.textTitle
            font.pixelSize: 20
            font.styleName: "Bold"
        }

        Row{
            id: fillterBox
            width: parent.width
            spacing: 10
            SearchButton{
                id: searchBoxId
                Connections{
                    target: searchBoxId
                    function onSearch(myText){
                        onlineModelListFilter.setFilterFixedString(myText)
                    }
                }
            }
            Item{
                width: parent.width - searchBoxId.width - 30
                height: searchBoxId.height + 20

                ListView{
                    id: companyList
                    anchors.fill: parent
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
                            name: "Embeddings"
                            type: "Embeddings"
                        }
                        ListElement {
                            name: "Vision"
                            type: "Vision"
                        }
                        ListElement {
                            name: "Image"
                            type: "Image"
                        }
                        ListElement {
                            name: "Chat"
                            type: "Text Generation"
                        }
                    }
                    delegate: MyButton {
                        id: delegateId
                        myText: model.name
                        bottonType: Style.RoleEnum.BottonType.Feature
                        iconType: Style.RoleEnum.IconType.FeatureBlue
                        isNeedAnimation: true
                        onClicked:{
                            onlineModelListFilter.type = model.type
                            headerId.filtter= model.type
                        }
                        checkable: true
                        checked: headerId.filtter === model.type
                    }

                    footer: Row {
                        MyButton {
                            id: allId
                            myText: "All"
                            bottonType: Style.RoleEnum.BottonType.Feature
                            iconType: Style.RoleEnum.IconType.FeatureBlue
                            isNeedAnimation: true
                            onClicked: {
                                onlineModelListFilter.filter("All")
                                headerId.filtter= "All"
                            }
                            checkable: true
                            checked: headerId.filtter === "All"
                        }

                        MyButton {
                            id: favoriteId
                            myText: "Favorite"
                            bottonType: Style.RoleEnum.BottonType.Feature
                            iconType: Style.RoleEnum.IconType.FeatureBlue
                            isNeedAnimation: true
                            onClicked: {
                                onlineModelListFilter.filter("Favorite")
                                headerId.filtter = "Favorite"
                            }
                            checkable: true
                            checked: headerId.filtter === "Favorite"
                        }
                    }
                }
            }
        }
    }
}
