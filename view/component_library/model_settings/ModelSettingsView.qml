import QtQuick 2.15
import QtQuick.Controls
import '../style' as Style

Rectangle {
    id: modelSettingsId

    property bool needCloseButton: true

    property bool stream
    property double temperature
    property double topP
    property double maxTokens
    property double promptBatchSize
    property double minP
    property double topK
    property double repeatPenaltyTokens
    property double repeatPenalty

    property string systemPrompt
    property string promptTemplate

    property int contextLength
    property int numberOfGPULayers

    property bool apiPage: false
    property bool isRunningAPI: false
    property string api: ""
    property int portAPI: 0
    property string chatAPI: ""
    property string modelsAPI: ""

    property bool socketPage: false
    property bool isRunningSocket: false
    property string socket: ""
    property int portSocket: 0


    signal updateSystemPrompt(string systemPrompt)
    signal updatePromptTemplate(string promptTemplate)
    signal updateStream(bool stream)
    signal updateTemperature(double temperature)
    signal updateTopP(double topP)
    signal updateMaxTokens(double maxTokens)
    signal updatePromptBatchSize(double promptBatchSize)
    signal updateMinP(double minP)
    signal updateTopK(double topK)
    signal updateRepeatPenaltyTokens(double repeatPenaltyTokens)
    signal updateRepeatPenalty(double repeatPenalty)
    signal updateContextLength(int contextLength)
    signal updateNumberOfGPULayers(int numberOfGPULayers)
    signal updateIsRunningAPI(bool isRunningAPI)
    signal updatePortAPI(int portAPI)
    signal updateIsRunningSocket(bool isRunningSocket)
    signal updatePortSocket(int portSocket)

    color: Style.Colors.background
    anchors.fill: parent
    border.width: 0
    Column{
        anchors.fill: parent
        anchors.margins: 16
        ModelSettingsHeader{
            id: headerId
            Connections{
                target: headerId
                function onCloseDrawer(){
                    drawerId.close()
                }
            }
        }
        ModelSettingsBody{
            id: historyBadyId
        }
    }
}
