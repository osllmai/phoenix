import QtQuick 2.15
import QtQuick.Layouts

StackLayout {
    id: page
    currentIndex: 0

    Rectangle {
        id: homePage
        radius: 4
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: "red"
    }

    Rectangle {
        id: chatPage
        radius: 4
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: "blue"
    }

    Rectangle {
        id: modelsPage
        radius: 4
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: "black"
    }
}
