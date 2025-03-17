import QtQuick 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

Item{
    id:headerId
    width: parent.width
    height: phoenixId.height + fillterBox.height  + 18
    clip:true
    signal search(var text)
    Column{
        id: columnId
        anchors.fill: parent
        anchors.leftMargin: 30
        spacing: 10
        Text {
            id: phoenixId
            text: qsTr("Online Model")
            color: Style.Colors.textTitle
            font.pixelSize: 20
            font.styleName: "Bold"
        }

        Row{
            id: fillterBox
            width: parent.width
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
                height: parent.height

                ListView{
                    id: companyList
                    anchors.fill: parent
                    layoutDirection: Qt.RightToLeft
                    orientation: Qt.Horizontal
                    snapMode: ListView.SnapToItem

                    interactive: contentWidth > width
                    boundsBehavior: interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

                    model: onlineCompanyList
                    delegate: MyButton {
                        id: delegateId
                        myText: model.name
                        myIcon: "qrc:/media/image_company/" + model.icon
                        bottonType: Style.RoleEnum.BottonType.Feature
                        iconType: Style.RoleEnum.IconType.Image
                        isNeedAnimation: true
                        onClicked:{
                            onlineModelListFilter.companyId = model.id
                        }
                    }

                    footer: Row {
                        spacing: 10
                        MyButton {
                            id: allId
                            myText: "All"
                            bottonType: Style.RoleEnum.BottonType.Feature
                            iconType: Style.RoleEnum.IconType.FeatureBlue
                            isNeedAnimation: true
                            onClicked: {
                                onlineModelListFilter.filter("All")
                            }
                        }

                        MyButton {
                            id: favoriteId
                            myText: "Favorite"
                            bottonType: Style.RoleEnum.BottonType.Feature
                            iconType: Style.RoleEnum.IconType.FeatureBlue
                            isNeedAnimation: true
                            onClicked: {
                                onlineModelListFilter.filter("Favorite")
                            }
                        }
                    }
                }
            }
        }
    }
}
