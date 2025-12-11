import QtQuick 2.15
import "./components"
import '../../../component_library/style' as Style
import '../../../component_library/button'

Item{
    Rectangle {
        anchors.fill: parent
        anchors.rightMargin: 40
        anchors.bottomMargin: 10
        color: Style.Colors.background
        border.width: 1
        border.color: Style.Colors.boxBorder
        radius: 8
        Column{
            anchors.fill: parent
            anchors.margins: 8
            LogMessageHeader{
                id: headerId
                Connections{
                    target: headerId
                    function onCurrentPage(numberPage){
                        badyId.currentIndex = numberPage;
                    }
                }
            }
            LogMessageBody{
                id: badyId
                height: parent.height - headerId.height
                width: parent.width
            }
        }
    }
}
