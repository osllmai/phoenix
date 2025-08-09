import QtQuick 2.15
import "../../component_library/button"
import "../../menu"

Rectangle{
    id:headerId
    width: window.isDesktopSize? 350: 120; height: 60
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
        anchors.left:parent.left; anchors.leftMargin: 24
        anchors.top: parent.top; anchors.topMargin: 12
    }

    Row{
        spacing: 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top; anchors.topMargin: 12
        MyMenu {
            id: offlineModel
            myText: window.isDesktopSize? "Offline Provider": ""
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
            myText: window.isDesktopSize? "Online Provider": ""
            myIcon: "qrc:/media/icon/online.svg"
            autoExclusive: true
            Connections {
                target: onlineModel
                function onClicked(){
                    modelBodyId.currentIndex = 1
                }
            }
        }
    }
}
