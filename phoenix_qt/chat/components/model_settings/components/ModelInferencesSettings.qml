import QtQuick 2.15

Item {
    width: parent.width
    height: streamId.height + temperatureId.height + topPId.height +
            maxTokensId.height + promptBatchSizeId.height + minPId.height +
            topKId.height + repeatPenaltyTokensId.height + repeatPenaltyId.height
    visible: false
    Column{
        id: inferenceSettingsInformationId
        anchors.left: parent.left
        anchors.right: parent.right; anchors.rightMargin: 16

        ModelSettingsSwitch{
            id:streamId
            myTextName: "Stream"
            myValue: /*root.currentChat.modelSettings.stream*/true
        }
        ModelSettingsSlider{
            id:temperatureId
            myTextName: "Temperature"
            // myTextDescription: "Controls response randomness, lower values make responses more predictable, higher values make them more creative."
            sliderValue: 0.8/*root.currentChat.modelSettings.temperature*/
            sliderFrom: 0.0
            sliderTo:2.0
            sliderStepSize:0.01
            decimalPart: 2
        }
        ModelSettingsSlider{
            id:topPId
            myTextName: "Top-P"
            // myTextDescription:"Limits word selection to a subset with a cumulative probability above p, affecting response diversity."
            sliderValue: 1.5/*root.currentChat.modelSettings.topP*/
            sliderFrom: 0.0
            sliderTo:1.0
            sliderStepSize:0.01
            decimalPart: 2
        }
        ModelSettingsSlider{
            id:maxTokensId
            myTextName: "Max Tokens"
            // myTextDescription: "Defines the maximum number of tokens the model can process in one input or output."
            sliderValue: 560/*root.currentChat.modelSettings.maxTokens*/
            sliderFrom: 100
            sliderTo: 4096
            sliderStepSize:1
        }
        ModelSettingsSlider{
            id:promptBatchSizeId
            myTextName: "Prompt Batch Size"
            // myTextDescription:"Refers to the number of prompts processed in a single batch, affecting processing efficiency."
            sliderValue: 100/*root.currentChat.modelSettings.promptBatchSize*/
            sliderFrom: 1
            sliderTo: 128
            sliderStepSize:1
        }
        ModelSettingsSlider{
            id:minPId
            myTextName: "Min-P"
            // myTextDescription:"Sets the minimum cumulative probability threshold for word selection."
            sliderValue: 1.5/*root.currentChat.modelSettings.minP*/
            sliderFrom: 0.0
            sliderTo: 1.0
            sliderStepSize:0.01
            decimalPart: 2
        }
        ModelSettingsSlider{
            id:topKId
            myTextName: "Top-K"
            // myTextDescription: "Limits word selection to the top K most probable words, controlling output diversity."
            sliderValue: 650/*root.currentChat.modelSettings.topK*/
            sliderFrom: 1
            sliderTo: 1000
            sliderStepSize:1
        }
        ModelSettingsSlider{
            id:repeatPenaltyTokensId
            myTextName: "Repeat Penalty Tokens"
            // myTextDescription: "Increases the penalty for repeating specific tokens during generation."
            sliderValue: 1.5/*root.currentChat.modelSettings.repeatPenaltyTokens*/
            sliderFrom: 0
            sliderTo: 1
            sliderStepSize:0.01
            decimalPart: 2
        }
        ModelSettingsSlider{
            id:repeatPenaltyId
            myTextName: "Repeat Penalty"
            // myTextDescription: "Discourages repeating words or phrases by applying a penalty to repeated tokens."
            sliderValue: 1.5/*root.currentChat.modelSettings.repeatPenalty*/
            sliderFrom: 1.0
            sliderTo: 2.0
            sliderStepSize:0.01
            decimalPart: 2
        }
    }
}
