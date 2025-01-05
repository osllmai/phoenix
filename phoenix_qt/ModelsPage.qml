import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects
import Phoenix
import 'style' as Style

Item {
    id: root
    width: 1229 - 24 - 70
    height: 685 - 48

    property var modelListModel
    property color borderColor: "#ebebeb"

    Rectangle {
        id: modelsPageId
        color: Style.Theme.headerColor
        anchors.fill: parent

        Rectangle {
            id: listModelId
            color: Style.Theme.backgroundPageColor
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: headerId.bottom
            anchors.bottom: parent.bottom
            Rectangle {
                id: itemId
                anchors.fill: parent
                color: parent.color
                radius: 12

                ColumnLayout{
                    id: coulumnLayoutModelId
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    GridView {
                        id: gridView
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        cacheBuffer: Math.max(0, gridView.contentHeight)

                        function calculationCellWidth(){
                            if(coulumnLayoutModelId.width >1650)
                                return coulumnLayoutModelId.width/5;
                            else if(coulumnLayoutModelId.width >1300)
                                return coulumnLayoutModelId.width/4;
                            else if(coulumnLayoutModelId.width >950)
                                return coulumnLayoutModelId.width/3;
                            else if(coulumnLayoutModelId.width >650)
                                return coulumnLayoutModelId.width/2;
                            else
                                return Math.max(coulumnLayoutModelId.width,300);
                        }

                        cellWidth: calculationCellWidth()
                        cellHeight: 340
                        model: root.modelListModel

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                        }
                        clip: true

                        delegate: Rectangle{
                            id: rectangleGridView
                            width: gridView.cellWidth
                            height: gridView.cellHeight
                            color: Style.Theme.backgroundPageColor
                            ModelItem {
                                id: indoxItem
                                anchors.fill: parent
                                anchors.margins: 20
                                myModel: model
                                myModelListModel: root.modelListModel
                                myIndex: index
                                xNotification: root.x
                                yNotification: root.y
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: headerId
            height: 80
            width: parent.width
            color: parent.color
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 0
            // radius: 12

            Rectangle {
                id: searchBox
                height: 40
                color: Style.Theme.normalButtonColor
                width: 300
                radius: 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: loadModelButton.left
                anchors.rightMargin: 24
                visible: searchBox.width + loadModelButton.width + instalTextRec.width<headerId.width?true:false

                Image {
                    id: searchIcon
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    source: "images/searchIcon.svg"
                    sourceSize.height: 20
                    sourceSize.width: 20
                    fillMode: Image.PreserveAspectFit
                }
                ColorOverlay {
                    id: colorOverlaySearchIconId
                    anchors.fill: searchIcon
                    source: searchIcon
                    color: Style.Theme.informationTextColor
                }

                TextArea {
                    id: textArea
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: searchIcon.right
                    anchors.right: parent.right
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    font.pointSize: 10
                    placeholderTextColor: Style.Theme.informationTextColor
                    font.family: Style.Theme.fontFamily
                    hoverEnabled: true
                    placeholderText: qsTr("Search History")
                    color: Style.Theme.informationTextColor
                    background: Rectangle{
                        color: "#00ffffff"
                    }
                }
                layer.enabled: true
                layer.effect: Glow {
                     samples: 15
                     color: Style.Theme.glowColor
                     spread: 0.0
                     transparentBorder: true
                 }
            }

            MyButton {
                id: loadModelButton
                width: 120
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 24

                FileDialog{
                    id: fileDialogId
                    title: "Choose file"
                    nameFilters: ["Text files (*.gguf)"]
                    fileMode: FileDialog.OpenFiles // Allow for selecting multiple files
                    onAccepted: function(){
                        root.modelListModel.addModel(currentFile)
                    }
                }

                myTextId: "Add Model"
                Connections {
                    target: loadModelButton
                     function onClicked(){ fileDialogId.open();}
                }
            }


            Rectangle{
                id: instalTextRec
                width: 254
                color: "#00ffffff"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 24
                anchors.topMargin: 15
                anchors.bottomMargin: 20

                Text {
                    id: installedModelTextId
                    text: qsTr("Installed Models")
                    font.pixelSize: 20
                    font.weight: 700
                    font.family: Style.Theme.fontFamily
                    color: Style.Theme.titleTextColor
                }

                Text {
                    id: localInstallTextId
                    text: qsTr("Local install")
                    anchors.top: installedModelTextId.bottom
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 5
                    anchors.bottomMargin: 0
                    font.pixelSize: 14
                    font.family: Style.Theme.fontFamily
                    color:Style.Theme.informationTextColor
                }
            }
        }
    }
}
