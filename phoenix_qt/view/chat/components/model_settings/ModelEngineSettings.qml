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
            myTextToolTip: "Refers to the number of tokens the model considers from the input when generating a response."
            sliderValue: control.existConversation? conversationList.currentConversation.id: 65
            sliderFrom: 120
            sliderTo:4096
            sliderStepSize:1
        }
        ModelSettingsSlider{
            id:numberOfGPUId
            myTextName: "Number of GPU layers (ngl)"
            myTextToolTip: "Refers to the number of layers processed using a GPU, affecting performance."
            sliderValue: control.existConversation? conversationList.currentConversation.id: 1
            sliderFrom: 62
            sliderTo: 100
            sliderStepSize:1
        }
    }
}
