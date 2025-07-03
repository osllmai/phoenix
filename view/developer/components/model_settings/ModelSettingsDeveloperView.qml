import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../../component_library/style' as Style
import "../../../component_library/model_settings"

Item {
    height: parent.height - headerId.height
    width: parent.width
    ModelSettingsView {
        id: modelSettingsId

        needCloseButton: false

        stream: codeDeveloperList.currentProgramLanguage.codeGenerator.stream
        temperature: codeDeveloperList.currentProgramLanguage.codeGenerator.temperature
        topP: codeDeveloperList.currentProgramLanguage.codeGenerator.topP
        maxTokens: codeDeveloperList.currentProgramLanguage.codeGenerator.maxTokens
        promptBatchSize: codeDeveloperList.currentProgramLanguage.codeGenerator.promptBatchSize
        minP: codeDeveloperList.currentProgramLanguage.codeGenerator.minP
        topK: codeDeveloperList.currentProgramLanguage.codeGenerator.topK
        repeatPenaltyTokens: codeDeveloperList.currentProgramLanguage.codeGenerator.repeatPenaltyTokens
        repeatPenalty: codeDeveloperList.currentProgramLanguage.codeGenerator.repeatPenalty
        systemPrompt: codeDeveloperList.currentProgramLanguage.codeGenerator.systemPrompt
        promptTemplate: codeDeveloperList.currentProgramLanguage.codeGenerator.promptTemplate
        contextLength: codeDeveloperList.currentProgramLanguage.codeGenerator.contextLength
        numberOfGPULayers: codeDeveloperList.currentProgramLanguage.codeGenerator.numberOfGPULayers

        apiPage: true
        isRunningAPI:codeDeveloperList.isRunningAPI
        api: "http://127.0.0.1:"+ codeDeveloperList.portAPI
        portAPI: codeDeveloperList.portAPI
        chatAPI: "http://127.0.0.1:"+ codeDeveloperList.portAPI + "/api/chat"
        modelsAPI: "http://127.0.0.1:"+ codeDeveloperList.portAPI + "/api/models"

        socketPage: true
        isRunningSocket: codeDeveloperList.isRunningSocket
        socket: "ws://127.0.0.1:"+ codeDeveloperList.portSocket
        portSocket: codeDeveloperList.portSocket

        Connections {
            target: modelSettingsId
            function onUpdateSystemPrompt(systemPrompt) {
                    codeDeveloperList.currentProgramLanguage.codeGenerator.systemPrompt = systemPrompt;
            }
            function onUpdatePromptTemplate(promptTemplate) {
                    codeDeveloperList.currentProgramLanguage.codeGenerator.promptTemplate = promptTemplate;
            }
            function onUpdateStream(stream) {
                    codeDeveloperList.currentProgramLanguage.codeGenerator.stream = stream;
            }
            function onUpdateTemperature(temperature) {
                    codeDeveloperList.currentProgramLanguage.codeGenerator.temperature = temperature;
            }
            function onUpdateTopP(topP) {
                    codeDeveloperList.currentProgramLanguage.codeGenerator.topP = topP;
            }
            function onUpdateMaxTokens(maxTokens) {
                    codeDeveloperList.currentProgramLanguage.codeGenerator.maxTokens = maxTokens;
            }
            function onUpdatePromptBatchSize(promptBatchSize) {
                    codeDeveloperList.currentProgramLanguage.codeGenerator.promptBatchSize = promptBatchSize;
            }
            function onUpdateMinP(minP) {
                    codeDeveloperList.currentProgramLanguage.codeGenerator.minP = minP;
            }
            function onUpdateTopK(topK) {
                    codeDeveloperList.currentProgramLanguage.codeGenerator.topK = topK;
            }
            function onUpdateRepeatPenaltyTokens(repeatPenaltyTokens) {
                    codeDeveloperList.currentProgramLanguage.codeGenerator.repeatPenaltyTokens = repeatPenaltyTokens;
            }
            function onUpdateRepeatPenalty(repeatPenalty) {
                    codeDeveloperList.currentProgramLanguage.codeGenerator.repeatPenalty = repeatPenalty;
            }
            function onUpdateContextLength(contextLength) {
                    codeDeveloperList.currentProgramLanguage.codeGenerator.contextLength = contextLength;
            }
            function onUpdateNumberOfGPULayers(numberOfGPULayers) {
                    codeDeveloperList.currentProgramLanguage.codeGenerator.numberOfGPULayers = numberOfGPULayers;
            }
            function onUpdateIsRunningAPI(isRunningAPI){
                codeDeveloperList.isRunningAPI = isRunningAPI
            }
            function onUpdatePortAPI(portAPI){
                codeDeveloperList.portAPI = portAPI
            }
            function onUpdateIsRunningSocket(isRunningSocket){
                codeDeveloperList.isRunningSocket = isRunningSocket
            }
            function onUpdatePortSocket(portSocket){
                codeDeveloperList.portSocket = portSocket
            }
        }
    }

    Rectangle{
        id: lineId
        width: 1
        height: parent.height
        color: Style.Colors.boxBorder
    }
}
