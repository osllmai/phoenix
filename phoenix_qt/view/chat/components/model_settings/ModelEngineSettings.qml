import QtQuick 2.15
import "./components"

Item {
    id: control
    width: parent.width
    height: contextLengthId.height + numberOfGPUId.height + 5
    property bool existConversation: !conversationList.isEmptyConversation
    visible: false

    Column{
        id: engineSettingsInformationId
        anchors.left: parent.left
        anchors.right: parent.right; anchors.rightMargin: 16
        spacing: 5

        ModelSettingsSlider{
            id:contextLengthId
            myTextName: "Context Length"
            myTextToolTip: "Refers to the number of tokens the model considers from the input when generating a response."
            sliderValue: control.existConversation? conversationList.currentConversation.modelSettings.contextLength: 65
            sliderFrom: 120
            sliderTo:4096
            sliderStepSize:1
            onSliderValueChanged: {
                if(control.existConversation)
                    conversationList.currentConversation.modelSettings.contextLength = sliderValue;
            }
        }
        ModelSettingsSlider{
            id:numberOfGPUId
            myTextName: "Number of GPU layers (ngl)"
            myTextToolTip: "Refers to the number of layers processed using a GPU, affecting performance."
            sliderValue: control.existConversation? conversationList.currentConversation.modelSettings.numberOfGPULayers: 1
            sliderFrom: 62
            sliderTo: 100
            sliderStepSize:1
            onSliderValueChanged: {
                if(control.existConversation)
                    conversationList.currentConversation.modelSettings.numberOfGPULayers = sliderValue;
            }
        }
    }
}
