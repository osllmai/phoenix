import QtQuick
import QtQuick.Controls
import '../../../../../component_library/style' as Style
import "../../../../../component_library/button"

Rectangle {
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
            policy: flickable.contentHeight > flickable.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
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
                font.pixelSize: 14; font.styleName: "Bold"
                clip: true
            }
            Flow {
                spacing: 5; width: parent.width
                Repeater {
                    model: [
                        { text: "All",              value: "all",             icon: "", feat: Style.RoleEnum.IconType.FeatureBlue },
                        { text: "Most Downloaded",  value: "most-downloaded", icon: "qrc:/media/icon/download.svg", feat: Style.RoleEnum.IconType.FeatureMagenta },
                        { text: "Most Liked",       value: "most-liked",     icon: "qrc:/media/icon/favorite.svg", feat: Style.RoleEnum.IconType.FeatureRed }
                    ]
                    FilterButton {
                        myText: modelData.text; myIcon: modelData.icon
                        filterValue: modelData.value; featureIcon: modelData.feat
                        currentValue: huggingfaceModelListFilter.filterStr
                        onFilterClicked: (v) => huggingfaceModelListFilter.filterStr = v
                    }
                }
            }

            Label {
                text: "Tasks"; height: 30
                verticalAlignment: Text.AlignBottom
                color: Style.Colors.textTitle
                elide: Text.ElideRight
                font.pixelSize: 14; font.styleName: "Bold"
                clip: true
            }
            Flow {
                spacing: 5; width: parent.width
                Repeater {
                    model: [
                        { text: "All",               value: "all",               icon: "",                                    feat: Style.RoleEnum.IconType.FeatureMagenta },
                        { text: "Text Generation",   value: "text-generation",   icon: "qrc:/media/icon/rewrite.svg",         feat: Style.RoleEnum.IconType.FeatureRed },
                        { text: "Any-to-Any",        value: "any-to-any",        icon: "qrc:/media/icon/grammer.svg",         feat: Style.RoleEnum.IconType.FeatureGreen },
                        { text: "Image-Text-to-Text",value: "image-text-to-text",icon: "qrc:/media/icon/imageEditor.svg",     feat: Style.RoleEnum.IconType.FeatureBlue },
                        { text: "Image-to-Text",     value: "image-to-text",     icon: "qrc:/media/icon/imageEditor.svg",     feat: Style.RoleEnum.IconType.FeatureOrange },
                        { text: "Image-to-Image",    value: "image-to-image",    icon: "qrc:/media/icon/imageEditor.svg",     feat: Style.RoleEnum.IconType.FeatureYellow },
                        { text: "Text-to-Image",     value: "text-to-image",     icon: "qrc:/media/icon/imageEditor.svg",     feat: Style.RoleEnum.IconType.FeatureMagenta },
                        { text: "Text-to-Video",     value: "text-to-video",     icon: "qrc:/media/icon/rewrite.svg",         feat: Style.RoleEnum.IconType.FeatureRed },
                        { text: "Text-to-Speech",    value: "text-to-speech",    icon: "qrc:/media/image_company/Whisper.svg", feat: Style.RoleEnum.IconType.FeatureGreen }
                    ]
                    FilterButton {
                        myText: modelData.text; myIcon: modelData.icon
                        filterValue: modelData.value; featureIcon: modelData.feat
                        currentValue: huggingfaceModelListFilter.task
                        onFilterClicked: (v) => huggingfaceModelListFilter.task = v
                    }
                }
            }

            Label {
                text: "Libraries"; height: 30
                verticalAlignment: Text.AlignBottom
                color: Style.Colors.textTitle
                elide: Text.ElideRight
                font.pixelSize: 14; font.styleName: "Bold"
                clip: true
            }
            Flow {
                spacing: 5; width: parent.width
                Repeater {
                    model: [
                        { text: "All",             value: "all",             icon: "",                                    feat: Style.RoleEnum.IconType.FeatureBlue },
                        { text: "PyTorch",         value: "pytorch",         icon: "qrc:/media/image_company/pytorch.svg",    feat: Style.RoleEnum.IconType.Image },
                        { text: "TensorFlow",      value: "tensorflow",      icon: "qrc:/media/image_company/tensorflow.svg", feat: Style.RoleEnum.IconType.Image },
                        { text: "JAX",             value: "jax",             icon: "",                                    feat: Style.RoleEnum.IconType.FeatureBlue },
                        { text: "Transformers",    value: "transformers",    icon: "qrc:/media/image_company/Huggingface.svg", feat: Style.RoleEnum.IconType.Image },
                        { text: "Diffusers",       value: "diffusers",       icon: "",                                    feat: Style.RoleEnum.IconType.FeatureBlue },
                        { text: "Safetensors",     value: "safetensors",     icon: "",                                    feat: Style.RoleEnum.IconType.FeatureBlue },
                        { text: "ONNX",            value: "onnx",            icon: "",                                    feat: Style.RoleEnum.IconType.FeatureBlue },
                        { text: "GGUF",            value: "gguf",            icon: "",                                    feat: Style.RoleEnum.IconType.FeatureBlue },
                        { text: "Transformers.js", value: "transformers.js", icon: "",                                    feat: Style.RoleEnum.IconType.FeatureBlue },
                        { text: "MLX",             value: "mlx",             icon: "",                                    feat: Style.RoleEnum.IconType.FeatureBlue },
                        { text: "Keras",           value: "keras",           icon: "",                                    feat: Style.RoleEnum.IconType.FeatureBlue },
                        { text: "VLLM",            value: "vllm",            icon: "",                                    feat: Style.RoleEnum.IconType.FeatureBlue },
                        { text: "LLama.cpp",       value: "llama.cpp",       icon: "",                                    feat: Style.RoleEnum.IconType.FeatureBlue }
                    ]
                    FilterButton {
                        myText: modelData.text; myIcon: modelData.icon
                        filterValue: modelData.value; featureIcon: modelData.feat
                        currentValue: huggingfaceModelListFilter.library
                        onFilterClicked: (v) => huggingfaceModelListFilter.library = v
                    }
                }
            }
        }
    }
}
