import QtQuick
import QtQuick.Controls
import "./components"
import '../../../component_library/style' as Style

Dialog{
    id: control
    width: 330
    height: 400
    signal closeDialog()
    background: null
    Rectangle {
        color: Style.Colors.boxNormalGradient0
        anchors.fill: parent
        border.width: 0
        radius: 8
        Column{
            anchors.fill: parent
            anchors.margins: 16
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
            }
        }
    }
}
