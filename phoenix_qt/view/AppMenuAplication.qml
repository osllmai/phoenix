import QtQuick 2.15

Item{
    id: root
    height: 60
    anchors.left: parent.left; anchors.right: parent.right
    anchors.bottom: parent.bottom
    signal currentPage(int numberPage)

    Row {
        id: columnId
        anchors.fill: parent
        spacing: 0
        clip:true
    }
}
