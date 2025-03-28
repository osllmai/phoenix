import QtQuick 2.15
import '../../../../component_library/style' as Style
import '../../../../component_library/button'

Item {
    id:control
    height: 40; width: parent.width
    property var myText
    property bool isOpen

    signal open()
    function selectIcon(){
        if(isOpen){
            if(searchIcon.hovered){
                return "qrc:/media/icon/upFill.svg";
            }else{
                return "qrc:/media/icon/up.svg";
            }
        }else{
            if(searchIcon.hovered){
                return "qrc:/media/icon/downFill.svg";
            }else{
                return "qrc:/media/icon/down.svg";
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
        MyIcon {
            id: searchIcon
            myIcon: control.selectIcon()
            iconType: Style.RoleEnum.IconType.Primary
            enabled: false
            onClicked:{
                control.open()
            }
        }
    }
}

