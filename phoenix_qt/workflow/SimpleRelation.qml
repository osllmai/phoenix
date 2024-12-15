import QtQuick
import QtQuick.Controls
import Phoenix

CurvedRelation {
    color: 'gray'

    signal addClicked()

    Button {
        id: btn
        width: 30
        height: 30
        // radius: 15
        // flat: true
        text: '+'
        anchors.centerIn: parent

        onClicked: addClicked()
        // background: Rectangle {
        //     radius: width / 2
        //     border.color: btn.hovered ? 'gray' : 'lightgray'
        // }
    }
}
