import QtQuick 2.15

Item {
    width: parent.width
    height: contextLengthId.height + numberOfGPUId.height
    visible: false
    Column{
        id: engineSettingsInformationId
        anchors.left: parent.left
        anchors.right: parent.right; anchors.rightMargin: 16

        ModelSettingsSlider{
            id:contextLengthId
            myTextName: "Context Length"
            // myTextDescription: "Refers to the number of tokens the model considers from the input when generating a response."
            sliderValue: 65/*root.currentChat.modelSettings.contextLength*/
            sliderFrom: 120
            sliderTo:4096
            sliderStepSize:1
        }
        ModelSettingsSlider{
            id:numberOfGPUId
            myTextName: "Number of GPU layers (ngl)"
            // myTextDescription: "Refers to the number of layers processed using a GPU, affecting performance."
            sliderValue: 1/*root.currentChat.modelSettings.numberOfGPULayers*/
            sliderFrom: 62
            sliderTo: 100
            sliderStepSize:1
        }
    }
}
