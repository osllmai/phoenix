import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../../component_library/style' as Style

Item {
    id:control
    height: 40; width: parent.width
    property var myText
    property bool isOpen

    signal open()
    function selectIcon(){
        if(isOpen){
            if(searchIcon.hovered){
                return "../../../../media/icon/upFill.svg";
            }else{
                return "../../../../media/icon/up.svg";
            }
        }else{
            if(searchIcon.hovered){
                return "../../../../media/icon/downFill.svg";
            }else{
                return "../../../../media/icon/down.svg";
            }
        }
    }

    Row{
        anchors.fill: parent
        Text {
            id: inferenceSettingsTextId
            width: parent.width - searchIcon.width ; height: parent.height
            text: control.myText
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 10
            color: Style.Colors.textTitle
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked:{
                    control.open()
                }
            }
        }
        ToolButton {
            id: searchIcon
            height: parent.height; width: searchIcon.height
            background: null
            icon{
                source: control.selectIcon()
                color: searchIcon.hovered? Style.Colors.iconHoverAndChecked: Style.Colors.iconNormal
                width: 16; height: 16
            }
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked:{
                    control.open()
                }
            }
        }
    }
}
