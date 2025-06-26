import QtQuick
import QtQuick.Templates 2.1 as T
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import './component_library/style' as Style
import './component_library/button'

Item {
    id: customTitleBar
    width: parent.width
    height: 40

    Rectangle {
        anchors.fill: parent
        color: Style.Colors.background
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        spacing: 10
        padding: 10

        Button {
            text: "-"
            onClicked: window.showMinimized()
        }
        Button {
            text: "□"
            onClicked: {
                window.showFullScreen()
            }
        }
        Button {
            text: "X"
            onClicked: Qt.quit()
        }
    }

    // MouseArea {
    //     anchors.fill: parent
    //     property var clickPos: Qt.point(0, 0)

    //     onPressed: function(mouse) {
    //         clickPos = Qt.point(mouse.x, mouse.y)
    //     }

    //     onPositionChanged: function(mouse) {
    //         var dx = mouse.x - clickPos.x
    //         var dy = mouse.y - clickPos.y
    //         window.x += dx
    //         window.y += dy
    //     }
    // }


}
