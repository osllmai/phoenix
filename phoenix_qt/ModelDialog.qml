import QtQuick
import QtQuick.Layouts
import QtQuick.Templates 2.1 as T
import Qt5Compat.GraphicalEffects

Item {
    id: root
    width: 200
    height: 200

    //theme for chat page
    property color chatBackgroungColor
    property color chatBackgroungConverstationColor
    property color chatMessageBackgroungColor
    property color chatMessageTitleTextColor
    property color chatMessageInformationTextColor
    property bool chatMessageIsGlow

    property color backgroungColor
    property color glowColor
    property color boxColor
    property color normalButtonColor
    property color selectButtonColor
    property color hoverButtonColor
    property color fillIconColor
    property color iconColor


    property color titleTextColor
    property color informationTextColor
    property color selectTextColor

    property var fontFamily

    property var modelListModel
    signal goToModelPage()
    signal loadModelDialog(var model)

    Rectangle{
        id: modelSettings
        anchors.fill:  parent
        color: root.chatBackgroungColor
        border.color: root.chatBackgroungColor
        radius:5
        visible: true

        gradient: Gradient {
            GradientStop {
                position: 0
                color: root.chatBackgroungConverstationColor
            }

            GradientStop {
                position: 1
                color: root.chatBackgroungColor
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
                    backgroungColor: "#00ffffff"
                    borderColor:"#00ffffff"
                    textColor: root.informationTextColor
                    glowColor: root.glowColor
                    fontFamily: root.fontFamily
                    selectTextColor:root.fillIconColor
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
                    backgroungColor: "#00ffffff"
                    borderColor:"#00ffffff"
                    textColor: root.informationTextColor
                    glowColor: root.glowColor
                    fontFamily: root.fontFamily
                    selectTextColor:root.fillIconColor
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
                color: root.fillIconColor
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
                                color: root.normalButtonColor
                                radius: 5

                                Rectangle{
                                    id:recTexxt
                                    anchors.fill:parent
                                    color: "#00ffffff"
                                    Text {
                                        id:  textId
                                        color: root.chatMessageInformationTextColor
                                        text: model.name
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.left: modelIconBox.right
                                        anchors.leftMargin: 0
                                        font.pixelSize: 9
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.family: root.fontFamily
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
                                            delegateChat.color= root.selectButtonColor
                                            root.loadModelDialog(root.modelListModel.getModel(index));
                                        }
                                        hoverEnabled: true
                                        onHoveredChanged: {
                                            if(containsMouse){
                                                delegateChat.color= root.hoverButtonColor
                                            }else{
                                                delegateChat.color= root.normalButtonColor
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

