import QtQuick
import Phoenix

RelationHandle {
    width: 30
    height: 30

    Rectangle {
        width: 2
        height: 10

        color: 'gray'
        anchors.centerIn: parent
        visible: parent.state == RelationHandle.Connected
    }


    Rectangle {
        width: 10
        height: 10
        radius: 5

        color: 'white'
        border.color: 'gray'
        anchors.centerIn: parent
        visible: parent.state == RelationHandle.UnConnected
    }
}
