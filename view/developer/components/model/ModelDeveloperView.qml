import QtQuick
import '../../../component_library/model'

Item {
    id: control
    clip: true

    ModelSelectView{
        id: modelComboBoxId
        anchors.fill: parent
        anchors.margins: 10

        modelSelect: codeDeveloperList.modelSelect
        modelId: codeDeveloperList.modelSelect? codeDeveloperList.modelId: -1
        modelName: codeDeveloperList.modelSelect? codeDeveloperList.modelText:"Phoenix"
        modelIcon: codeDeveloperList.modelSelect? codeDeveloperList.modelIcon:"qrc:/media/image_company/Phoenix.png"
        Connections{
            target: modelComboBoxId
            function onSetModelRequest(id, name, icon, promptTemplate, systemPrompt) {
                codeDeveloperList.setModelRequest(id, name, icon, promptTemplate, systemPrompt)
            }
        }
    }
}
