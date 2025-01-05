import QtQuick
import QtQuick.Layouts
import 'style' as Style

Item {
    id: root
    width: 200
    height: 200

    property var modelListModel
    signal goToModelPage()
    signal loadModelDialog(int indexModel)

    Rectangle{
        id: modelSettings
        anchors.fill:  parent
        color: Style.Theme.chatBackgroungColor
        border.color: Style.Theme.chatBackgroungColor
        radius:5
        visible: true

        gradient: Gradient {
            GradientStop {
                position: 0
                color: Style.Theme.chatBackgroungConverstationColor
            }

            GradientStop {
                position: 1
                color: Style.Theme.chatBackgroungColor
            }
            orientation: Gradient.Vertical
        }

        Rectangle {
            id: menuRecId
            width: parent.width
            height: 50
            color: "#00ffffff"

            Row{
                id: menuRowId
                anchors.fill: parent

                MyMenuSettings {
                    id: onDeviceId
                    width: (parent.width-10)/2
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 10
                    anchors.topMargin: 10
                    anchors.bottomMargin:  10
                    myTextId: "On-device"
                    checked: true
                    autoExclusive: true
                    Connections {
                        target: onDeviceId
                        function onClicked(){
                            modelSpaceStackId.currentIndex = 0
                            showSelectMenuId.x = menuRecId.x +10
                        }
                    }
                }
                MyMenuSettings {
                    id: cloudId
                    width: (parent.width-10)/2
                    anchors.left: onDeviceId.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 0
                    anchors.rightMargin: 10
                    anchors.topMargin: 10
                    anchors.bottomMargin:  10
                    myTextId: "Cloud"
                    checked: false
                    autoExclusive: true
                    Connections {
                        target: cloudId
                        function onClicked(){
                            modelSpaceStackId.currentIndex = 1
                            showSelectMenuId.x = menuRecId.x + 10 + (menuRecId.width-10)/2
                        }
                    }
                }
            }
            Rectangle{
                id: showSelectMenuId
                color: Style.Theme.fillIconColor
                height: 2
                width: (parent.width-30)/2
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                x: menuRecId.x +10

                Behavior on x{
                    NumberAnimation{
                        duration: 300
                    }
                }
            }
        }

        StackLayout {
            id: modelSpaceStackId
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: menuRecId.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            currentIndex: 0

            Rectangle {
                id: onDevicePage
                radius: 4
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "#00ffffff"

                Rectangle{
                    id: emptyModelListId
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: goToDownloadModelPageId.top
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                    color: "#00ffffff"
                    visible: root.modelListModel.size == 0
                    Text {
                        id: emptyModelText
                        color: "#919191"
                        text: qsTr("There is no model.")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: 10
                        font.family: "Times New Roman"
                    }
                }

                Rectangle{
                    id: modelListId
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: goToDownloadModelPageId.top
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                    color: "#00ffffff"
                    visible: root.modelListModel.size > 0
                    Rectangle{
                        id: rectangleListChat
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        anchors.topMargin: 10
                        anchors.bottomMargin: 10
                        color: "#00000000"

                        ListView {
                            id: historylist
                            anchors.fill: parent
                            model: root.modelListModel
                            spacing: 5

                            delegate: Rectangle{
                                id: delegateChat
                                width: historylist.width
                                height: 30
                                color: Style.Theme.normalButtonColor
                                radius: 5

                                Rectangle{
                                    id:recTexxt
                                    anchors.fill:parent
                                    color: "#00ffffff"
                                    Text {
                                        id:  textId
                                        color: Style.Theme.chatMessageInformationTextColor
                                        text: model.name
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.left: modelIconBox.right
                                        anchors.leftMargin: 0
                                        font.pixelSize: 9
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.family: Style.Theme.fontFamily
                                    }
                                    Rectangle {
                                        id: modelIconBox
                                        width: 30
                                        height: 30
                                        color: "#00ffffff"
                                        radius: 4
                                        anchors.left: parent.left
                                        anchors.leftMargin: 0
                                        anchors.verticalCenter: parent.verticalCenter
                                        Image {
                                            id: modelIcon
                                            height: 16
                                            width: 16
                                            anchors.verticalCenter: parent.verticalCenter
                                            source: model.icon
                                            sourceSize.height: 32
                                            sourceSize.width: 32
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                    MouseArea {
                                        id:mouseAreaChatItem
                                        anchors.fill:parent
                                        onClicked: {
                                            delegateChat.color= Style.Theme.selectButtonColor
                                            root.loadModelDialog(index);
                                        }
                                        hoverEnabled: true
                                        onHoveredChanged: {
                                            if(containsMouse){
                                                delegateChat.color= Style.Theme.hoverButtonColor
                                            }else{
                                                delegateChat.color= Style.Theme.normalButtonColor
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle{
                    id: goToDownloadModelPageId
                    width: parent.width
                    height: 50
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    color: modelSettings.color

                    MyButton{
                        id:loadModelIcon
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        anchors.topMargin: 10
                        anchors.bottomMargin: 10
                        myTextId: "Go to download Model"
                        Connections{
                            target: loadModelIcon
                            function onClicked(){
                                root.goToModelPage();
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: modelSpace
                radius: 4
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "#00ffffff"
            }
        }
    }
}

