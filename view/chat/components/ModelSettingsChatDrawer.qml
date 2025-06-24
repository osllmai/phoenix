import QtQuick 2.15
import QtQuick.Controls
import '../../component_library/style' as Style
import "../../component_library/model_settings"

Drawer{
    id: drawerId
    width: 320
    height: parent.height
    interactive: true
    edge: Qt.RightEdge

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        color: Style.Colors.overlayDrawer
    }

    background: null
    ModelSettingsView {
        id: modelSettingsId

        property bool existConversation: !conversationList.isEmptyConversation

        property var conversation: modelSettingsId.existConversation? conversationList.currentConversation: null

        onConversationChanged: {
            modelSettingsId.stream = modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.stream : true
            modelSettingsId.temperature = modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.temperature : 0.8
            modelSettingsId.topP = modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.topP : 1.5
            modelSettingsId.maxTokens = modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.maxTokens : 4096
            modelSettingsId.promptBatchSize = modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.promptBatchSize : 100
            modelSettingsId.minP = modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.minP : 1.5
            modelSettingsId.topK = modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.topK : 650
            modelSettingsId.repeatPenaltyTokens = modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.repeatPenaltyTokens : 1.5
            modelSettingsId.repeatPenalty = modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.repeatPenalty : 1.5
            modelSettingsId.systemPrompt = modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.systemPrompt : ""
            modelSettingsId.promptTemplate = modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.promptTemplate : ""
            modelSettingsId.contextLength = modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.contextLength : 4096
            modelSettingsId.numberOfGPULayers = modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.numberOfGPULayers : 80
        }

        stream: modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.stream : true
        temperature: modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.temperature : 0.8
        topP: modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.topP : 1.5
        maxTokens: modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.maxTokens : 4096
        promptBatchSize: modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.promptBatchSize : 100
        minP: modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.minP : 1.5
        topK: modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.topK : 650
        repeatPenaltyTokens: modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.repeatPenaltyTokens : 0.8
        repeatPenalty: modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.repeatPenalty : 1.5
        systemPrompt: modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.systemPrompt : ""
        promptTemplate: modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.promptTemplate : ""
        contextLength: modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.contextLength : 4096
        numberOfGPULayers: modelSettingsId.existConversation ? conversationList.currentConversation.modelSettings.numberOfGPULayers : 80

        Connections {
            target: modelSettingsId
            function onUpdateSystemPrompt(systemPrompt) {
                if(modelSettingsId.existConversation){
                    conversationList.currentConversation.modelSettings.systemPrompt = systemPrompt;
                }
            }
            function onUpdatePromptTemplate(promptTemplate) {
                if(modelSettingsId.existConversation){
                    conversationList.currentConversation.modelSettings.promptTemplate = promptTemplate;
                }
            }
            function onUpdateStream(stream) {
                if(modelSettingsId.existConversation)
                    conversationList.currentConversation.modelSettings.stream = stream;
            }
            function onUpdateTemperature(temperature) {
                if(modelSettingsId.existConversation)
                    conversationList.currentConversation.modelSettings.temperature = temperature;
            }
            function onUpdateTopP(topP) {
                if(modelSettingsId.existConversation)
                    conversationList.currentConversation.modelSettings.topP = topP;
            }
            function onUpdateMaxTokens(maxTokens) {
                if(modelSettingsId.existConversation)
                    conversationList.currentConversation.modelSettings.maxTokens = maxTokens;
            }
            function onUpdatePromptBatchSize(promptBatchSize) {
                if(modelSettingsId.existConversation)
                    conversationList.currentConversation.modelSettings.promptBatchSize = promptBatchSize;
            }
            function onUpdateMinP(minP) {
                if(modelSettingsId.existConversation)
                    conversationList.currentConversation.modelSettings.minP = minP;
            }
            function onUpdateTopK(topK) {
                if(modelSettingsId.existConversation)
                    conversationList.currentConversation.modelSettings.topK = topK;
            }
            function onUpdateRepeatPenaltyTokens(repeatPenaltyTokens) {
                if(modelSettingsId.existConversation)
                    conversationList.currentConversation.modelSettings.repeatPenaltyTokens = repeatPenaltyTokens;
            }
            function onUpdateRepeatPenalty(repeatPenalty) {
                if(modelSettingsId.existConversation)
                    conversationList.currentConversation.modelSettings.repeatPenalty = repeatPenalty;
            }
            function onUpdateContextLength(contextLength) {
                if(modelSettingsId.existConversation)
                    conversationList.currentConversation.modelSettings.contextLength = contextLength;
            }
            function onUpdateNumberOfGPULayers(numberOfGPULayers) {
                if(modelSettingsId.existConversation)
                    conversationList.currentConversation.modelSettings.numberOfGPULayers = numberOfGPULayers;
            }
        }
    }
}
