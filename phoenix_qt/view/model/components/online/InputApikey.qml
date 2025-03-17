import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import '../../../component_library/style' as Style
import '../../../component_library/button'

Rectangle{
    id: control
    height: 32; width: parent.width
    color: Style.Colors.boxNormalGradient0
    border.width: 1
    border.color: Style.Colors.boxBorder
    radius: 8

    signal saveAPIKey(var text)
    Row{
        anchors.fill: parent
        TextArea {
            id: textArea
            text: model.key
            width: parent.width - iconId.width
            anchors.verticalCenter: iconId.verticalCenter
            hoverEnabled: true
            selectionColor: Style.Colors.boxNormalGradient1
            cursorVisible: false
            persistentSelection: true
            placeholderText: qsTr("Enter Apikey")
            placeholderTextColor: Style.Colors.menuNormalIcon
            color: Style.Colors.menuNormalIcon
            font.pointSize: 10
            wrapMode: TextEdit.NoWrap
            background: null
            Keys.onReturnPressed: (event)=> {
              if (event.modifiers & Qt.ControlModifier || event.modifiers & Qt.ShiftModifier){
                event.accepted = false;
              }else {
                    control.saveAPIKey(textArea.text)
                    // textArea.text = ""
              }
            }
        }
        MyIcon {
            id: iconId
            anchors.verticalCenter: parent.verticalCenter
            myIcon: iconId.hovered? "qrc:/media/icon/sendFill.svg": "qrc:/media/icon/send.svg"
            iconType: Style.RoleEnum.IconType.Primary
            width: 28; height: 28
            onClicked: {
                control.saveAPIKey(textArea.text)
            }
        }
    }

    layer.enabled: false
    layer.effect: Glow {
         samples: 40
         color:  Style.Colors.boxBorder
         spread: 0.1
         transparentBorder: true
     }
}
