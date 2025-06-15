import QtQuick 2.15
import "./button"

Item {
    id: control
    width: parent.width
    height: streamId.height + temperatureId.height + topPId.height +
            maxTokensId.height + promptBatchSizeId.height + minPId.height +
            topKId.height + repeatPenaltyTokensId.height + repeatPenaltyId.height + 40
    visible: false

    Column{
        id: inferenceSettingsInformationId
        anchors.left: parent.left
        anchors.right: parent.right; anchors.rightMargin: 16
        spacing: 5

        ModelSettingsSwitch{
            id:streamId
            myTextName: "Stream"
            myValue: modelSettingsId.stream
            onMyValueChanged: {
                modelSettingsId.updateStream(streamId.myValue)
            }
        }
        ModelSettingsSlider{
            id:temperatureId
            myTextName: "Temperature"
            myTextToolTip: "Controls response randomness, lower values make responses more predictable, higher values make them more creative."
            sliderValue: modelSettingsId.temperature
            sliderFrom: 0.0
            sliderTo:2.0
            sliderStepSize:0.01
            decimalPart: 2
            onSliderValueChanged: {
                modelSettingsId.updateTemperature(temperatureId.sliderValue)
            }
        }
        ModelSettingsSlider{
            id:topPId
            myTextName: "Top-P"
            myTextToolTip:"Limits word selection to a subset with a cumulative probability above p, affecting response diversity."
            sliderValue: modelSettingsId.topP
            sliderFrom: 0.0
            sliderTo:1.0
            sliderStepSize:0.01
            decimalPart: 2
            onSliderValueChanged: {
                modelSettingsId.updateTopP(topPId.sliderValue)
            }
        }
        ModelSettingsSlider{
            id:maxTokensId
            myTextName: "Max Tokens"
            myTextToolTip: "Defines the maximum number of tokens the model can process in one input or output."
            sliderValue: modelSettingsId.maxTokens
            sliderFrom: 100
            sliderTo: 4096
            sliderStepSize:1
            onSliderValueChanged: {
                modelSettingsId.updateMaxTokens(maxTokensId.sliderValue)
            }
        }
        ModelSettingsSlider{
            id:promptBatchSizeId
            myTextName: "Prompt Batch Size"
            myTextToolTip:"Refers to the number of prompts processed in a single batch, affecting processing efficiency."
            sliderValue: modelSettingsId.promptBatchSize
            sliderFrom: 1
            sliderTo: 128
            sliderStepSize:1
            onSliderValueChanged: {
                modelSettingsId.updatePromptBatchSize(promptBatchSizeId.sliderValue)
            }
        }
        ModelSettingsSlider{
            id:minPId
            myTextName: "Min-P"
            myTextToolTip:"Sets the minimum cumulative probability threshold for word selection."
            sliderValue: modelSettingsId.minP
            sliderFrom: 0.0
            sliderTo: 1.0
            sliderStepSize:0.01
            decimalPart: 2
            onSliderValueChanged: {
                modelSettingsId.updateMinP(minPId.sliderValue)
            }
        }
        ModelSettingsSlider{
            id:topKId
            myTextName: "Top-K"
            myTextToolTip: "Limits word selection to the top K most probable words, controlling output diversity."
            sliderValue: modelSettingsId.topK
            sliderFrom: 1
            sliderTo: 1000
            sliderStepSize:1
            onSliderValueChanged: {
                modelSettingsId.updateTopK(topKId.sliderValue)
            }
        }
        ModelSettingsSlider{
            id:repeatPenaltyTokensId
            myTextName: "Repeat Penalty Tokens"
            myTextToolTip: "Increases the penalty for repeating specific tokens during generation."
            sliderValue: modelSettingsId.repeatPenaltyTokens
            sliderFrom: 0
            sliderTo: 1
            sliderStepSize:0.01
            decimalPart: 2
            onSliderValueChanged: {
                modelSettingsId.updateRepeatPenaltyTokens(repeatPenaltyTokensId.sliderValue)
            }
        }
        ModelSettingsSlider{
            id:repeatPenaltyId
            myTextName: "Repeat Penalty"
            myTextToolTip: "Discourages repeating words or phrases by applying a penalty to repeated tokens."
            sliderValue: modelSettingsId.repeatPenalty
            sliderFrom: 1.0
            sliderTo: 2.0
            sliderStepSize:0.01
            decimalPart: 2
            onSliderValueChanged: {
                modelSettingsId.updateRepeatPenalty(repeatPenaltyId.sliderValue)
            }
        }
    }
}
