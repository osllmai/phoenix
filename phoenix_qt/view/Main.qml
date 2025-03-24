import QtQuick
import QtCore
import QtQuick.Controls.Basic
import './component_library/style' as Style

ApplicationWindow {
    id: window
    width: 1700; height: 900
    minimumWidth: 400; minimumHeight: 400
    color: Style.Colors.background

    property string theme: "Light"
    onThemeChanged: {
        Style.Colors.theme = window.theme
    }

    font.family: "Times New Roman"

    Settings{
        category: "window"
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
        property alias theme: window.theme
        property alias fontFamily: window.font.family
    }


    visible: true
    title: qsTr("Phoenix")    

    function isDesktopSize(){
        if(width<550)
            return false;
        return true;
    }

    Item{
        anchors.fill:parent
        anchors.margins: 0
        AppMenu{
            id:appMenuDesktopId
            visible: window.isDesktopSize()
            clip:true
            Behavior on width {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }
        }
        Column{
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: window.isDesktopSize()? appMenuDesktopId.right: parent.left
            anchors.right: parent.right
            AppBody{
                id:appBodyId
                width: parent.width; height: parent.height -appFooter.height
                clip:true
            }
            AppFooter{
                id: appFooter
            }
        }
    }
    Rectangle{
        id:line
        width: parent.width; height: 1
        color: Style.Colors.boxBorder
        anchors.top: parent.top
    }
}
