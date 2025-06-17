import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import '../../../style' as Style
import '../../../button'

Item {
    id: root
    height: 30; width: parent.width

    property string myText
    property bool checkCopy: false

    Row{
        id: textEditor
        anchors.left: parent.left
        anchors.leftMargin: 0
        height: parent.height
        width: parent.width

        TextArea {
            id: textId
            text: root.myText
            color: Style.Colors.textTitle
            readOnly: true
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - copyId.width
            font.pointSize: 10
        }

        MyIcon {
            id: copyId
            myIcon: copyId.selectIcon()
            iconType: Style.RoleEnum.IconType.Primary
            width: 26; height: 26
            anchors.verticalCenter: parent.verticalCenter
            Connections{
                target: copyId
                function onClicked(){
                    textId.selectAll()
                    textId.copy()
                    textId.deselect()
                    root.checkCopy= true
                    successTimer.start();
                }
            }

            Timer {
                id: successTimer
                interval: 2000
                repeat: false
                onTriggered: root.checkCopy = false
            }

            function selectIcon(){
                if(root.checkCopy === false){
                    return copyId.hovered? "qrc:/media/icon/copyFill.svg": "qrc:/media/icon/copy.svg"
                }else{
                    return copyId.hovered? "qrc:/media/icon/copySuccessFill.svg": "qrc:/media/icon/copySuccess.svg"
                }
            }
        }
    }
}
