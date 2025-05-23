import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "./components"
import '../style' as Style
import '../button'

Rectangle {
    id: modelSelectViewId

    property bool modelSelect: false
    property int modelId: -1
    property string modelName: "Phoenix"
    property string modelIcon: "qrc:/media/image_company/Phoenix.png"
    signal setModelRequest(int id, string name, string icon, string promptTemplate, string systemPrompt)

    color: Style.Colors.background
    anchors.fill: parent
    border.width: 1
    border.color: Style.Colors.boxBorder
    radius: 12
    Column{
         anchors.fill: parent
         anchors.margins: 12
         spacing: 10
         ModelSelectHeader{
             id: headerId
             Connections{
                 target: headerId
                 function onSearch(myText){}
                 function onCurrentPage(numberPage){
                     badyId.currentIndex = numberPage;
                 }
             }
         }
         ModelSelectBody{
             id: badyId
             height: parent.height - headerId.height - 10
             width: parent.width
         }
    }
}
