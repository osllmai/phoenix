import QtQuick 2.15
import QtQuick.Layouts
import "./home"

StackLayout {
    id: page
    currentIndex: 0

    HomeView{id: homeViewId}

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
