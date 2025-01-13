import QtQuick
import QtQuick.Controls.Basic

ApplicationWindow {
    id: window
    width: 1229; height: 685
    minimumWidth: 450; minimumHeight: 600

    visible: true
    title: qsTr("Phoenix")

    Rectangle {
        id: phoenix
        anchors.fill: parent
        color: "#00ffffff"
        AppMenu{
            id:appMenuId
            anchors.top: parent.top; anchors.bottom: parent.bottom
            anchors.topMargin: 24; anchors.bottomMargin: 24;
            width: 70
            Connections{
                target: appMenuId
                function onCurrentPage(numberPage){
                    appBodyId.currentIndex = numberPage;
                }
            }
        }
        AppBody{
            id:appBodyId
            anchors.top: parent.top; anchors.bottom: parent.bottom
            anchors.left:appMenuId.right ; anchors.right: parent.right
            anchors.topMargin: 24; anchors.bottomMargin: 24;
            anchors.leftMargin: 0; anchors.rightMargin: 24;
        }
    }
}
