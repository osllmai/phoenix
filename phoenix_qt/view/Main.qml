import QtQuick
import QtQuick.Controls.Basic
import './component_library/style' as Style

ApplicationWindow {
    id: window
    width: 1700; height: 900
    minimumWidth: 400; minimumHeight: 400
    color: Style.Colors.background

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
        AppMenuDesktop{
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
            anchors.bottom: window.isDesktopSize()? parent.bottom: appMenuApplicationId.top
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
        AppMenuAplication{
            id:appMenuApplicationId
            visible: !window.isDesktopSize()
            Connections{
                target: appMenuApplicationId
                function onCurrentPage(numberPage){
                    appBodyId.currentIndex = numberPage;
                }
            }
            Behavior on width {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
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
