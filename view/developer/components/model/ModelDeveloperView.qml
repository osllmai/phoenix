import QtQuick
import '../../../component_library/model'

Item {
    id: control
    clip: true

    ModelSelectView{
        id: modelComboBoxId
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.bottomMargin: 10

        needCloseButton: false

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
