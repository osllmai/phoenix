import QtQuick
import '../../../component_library/model'

ModelSelectComboBox{
    id: modelComboBoxId
    modelSelect: codeDeveloperList.modelSelect
    modelId: codeDeveloperList.modelSelect? codeDeveloperList.modelId: -1
    modelName: codeDeveloperList.modelSelect? codeDeveloperList.modelText:"Phoenix"
    modelIcon: codeDeveloperList.modelSelect? codeDeveloperList.modelIcon:"qrc:/media/image_company/phoenix.png"
    Connections{
        target: modelComboBoxId
        function onSetModelRequest(id, name, icon, promptTemplate, systemPrompt) {
            codeDeveloperList.setModelRequest(id, name, icon, promptTemplate, systemPrompt)
        }
    }
}
