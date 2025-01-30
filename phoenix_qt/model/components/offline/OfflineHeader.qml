import QtQuick 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

Item{
    id:headerId
    width: parent.width
    height: phoenixId.height + fillterBox.height  + 10
    clip:true
    signal search(var text)
    Column{
        id: columnId
        anchors.fill: parent
        anchors.leftMargin: 30
        spacing: 10
        Text {
            id: phoenixId
            text: qsTr("Offline Model")
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
                    function onSearch(mytext){
                        headerId.search(mytext)
                    }
                }
            }
        }
    }
}
