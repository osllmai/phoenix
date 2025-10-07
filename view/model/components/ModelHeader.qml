import QtQuick 2.15
import "../../component_library/button"
import '../../component_library/style' as Style
import "../../menu"

Item{
    id:headerId
    width: window.isDesktopSize? 385: 220; height: 60
    clip:true

    function setModelPages(page){
        if(page === "offline"){
            offlineModel.clicked()
            offlineModel.checked = true
            onlineModel.checked = false
        }else if(page === "online"){
            onlineModel.clicked()
            onlineModel.checked = true
            offlineModel.checked = false
        }
    }

    MyOpenMenuButton{
        id: openMenuId
        anchors.left:parent.left; anchors.leftMargin: 12
        anchors.top: parent.top; anchors.topMargin: 12
    }

    Row{
        spacing: 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top; anchors.topMargin: 12
        anchors.left: openMenuId.right; anchors.leftMargin: 5
        MyMenu {
            id: offlineModel
            myText: window.isDesktopSize? "Local": ""
            myIcon: "qrc:/media/icon/offline.svg"
            autoExclusive: true
            checked: true
            Connections {
                target: offlineModel
                function onClicked(){
                    modelBodyId.currentIndex = 0
                }
            }
        }
        MyMenu {
            id: onlineModel
            myText: window.isDesktopSize? "Online": ""
            myIcon: "qrc:/media/icon/online.svg"
            autoExclusive: true
            Connections {
                target: onlineModel
                function onClicked(){
                    modelBodyId.currentIndex = 1
                }
            }
        }
        MyMenu {
            id: huggingfaceModel
            myText: window.isDesktopSize? "Huggingface": ""
            myIcon: "qrc:/media/image_company/Huggingface.svg"
            iconType: Style.RoleEnum.IconType.Image
            autoExclusive: true
            Connections {
                target: huggingfaceModel
                function onClicked(){
                    modelBodyId.currentIndex = 2
                }
            }
        }
    }
}
