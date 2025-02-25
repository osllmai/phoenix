import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "./components"
import '../../../component_library/style' as Style

Dialog{
    id: control
    width: 300
    height: 400
    signal closeDialog()
    background: Rectangle {
        color: Style.Colors.background
        anchors.fill: parent
        border.width: 1
        border.color: Style.Colors.boxBorder
        radius: 8
        Column{
            anchors.fill: parent
            anchors.margins: 12
            ModelDialogHeader{
                id: headerId
                Connections{
                    target: headerId
                    function onSearch(myText){}
                    function onCloseDialog(){
                        control.closeDialog()
                    }
                    function onCurrentPage(numberPage){
                        badyId.currentIndex = numberPage;
                    }
                }
            }
            ModelDialogBody{
                id: badyId
                height: parent.height - headerId.height
                width: parent.width
            }
        }
        layer.enabled: true
        layer.effect: Glow {
             samples: 40
             color:  Style.Colors.boxBorder
             spread: 0.1
             transparentBorder: true
         }
    }
}
