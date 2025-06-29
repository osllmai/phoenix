import QtQuick
import './../../component_library/model'

ModelSelectComboBox{
    id: modelComboBoxId
    modelSelect: conversationList.modelSelect
    modelId: conversationList.modelSelect? conversationList.modelId: -1
    modelName: conversationList.modelSelect? conversationList.modelText:"Phoenix"
    modelIcon: conversationList.modelSelect? conversationList.modelIcon:"qrc:/media/image_company/Phoenix.png"
    signal sendMessage()
    Connections{
        target: modelComboBoxId
        function onSetModelRequest(id, name, icon, promptTemplate, systemPrompt) {
            conversationList.setModelRequest(id, name, icon, promptTemplate, systemPrompt)

            modelComboBoxId.sendMessage()
        }
    }
}
