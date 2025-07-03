import QtQuick 2.15
import '../style' as Style

MyIcon {
    id: copyId
    myIcon: copyId.selectIcon()
    iconType: Style.RoleEnum.IconType.Primary
    width: 26; height: 26

    property var myText
    property bool checkCopy: false

    Connections{
        target: copyId
        function onClicked(){
            myText.selectAll()
            myText.copy()
            myText.deselect()
            copyId.checkCopy= true
            successTimer.start();
        }
    }

    Timer {
        id: successTimer
        interval: 1000
        repeat: false
        onTriggered: copyId.checkCopy = false
    }

    function selectIcon(){
        if(copyId.checkCopy === false){
            return copyId.hovered? "qrc:/media/icon/copyFill.svg": "qrc:/media/icon/copy.svg"
        }else{
            return copyId.hovered? "qrc:/media/icon/copySuccessFill.svg": "qrc:/media/icon/copySuccess.svg"
        }
    }
}
