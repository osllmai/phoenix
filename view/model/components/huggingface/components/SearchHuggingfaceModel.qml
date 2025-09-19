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
        x: control.x - (comboBoxId.width < 200? (popupId.width - comboBoxId.width)/2 : 0)
        width: Math.max(comboBoxId.width, 200)
        height: 320
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
                Flickable {
                    id: flickable
                    anchors.fill: parent
                    anchors.margins: 12

                    contentHeight: column.implicitHeight
                    clip: true

                    interactive: flickable.contentHeight > flickable.height
                    boundsBehavior: flickable.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

                    flickDeceleration: 80
                    maximumFlickVelocity: 30000

                    ScrollBar.vertical: ScrollBar {
                        policy: flickable.contentHeight > flickable.height
                                ? ScrollBar.AlwaysOn
                                : ScrollBar.AlwaysOff
                    }

                    Column{
                        id: column
                        width: flickable.width
                        spacing: 5

                        Label {
                            text: "Main Filtter"
                            verticalAlignment: Text.AlignBottom
                            color: Style.Colors.textTitle
                            elide: Text.ElideRight
                            font.pixelSize: 14
                            font.styleName: "Bold"
                            clip: true
                        }
                        Flow {
                            spacing: 5
                            width: parent.width

                            MyButton {
                                myText: "All"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                iconType: Style.RoleEnum.IconType.FeatureBlue
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.filterStr === "all"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.filterStr = "all"
                                    }
                                }
                            }

                            MyButton {
                                myText: "Most Downloaded"
                                myIcon: "qrc:/media/icon/download.svg"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                iconType: Style.RoleEnum.IconType.FeatureMagenta
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.filterStr === "most-downloaded"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.filterStr = "most-downloaded"
                                    }
                                }
                            }

                            MyButton {
                                myText: "Most Liked"
                                myIcon: "qrc:/media/icon/favorite.svg"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                iconType: Style.RoleEnum.IconType.FeatureRed
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.filterStr === "most-liked"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.filterStr = "most-liked"
                                    }
                                }
                            }
                        }

                        Label {
                            text: "Tasks"
                            height: 30
                            verticalAlignment: Text.AlignBottom
                            color: Style.Colors.textTitle
                            elide: Text.ElideRight
                            font.pixelSize: 14
                            font.styleName: "Bold"
                            clip: true
                        }
                        Flow{
                            spacing: 5
                            width: parent.width
                            MyButton {
                                myText: "All"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                iconType: Style.RoleEnum.IconType.FeatureMagenta
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.task === "all"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.task = "all"
                                    }
                                }
                            }
                            MyButton {
                                myText: "Text Generation"
                                myIcon: "qrc:/media/icon/rewrite.svg"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                iconType: Style.RoleEnum.IconType.FeatureRed
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.task === "text-generation"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.task = "text-generation"
                                    }
                                }
                            }
                            MyButton {
                                myText: "Any-to-Any"
                                myIcon: "qrc:/media/icon/grammer.svg"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                iconType: Style.RoleEnum.IconType.FeatureGreen
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.task === "any-to-any"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.task = "any-to-any"
                                    }
                                }
                            }
                            MyButton {
                                myText: "Image-Text-to-Text"
                                myIcon: "qrc:/media/icon/imageEditor.svg"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                iconType: Style.RoleEnum.IconType.FeatureBlue
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.task === "image-text-to-text"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.task = "image-text-to-text"
                                    }
                                }
                            }
                            MyButton {
                                myText: "Image-to-Text"
                                myIcon: "qrc:/media/icon/imageEditor.svg"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                iconType: Style.RoleEnum.IconType.FeatureOrange
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.task === "image-to-text"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.task = "image-to-text"
                                    }
                                }
                            }
                            MyButton {
                                myText: "Image-to-Image"
                                myIcon: "qrc:/media/icon/imageEditor.svg"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                iconType: Style.RoleEnum.IconType.FeatureYellow
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.task === "image-to-image"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.task = "image-to-image"
                                    }
                                }
                            }
                            MyButton {
                                myText: "Text-to-Image"
                                myIcon: "qrc:/media/icon/imageEditor.svg"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                iconType: Style.RoleEnum.IconType.FeatureMagenta
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.task === "text-to-image"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.task = "text-to-image"
                                    }
                                }
                            }
                            MyButton {
                                myText: "Text-to-Video"
                                myIcon: "qrc:/media/icon/rewrite.svg"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                iconType: Style.RoleEnum.IconType.FeatureRed
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.task === "text-to-video"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.task = "text-to-video"
                                    }
                                }
                            }
                            MyButton {
                                myText: "Text-to-Speech"
                                myIcon: "qrc:/media/image_company/Whisper.svg"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                iconType: Style.RoleEnum.IconType.FeatureGreen
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.task === "text-to-speech"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.task = "text-to-speech"
                                    }
                                }
                            }
                        }
                        Label {
                            text: "Libraries"
                            color: Style.Colors.textTitle
                            height: 30
                            verticalAlignment: Text.AlignBottom
                            elide: Text.ElideRight
                            font.pixelSize: 14
                            font.styleName: "Bold"
                            clip: true
                        }
                        Flow {
                            spacing: 5
                            width: parent.width

                            MyButton {
                                myText: "All"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.library === "all"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.library = "all"
                                    }
                                }
                            }

                            MyButton {
                                myText: "PyTorch"
                                myIcon: "qrc:/media/image_company/pytorch.svg"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                iconType: Style.RoleEnum.IconType.Image
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.library === "pytorch"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.library = "pytorch"
                                    }
                                }
                            }

                            MyButton {
                                myText: "TensorFlow"
                                myIcon: "qrc:/media/image_company/tensorflow.svg"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                iconType: Style.RoleEnum.IconType.Image
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.library === "tensorflow"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.library = "tensorflow"
                                    }
                                }
                            }

                            MyButton {
                                myText: "JAX"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.library === "jax"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.library = "jax"
                                    }
                                }
                            }

                            MyButton {
                                myText: "Transformers"
                                myIcon: "qrc:/media/image_company/Huggingface.svg"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                iconType: Style.RoleEnum.IconType.Image
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.library === "transformers"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.library = "transformers"
                                    }
                                }
                            }

                            MyButton {
                                myText: "Diffusers"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.library === "diffusers"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.library = "diffusers"
                                    }
                                }
                            }

                            MyButton {
                                myText: "Safetensors"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.library === "safetensors"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.library = "safetensors"
                                    }
                                }
                            }

                            MyButton {
                                myText: "ONNX"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.library === "onnx"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.library = "onnx"
                                    }
                                }
                            }

                            MyButton {
                                myText: "GGUF"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.library === "gguf"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.library = "gguf"
                                    }
                                }
                            }

                            MyButton {
                                myText: "Transformers.js"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.library === "transformers.js"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.library = "transformers.js"
                                    }
                                }
                            }

                            MyButton {
                                myText: "MLX"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.library === "mlx"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.library = "mlx"
                                    }
                                }
                            }

                            MyButton {
                                myText: "Keras"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.library === "keras"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.library = "keras"
                                    }
                                }
                            }

                            MyButton {
                                myText: "VLLM"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.library === "vllm"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.library = "vllm"
                                    }
                                }
                            }

                            MyButton {
                                myText: "LLama.cpp"
                                bottonType: Style.RoleEnum.BottonType.Feature
                                isNeedAnimation: true
                                selected: huggingfaceModelListFilter.library === "llama.cpp"

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        huggingfaceModelListFilter.library = "llama.cpp"
                                    }
                                }
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
