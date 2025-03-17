import QtQuick 2.15
import "../../component_library/button"

Item{
    id:headerId
    width: parent.width; height: 90
    clip:true

    Row{
        spacing: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        MyMenu {
            id: offlineModel
            myText: "Offline Model"
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
            myText: "Online Model"
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
