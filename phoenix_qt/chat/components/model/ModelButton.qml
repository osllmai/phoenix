import QtQuick 2.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

Item {
    id:control
    height: 40; width: logoButton.width + inferenceSettingsTextId.width + openButton.width + 20
    property var myText: " Model Name"
    property bool isOpen: true

    signal open()
    function selectIcon(){
        if(isOpen){
            if(openButton.hovered){
                return "../../../media/icon/upFill.svg";
            }else{
                return "../../../media/icon/up.svg";
            }
        }else{
            if(openButton.hovered){
                return "../../../media/icon/downFill.svg";
            }else{
                return "../../../media/icon/down.svg";
            }
        }
    }

    Row{
        anchors.fill: parent
        MyIcon {
            id: logoButton
            myIcon: control.selectIcon()
            iconType: Style.RoleEnum.IconType.Primary
            isNeedHover: false
            Connections {
                target: logoButton
                function onActionClicked(){
                    control.open()
                }
            }
        }
        Text {
            id: inferenceSettingsTextId
            // width: parent.width - logoButton.width - openButton.width ; height: parent.height
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
            id: openButton
            myIcon: control.selectIcon()
            iconType: Style.RoleEnum.IconType.Primary
            isNeedHover: false
            Connections {
                target: openButton
                function onActionClicked(){
                    control.open()
                }
            }
        }
    }
}

