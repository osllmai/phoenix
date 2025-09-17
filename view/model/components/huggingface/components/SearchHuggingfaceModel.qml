import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import '../../../../component_library/style' as Style
import "../../../../component_library/button"
import "./components"

ComboBox {
    id: comboBoxId
    height: 35
    width: 200
    font.pixelSize: 12

    Accessible.role: Accessible.ComboBox

    signal search(var text)

    contentItem: Rectangle{
        id: control
        width: control.width; height: 32
        color: Style.Colors.menuHoverBackground
        border.width: 0
        border.color: Style.Colors.boxBorder
        radius: 8
        clip: true
        property bool isTextAreaVisible: true

        Row{
            anchors.fill: parent
            ToolButton {
                id: searchIcon
                anchors.verticalCenter: parent.verticalCenter
                background: null
                icon{
                    source: "qrc:/media/icon/search.svg"
                    color: Style.Colors.menuNormalIcon
                    width:18; height:18
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:{textArea.pressed}
                }
            }
            TextArea {
                id: textArea
                width: parent.width - searchIcon.width
                visible: control.isTextAreaVisible
                anchors.verticalCenter: searchIcon.verticalCenter
                hoverEnabled: true
                cursorVisible: false
                persistentSelection: true
                placeholderText: qsTr("Search")
                selectionColor: Style.Colors.textSelection
                placeholderTextColor: textArea.text ===""? Style.Colors.menuNormalIcon: Style.Colors.textPlaceholder
                color: Style.Colors.menuNormalIcon
                font.pointSize: 10
                wrapMode: TextEdit.NoWrap
                background: null
                onTextChanged: comboBoxId.search(textArea.text)
                Keys.onReturnPressed: (event)=> {
                  if (event.modifiers & Qt.ControlModifier || event.modifiers & Qt.ShiftModifier){
                    event.accepted = false;
                  }else {
                        comboBoxId.search(textArea.text)
                  }
                }
                onEditingFinished: {
                    control.border.width = 0
                    comboBoxId.popup.close()
                }
                onPressed: {
                    control.border.width = 1
                    comboBoxId.popup.open()
                }
            }
        }
    }

    popup: Popup {
        id: popupId
        y: comboBoxId.height + 5
        width: comboBoxId.width
        height: 120
        background: null

        contentItem: Loader {
            id: popupLoader
            anchors.fill: parent
            active: popupId.visible
            sourceComponent: Rectangle {
                anchors.fill: parent
                color: Style.Colors.background
                border.width: 1; border.color: Style.Colors.boxBorder
                radius: 10
                Flow{
                    spacing: 5
                    anchors.fill: parent
                    anchors.margins: 12
                    MyButton {
                        id: documentId
                        myText: "All"
                        myIcon: "qrc:/media/icon/document.svg"
                        bottonType: Style.RoleEnum.BottonType.Feature
                        iconType: Style.RoleEnum.IconType.FeatureBlue
                        isNeedAnimation: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                huggingfaceModelListFilter.filter("All")
                            }
                        }
                    }

                    MyButton {
                        id: grammarId
                        myText: "Most Downloaded"
                        myIcon: "qrc:/media/icon/grammer.svg"
                        bottonType: Style.RoleEnum.BottonType.Feature
                        iconType: Style.RoleEnum.IconType.FeatureRed
                        isNeedAnimation: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                huggingfaceModelListFilter.filter("MostLiked")
                            }
                        }
                    }
                    MyButton {
                        id: rewriteId
                        myText: "Most Liked"
                        myIcon: "qrc:/media/icon/rewrite.svg"
                        bottonType: Style.RoleEnum.BottonType.Feature
                        iconType: Style.RoleEnum.IconType.FeatureOrange
                        isNeedAnimation: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                huggingfaceModelListFilter.filter("MostLiked")
                            }
                        }
                    }
                    MyButton {
                        id: imageEditorId
                        myText: "Pipeline Tag"
                        myIcon: "qrc:/media/icon/imageEditor.svg"
                        bottonType: Style.RoleEnum.BottonType.Feature
                        iconType: Style.RoleEnum.IconType.FeatureGreen
                        isNeedAnimation: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                huggingfaceModelListFilter.filter("PipelineTag")
                            }
                        }
                    }
                    MyButton {
                        id: imageId
                        myText: "Image"
                        myIcon: "qrc:/media/icon/image.svg"
                        bottonType: Style.RoleEnum.BottonType.Feature
                        iconType: Style.RoleEnum.IconType.FeatureYellow
                        isNeedAnimation: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                huggingfaceModelListFilter.filter("All")
                            }
                        }
                    }
                }
            }
        }
    }

    indicator: Image {}
    background: null
    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
}
