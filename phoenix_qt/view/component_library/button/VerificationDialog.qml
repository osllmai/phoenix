import QtQuick 2.15
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import '../style' as Style

Dialog {
    id: dialogId
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: 300
    height: 200

    property var titleText
    property var about

    signal buttonAction1()
    signal buttonAction2()

    property var textBotton1
    property var textBotton2

    focus: true
    modal: true

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        color: Style.Colors.overlay
    }

    background: null
    contentItem:Rectangle{
        id: backgroundId
        anchors.fill: parent

        radius: 10
        border.width: 1
        border.color: Style.Colors.boxBorder
        color: Style.Colors.background

        Column{
            anchors.fill: parent
            anchors.margins: 16
            Row{
                id: titleBoxId
                height: 35
                spacing: parent.width - titleId.width - closeBox.width
                Text {
                    id: titleId
                    text: dialogId.titleText
                    color: Style.Colors.textTitle
                    font.pixelSize: 20
                    font.styleName: "Bold"
                    anchors.verticalCenter: closeBox.verticalCenter
                }
                Item{
                    id: closeBox
                    width: 35; height: 35
                    ToolButton {
                        id: searchIcon
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        width:searchIcon.hovered? 35: 30; height: searchIcon.hovered? 35: 30
                        Behavior on width{ NumberAnimation{ duration: 150}}
                        Behavior on height{ NumberAnimation{ duration: 150}}
                        background: null
                        icon{
                            source: "qrc:/media/icon/close.svg"
                            color: searchIcon.hovered? Style.Colors.iconHoverAndChecked: Style.Colors.iconNormal
                            width: searchIcon.width; height: searchIcon.height
                        }
                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked:{dialogId.close()}
                        }
                    }
                }
            }
            Text {
                id: informationId
                text: dialogId.about
                color: Style.Colors.textInformation
                clip: true
                width: parent.width
                // height: parent.height - buttonBoxId.height - titleBoxId.height
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
            }
            Row{
                id: buttonBoxId
                spacing: 5
                anchors.right: parent.right

                MyButton{
                    id: botton1
                    myText: dialogId.textBotton1
                    bottonType: Style.RoleEnum.BottonType.Secondary
                    onClicked:{
                       buttonAction1()
                    }
                }
                MyButton{
                    id: botton2
                    myText: dialogId.textBotton2
                    bottonType: Style.RoleEnum.BottonType.Danger
                    onClicked:{
                        buttonAction2()
                    }
                }
            }
        }
    }
}
