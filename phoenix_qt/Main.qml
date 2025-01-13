import QtQuick
import QtQuick.Controls.Basic
import './menu'

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
        AppMenu{id:appMenuId}
    }
}
