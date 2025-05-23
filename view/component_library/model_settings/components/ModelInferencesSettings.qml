import QtQuick 2.15
import "./button"

Item {
    id: control
    width: parent.width
    height: streamId.height + temperatureId.height + topPId.height +
            maxTokensId.height + promptBatchSizeId.height + minPId.height +
            topKId.height + repeatPenaltyTokensId.height + repeatPenaltyId.height + 40
    visible: false

    property bool existConversation: !conversationList.isEmptyConversation

    property bool stream: control.existConversation? conversationList.currentConversation.modelSettings.stream: true
    property double temperature: control.existConversation? conversationList.currentConversation.modelSettings.temperature: 0.8
    property double topP: control.existConversation? conversationList.currentConversation.modelSettings.topP: 1.5
    property double maxTokens: control.existConversation? conversationList.currentConversation.modelSettings.maxTokens: 560
    property double promptBatchSize: control.existConversation? conversationList.currentConversation.modelSettings.promptBatchSize: 100
    property double minP: control.existConversation? conversationList.currentConversation.modelSettings.minP: 1.5
    property double topK: control.existConversation? conversationList.currentConversation.modelSettings.topK: 650
    property double repeatPenaltyTokens: control.existConversation? conversationList.currentConversation.modelSettings.repeatPenaltyTokens: 1.5
    property double repeatPenalty: control.existConversation? conversationList.currentConversation.modelSettings.repeatPenalty: 1.5

    property var conversation: control.existConversation? conversationList.currentConversation: null
    onConversationChanged: {
        streamId.myValue = control.stream
        temperatureId.sliderValue = control.temperature
        topPId.sliderValue = control.topP
        maxTokensId.sliderValue = control.maxTokens
        promptBatchSizeId.sliderValue = control.promptBatchSize
        minPId.sliderValue = control.minP
        topKId.sliderValue = control.topK
        repeatPenaltyTokensId.sliderValue = control.repeatPenaltyTokens
        repeatPenaltyId.sliderValue = control.repeatPenalty
    }

    Column{
        id: inferenceSettingsInformationId
        anchors.left: parent.left
        anchors.right: parent.right; anchors.rightMargin: 16
        spacing: 5

        ModelSettingsSwitch{
            id:streamId
            myTextName: "Stream"
            myValue: control.stream
            onMyValueChanged: {
                if(control.existConversation)
                    conversationList.currentConversation.modelSettings.stream = myValue;
            }
        }
        ModelSettingsSlider{
            id:temperatureId
            myTextName: "Temperature"
            myTextToolTip: "Controls response randomness, lower values make responses more predictable, higher values make them more creative."
            sliderValue: control.temperature
            sliderFrom: 0.0
            sliderTo:2.0
            sliderStepSize:0.01
            decimalPart: 2
            onSliderValueChanged: {
                if(control.existConversation)
                    conversationList.currentConversation.modelSettings.temperature = sliderValue;
            }
        }
        ModelSettingsSlider{
            id:topPId
            myTextName: "Top-P"
            myTextToolTip:"Limits word selection to a subset with a cumulative probability above p, affecting response diversity."
            sliderValue: control.topP
            sliderFrom: 0.0
            sliderTo:1.0
            sliderStepSize:0.01
            decimalPart: 2
            onSliderValueChanged: {
                if(control.existConversation)
                    conversationList.currentConversation.modelSettings.topP = sliderValue;
            }
        }
        ModelSettingsSlider{
            id:maxTokensId
            myTextName: "Max Tokens"
            myTextToolTip: "Defines the maximum number of tokens the model can process in one input or output."
            sliderValue: control.maxTokens
            sliderFrom: 100
            sliderTo: 4096
            sliderStepSize:1
            onSliderValueChanged: {
                if(control.existConversation)
                    conversationList.currentConversation.modelSettings.maxTokens = sliderValue;
            }
        }
        ModelSettingsSlider{
            id:promptBatchSizeId
            myTextName: "Prompt Batch Size"
            myTextToolTip:"Refers to the number of prompts processed in a single batch, affecting processing efficiency."
            sliderValue: control.promptBatchSize
            sliderFrom: 1
            sliderTo: 128
            sliderStepSize:1
            onSliderValueChanged: {
                if(control.existConversation)
                    conversationList.currentConversation.modelSettings.promptBatchSize = sliderValue;
            }
        }
        ModelSettingsSlider{
            id:minPId
            myTextName: "Min-P"
            myTextToolTip:"Sets the minimum cumulative probability threshold for word selection."
            sliderValue: control.minP
            sliderFrom: 0.0
            sliderTo: 1.0
            sliderStepSize:0.01
            decimalPart: 2
            onSliderValueChanged: {
                if(control.existConversation)
                    conversationList.currentConversation.modelSettings.minP = sliderValue;
            }
        }
        ModelSettingsSlider{
            id:topKId
            myTextName: "Top-K"
            myTextToolTip: "Limits word selection to the top K most probable words, controlling output diversity."
            sliderValue: control.topK
            sliderFrom: 1
            sliderTo: 1000
            sliderStepSize:1
            onSliderValueChanged: {
                if(control.existConversation)
                    conversationList.currentConversation.modelSettings.topK = sliderValue;
            }
        }
        ModelSettingsSlider{
            id:repeatPenaltyTokensId
            myTextName: "Repeat Penalty Tokens"
            myTextToolTip: "Increases the penalty for repeating specific tokens during generation."
            sliderValue: control.repeatPenaltyTokens
            sliderFrom: 0
            sliderTo: 1
            sliderStepSize:0.01
            decimalPart: 2
            onSliderValueChanged: {
                if(control.existConversation)
                    conversationList.currentConversation.modelSettings.repeatPenaltyTokens = sliderValue;
            }
        }
        ModelSettingsSlider{
            id:repeatPenaltyId
            myTextName: "Repeat Penalty"
            myTextToolTip: "Discourages repeating words or phrases by applying a penalty to repeated tokens."
            sliderValue: control.repeatPenalty
            sliderFrom: 1.0
            sliderTo: 2.0
            sliderStepSize:0.01
            decimalPart: 2
            onSliderValueChanged: {
                if(control.existConversation)
                    conversationList.currentConversation.modelSettings.repeatPenalty = sliderValue;
            }
        }
    }
}
