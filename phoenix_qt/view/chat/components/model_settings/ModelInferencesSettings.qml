import QtQuick 2.15

Item {
    id: control
    width: parent.width
    height: streamId.height + temperatureId.height + topPId.height +
            maxTokensId.height + promptBatchSizeId.height + minPId.height +
            topKId.height + repeatPenaltyTokensId.height + repeatPenaltyId.height
    visible: false

    property bool existConversation: !conversationList.isEmptyConversation

    Column{
        id: inferenceSettingsInformationId
        anchors.left: parent.left
        anchors.right: parent.right; anchors.rightMargin: 16

        ModelSettingsSwitch{
            id:streamId
            myTextName: "Stream"
            myValue: control.existConversation? conversationList.currentConversation.id: true
        }
        ModelSettingsSlider{
            id:temperatureId
            myTextName: "Temperature"
            myTextToolTip: "Controls response randomness, lower values make responses more predictable, higher values make them more creative."
            sliderValue: control.existConversation? conversationList.currentConversation.id: 0.8
            sliderFrom: 0.0
            sliderTo:2.0
            sliderStepSize:0.01
            decimalPart: 2
        }
        ModelSettingsSlider{
            id:topPId
            myTextName: "Top-P"
            myTextToolTip:"Limits word selection to a subset with a cumulative probability above p, affecting response diversity."
            sliderValue: control.existConversation? conversationList.currentConversation.id: 1.5
            sliderFrom: 0.0
            sliderTo:1.0
            sliderStepSize:0.01
            decimalPart: 2
        }
        ModelSettingsSlider{
            id:maxTokensId
            myTextName: "Max Tokens"
            myTextToolTip: "Defines the maximum number of tokens the model can process in one input or output."
            sliderValue: control.existConversation? conversationList.currentConversation.id: 560
            sliderFrom: 100
            sliderTo: 4096
            sliderStepSize:1
        }
        ModelSettingsSlider{
            id:promptBatchSizeId
            myTextName: "Prompt Batch Size"
            myTextToolTip:"Refers to the number of prompts processed in a single batch, affecting processing efficiency."
            sliderValue: control.existConversation? conversationList.currentConversation.id: 100
            sliderFrom: 1
            sliderTo: 128
            sliderStepSize:1
        }
        ModelSettingsSlider{
            id:minPId
            myTextName: "Min-P"
            myTextToolTip:"Sets the minimum cumulative probability threshold for word selection."
            sliderValue: control.existConversation? conversationList.currentConversation.id: 1.5
            sliderFrom: 0.0
            sliderTo: 1.0
            sliderStepSize:0.01
            decimalPart: 2
        }
        ModelSettingsSlider{
            id:topKId
            myTextName: "Top-K"
            myTextToolTip: "Limits word selection to the top K most probable words, controlling output diversity."
            sliderValue: control.existConversation? conversationList.currentConversation.id: 650
            sliderFrom: 1
            sliderTo: 1000
            sliderStepSize:1
        }
        ModelSettingsSlider{
            id:repeatPenaltyTokensId
            myTextName: "Repeat Penalty Tokens"
            myTextToolTip: "Increases the penalty for repeating specific tokens during generation."
            sliderValue: control.existConversation? conversationList.currentConversation.id: 1.5
            sliderFrom: 0
            sliderTo: 1
            sliderStepSize:0.01
            decimalPart: 2
        }
        ModelSettingsSlider{
            id:repeatPenaltyId
            myTextName: "Repeat Penalty"
            myTextToolTip: "Discourages repeating words or phrases by applying a penalty to repeated tokens."
            sliderValue: control.existConversation? conversationList.currentConversation.id: 1.5
            sliderFrom: 1.0
            sliderTo: 2.0
            sliderStepSize:0.01
            decimalPart: 2
        }
    }
}
