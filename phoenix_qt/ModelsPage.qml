import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects
import Phoenix
import Qt.labs.qmlmodels

Item {
    id: root
    width: 1229 - 24 - 70
    height: 685 - 48

    property ModelList modelListModel

    property color backgroundPageColor
    property color backgroungColor
    property color glowColor
    property color boxColor
    property color headerColor
    property color normalButtonColor
    property color selectButtonColor
    property color hoverButtonColor
    property color fillIconColor
    property color iconColor

    property color titleTextColor
    property color informationTextColor
    property color selectTextColor

    property var fontFamily

    property color borderColor: "#ebebeb"

    ModelListFilter {
        id: offlineModels
        currentModelList: modelListModel
        backendType: ModelListFilter.LocalModel
        searchTerm: textArea.text
    }
    // ModelListFilter {
    //     id: onlineModels
    //     currentModelList: modelListModel
    //     backendType: ModelListFilter.OnlineProvider
    //     searchTerm: textArea.text
    // }

    Rectangle {
        id: modelsPageId
        color: root.headerColor
        // radius: 12
        anchors.fill: parent


        Rectangle {
            id: listModelId
            color: root.backgroundPageColor
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: headerId.bottom
            anchors.bottom: parent.bottom
            // radius: 12

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
                        model:  root.modelListModel

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                        }
                        clip: true

                        delegate: DelegateChooser {
                            role: 'backendType'

                            DelegateChoice {
                                roleValue: ModelList.OnlineProvider
                                delegate: Rectangle{
                                    width: gridView.cellWidth
                                    height: gridView.cellHeight
                                    color: root.backgroundPageColor
                                    OnlineModelItem {
                                        anchors.fill: parent
                                        anchors.margins: 20
                                        myModel: model
                                        myModelListModel: root.modelListModel
                                        myIndex: index

                                        backgroundPageColor: root.backgroundPageColor
                                        backgroungColor: window.backgroungColor
                                        glowColor: window.glowColor
                                        boxColor: root.boxColor
                                        headerColor: root.headerColor
                                        normalButtonColor: root.normalButtonColor
                                        selectButtonColor: root.selectButtonColor
                                        hoverButtonColor: root.hoverButtonColor
                                        fillIconColor: root.fillIconColor

                                        titleTextColor: root.titleTextColor
                                        informationTextColor: root.informationTextColor
                                        selectTextColor: root.selectTextColor

                                        fontFamily: root.fontFamily
                                    }
                                }
                            }

                            DelegateChoice {
                                roleValue: ModelList.LocalModel
                                delegate: Rectangle{
                                    id: rectangleGridView
                                    width: gridView.cellWidth
                                    height: gridView.cellHeight
                                    color: root.backgroundPageColor
                                    ModelItem {
                                        id: indoxItem
                                        anchors.fill: parent
                                        anchors.margins: 20
                                        myModel: model
                                        myModelListModel: root.modelListModel
                                        myIndex: index

                                        backgroundPageColor: root.backgroundPageColor
                                        backgroungColor: window.backgroungColor
                                        glowColor: window.glowColor
                                        boxColor: root.boxColor
                                        headerColor: root.headerColor
                                        normalButtonColor: root.normalButtonColor
                                        selectButtonColor: root.selectButtonColor
                                        hoverButtonColor: root.hoverButtonColor
                                        fillIconColor: root.fillIconColor

                                        titleTextColor: root.titleTextColor
                                        informationTextColor: root.informationTextColor
                                        selectTextColor: root.selectTextColor

                                        fontFamily: root.fontFamily
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: headerId
            height: 100
            width: parent.width
            color: parent.color
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 0
            // radius: 12

            TabBar {
                anchors {
                    left: parent.left
                    bottom: parent.bottom
                }

                TabButton {
                    text: "Local models"
                }
                TabButton {
                    text: "Online providers"
                }
            }

            Rectangle {
                id: searchBox
                height: 40
                color: root.normalButtonColor
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
                    color: root.informationTextColor
                }

                TextField {
                    id: textArea
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: searchIcon.right
                    anchors.right: parent.right
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    font.pointSize: 10
                    placeholderTextColor: root.informationTextColor
                    font.family: root.fontFamily
                    hoverEnabled: true
                    placeholderText: qsTr("Search History")
                    color: root.informationTextColor
                    background: Rectangle{
                        color: "#00ffffff"
                    }
                }
                layer.enabled: true
                layer.effect: Glow {
                     samples: 15
                     color: root.glowColor
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
                     onClicked: fileDialogId.open();
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
                    font.family: root.fontFamily
                    color: root.titleTextColor
                }

                Text {
                    id: localInstallTextId
                    text: qsTr("Local install")
                    anchors.top: installedModelTextId.bottom
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 5
                    anchors.bottomMargin: 0
                    font.pixelSize: 14
                    font.family: root.fontFamily
                    color:root.informationTextColor
                }
            }
        }
    }
}
