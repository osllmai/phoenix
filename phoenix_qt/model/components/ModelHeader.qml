import QtQuick 2.15
import "../../component_library/button"

Item{
    id:headerId
    clip:true

    signal currentPage(int numberPage)

    Row{
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        MyMenu {
            id: offlineModel
            myText: "Offline Model"
            myIcon: "../../media/icon/offline.svg"
            myFillIcon: "../../media/icon/offline.svg"
            autoExclusive: true
            checked: true

            Connections {
                target: offlineModel
                function onClicked(){
                    headerId.currentPage(0)
                }
            }
        }
        MyMenu {
            id: onlineModel
            myText: "Online Model"
            myIcon: "../../media/icon/online.svg"
            myFillIcon: "../../media/icon/online.svg"
            autoExclusive: true

            Connections {
                target: onlineModel
                function onClicked(){
                    headerId.currentPage(1)
                }
            }
        }
    }
}
