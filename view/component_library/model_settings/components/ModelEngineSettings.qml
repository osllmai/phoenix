import QtQuick 2.15
import "./button"

Item {
    id: control
    visible: false
    width: parent.width
    height: contextLengthId.height + numberOfGPUId.height + 5
    property bool existConversation: !conversationList.isEmptyConversation

    property int contextLengthId: control.existConversation? conversationList.currentConversation.modelSettings.contextLength: 120
    property int numberOfGPULayers: control.existConversation? conversationList.currentConversation.modelSettings.numberOfGPULayers: 10

    property var conversation: control.existConversation? conversationList.currentConversation: null
    onConversationChanged: {
        contextLengthId.sliderValue = control.contextLengthId
        numberOfGPUId.sliderValue = control.numberOfGPULayers
    }

    Column{
        id: engineSettingsInformationId
        anchors.left: parent.left
        anchors.right: parent.right; anchors.rightMargin: 16
        spacing: 5

        ModelSettingsSlider{
            id:contextLengthId
            myTextName: "Context Length"
            myTextToolTip: "Refers to the number of tokens the model considers from the input when generating a response."
            sliderValue: control.contextLengthId
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
            sliderValue: control.numberOfGPULayers
            sliderFrom: 1
            sliderTo: 100
            sliderStepSize:1
            onSliderValueChanged: {
                if(control.existConversation)
                    conversationList.currentConversation.modelSettings.numberOfGPULayers = sliderValue;
            }
        }
    }
}
