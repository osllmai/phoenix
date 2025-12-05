import QtQuick
import './../../component_library/model'

ModelSelectComboBox{
    id: modelComboBoxId
    modelSelect: conversationList.modelSelect
    modelId: conversationList.modelSelect? conversationList.modelId: -1
    modelName: conversationList.modelSelect? conversationList.modelName:"Phoenix"
    modelIcon: conversationList.modelSelect? conversationList.modelIcon:"qrc:/media/image_company/phoenix.png"
    signal sendMessage()
    Connections{
        target: modelComboBoxId
        function onSetModelRequest(id, name, icon, promptTemplate, systemPrompt) {
            if((!conversationList.isEmptyConversation && !conversationList.currentConversation.responseInProgress && !conversationList.currentConversation.loadModelInProgress)
                      || conversationList.isEmptyConversation){
                conversationList.setModelRequest(id, name, icon, promptTemplate, systemPrompt)
                modelComboBoxId.sendMessage()
                console.log(name)
            }else{
                conversationList.setModelRequest(id, name, icon, promptTemplate, systemPrompt)
            }
        }
    }
}
