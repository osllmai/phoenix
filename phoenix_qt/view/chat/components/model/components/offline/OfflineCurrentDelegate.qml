import QtQuick 2.15
import QtQuick.Controls 2.15
import "../"

Item {
    id: control
    clip:true

    Column{
        anchors.fill: parent
        CompanyMenu{
            id: componyId
            myText: "Compony Name"
        }

        OfflineCurrentModelList{
            id: currentModelListForThisComponyId
        }
    }
}
