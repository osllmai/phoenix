import QtQuick 2.15
import "./button"

Item {
    id: control
    visible: false
    width: parent.width
    height: contextLengthId.height + numberOfGPUId.height + 5

    Column{
        id: engineSettingsInformationId
        anchors.left: parent.left
        anchors.right: parent.right; anchors.rightMargin: 16
        spacing: 5

        ModelSettingsSlider{
            id:contextLengthId
            myTextName: "Context Length"
            myTextToolTip: "Refers to the number of tokens the model considers from the input when generating a response."
            sliderValue: modelSettingsId.contextLength
            sliderFrom: 120
            sliderTo:4096
            sliderStepSize:1
            onSliderValueChanged: {
                modelSettingsId.updateContextLength(contextLengthId.sliderValue)
            }
        }
        ModelSettingsSlider{
            id:numberOfGPUId
            myTextName: "Number of GPU layers (ngl)"
            myTextToolTip: "Refers to the number of layers processed using a GPU, affecting performance."
            sliderValue: modelSettingsId.numberOfGPULayers
            sliderFrom: 1
            sliderTo: 100
            sliderStepSize:1
            onSliderValueChanged: {
                modelSettingsId.updateNumberOfGPULayers(numberOfGPUId.sliderValue)
            }
        }
    }
}
