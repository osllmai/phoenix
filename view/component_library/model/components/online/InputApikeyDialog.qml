import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import '../../../style' as Style
import '../../../../model/components/online/components/components'

Dialog {
    id: settingsDialogId
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: Math.min( 600 , parent.width-40)
    height: Math.min( 50 , parent.height-40)

    focus: true
    modal: true

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        color: Style.Colors.overlayDrawer
    }

    background: null
    contentItem: InputApikey{
        id: inputApikey
        anchors.fill: parent
        Connections{
            target: inputApikey
            function onSaveAPIKey(apiKey){
                onlineModelList.saveAPIKey(model.id, apiKey)
                inputApikeyDialogId.close()
                if(model.installModel){
                    modelSelectViewId.setModelRequest(model.id, model.name, "qrc:/media/image_company/" + model.icon, model.promptTemplate, model.systemPrompt)
                }
            }
        }
    }
}
