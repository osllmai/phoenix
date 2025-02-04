import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import "../../../component_library/button"

Item{
    id:headerId
    height: 90; width: parent.width
    clip:true
    signal search(var text)
    signal closeDrawer()
    Column{
        spacing: 8
        anchors.fill: parent
        Row{
            height: 35
            spacing: parent.width - inDoxId.width - closeBox.width
            Text {
                id: inDoxId
                text: qsTr("History")
                color: Style.Colors.textTitle
                font.pixelSize: 20
                font.styleName: "Bold"
            }
            Item{
                id: closeBox
                width: 35; height: 35
                ToolButton {
                    id: searchIcon
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:searchIcon.hovered? 35: 30; height: searchIcon.hovered? 35: 30
                    Behavior on width{ NumberAnimation{ duration: 150}}
                    Behavior on height{ NumberAnimation{ duration: 150}}
                    background: null
                    icon{
                        source: "qrc:/media/icon/close.svg"
                        color: searchIcon.hovered? Style.Colors.iconHoverAndChecked: Style.Colors.iconNormal
                        width: searchIcon.width; height: searchIcon.height
                    }
                    MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked:{headerId.closeDrawer()}
                    }
                }
            }
        }
        SearchButton{
            id: searchBoxId
            width: parent.width
            Connections{
                target: searchBoxId
                function onSearch(mytext){
                    headerId.search(mytext)
                }
            }
        }
    }
}
