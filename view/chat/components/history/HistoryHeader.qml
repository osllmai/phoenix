import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import "../../../component_library/button"

Item{
    id:headerId
    height: 90; width: parent.width
    clip:true
    Column{
        spacing: 8
        anchors.fill: parent
        Row{
            height: 35
            spacing: parent.width - titleId.width - closeBox.width
            Label {
                id: titleId
                text: qsTr("History")
                color: Style.Colors.textTitle
                font.pixelSize: 20
                font.styleName: "Bold"
            }
            MyIcon{
                id: closeBox
                width: 30; height: 30
                myIcon: "qrc:/media/icon/close.svg"
                myTextToolTip: "Close"
                isNeedAnimation: true
                onClicked: drawerId.close()
            }
        }
        SearchButton{
            id: searchBoxId
            width: parent.width
            Connections{
                target: searchBoxId
                function onSearch(myText){
                    conversationListFilter.setFilterFixedString(myText)
                }
            }
        }
    }
}
