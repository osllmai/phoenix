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

    // Rectangle {
    //     anchors.fill: parent
    //     color: Style.Colors.background
    // }

    // Row {
    //     anchors.verticalCenter: parent.verticalCenter
    //     anchors.right: parent.right
    //     spacing: 10
    //     padding: 10

    //     Button {
    //         text: "-"
    //         onClicked: window.showMinimized()
    //     }
    //     Button {
    //         text: "□"
    //         onClicked: {
    //             window.visibility = window.visibility === Window.Maximized ? Window.Windowed : Window.Windowed
    //         }
    //     }
    //     Button {
    //         text: "X"
    //         onClicked: Qt.quit()
    //     }
    // }

    // MouseArea {
    //     anchors.fill: parent
    //     drag.target: window
    // }
}
