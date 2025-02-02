import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style
import '../../../../component_library/button'

Item{
    id:headerId
    height: 110; width: parent.width
    clip:true
    signal search(var text)
    signal closeDialog()
    signal currentPage(int numberPage)

    Column{
        spacing: 8
        anchors.fill: parent
        Row{
            height: 35
            spacing: parent.width - inDoxId.width - closeBox.width
            Text {
                id: inDoxId
                text: qsTr("Model Settings")
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
                        source: "../../../../media/icon/close.svg"
                        color: searchIcon.hovered? Style.Colors.iconHoverAndChecked: Style.Colors.iconNormal
                        width: searchIcon.width; height: searchIcon.height
                    }
                    MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked:{headerId.closeDialog()}
                    }
                }
            }
        }
        Row{
            width: parent.width
            spacing: 10
            MyMenu{
                id: assistantMenuId
                myText: "Assistant"
                myIcon: "../../media/icon/close.svg"
                myFillIcon: "../../media/icon/close.svg"
                checked: true
                autoExclusive: true
                Connections {
                    target: assistantMenuId
                    function onClicked(){
                        headerId.currentPage(0)
                        showSelectMenuId.x = assistantMenuId.x
                    }
                }
            }
            MyMenu{
                id: modelMenuId
                myText: "Model"
                myIcon: "../../media/icon/close.svg"
                myFillIcon: "../../media/icon/close.svg"
                checked: false
                autoExclusive: true
                Connections {
                    target: modelMenuId
                    function onClicked(){
                        headerId.currentPage(1)
                        showSelectMenuId.x = modelMenuId.x
                    }
                }
            }
        }
    }
    Rectangle{
        id: showSelectMenuId
        color: Style.Colors.menuShowCheckedRectangle
        width: assistantMenuId.width
        height: 3
        radius: 300
        x: assistantMenuId.x
        y: assistantMenuId.y + assistantMenuId.height + 35 + 8

        Behavior on x{
            NumberAnimation{
                duration: 200
            }
        }
    }
}
