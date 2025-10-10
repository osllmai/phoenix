import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import '../../../style' as Style
import '../../../../model/components/online/components/components'

Dialog {
    id: settingsDialogId
    x: (window.width - width) / 2
    y: (window.height - height) / 2
    width: Math.min( 600 , window.width-40)
    height: Math.min( 50 , window.height-40)

    focus: true
    modal: true

    parent: Overlay.overlay
    Overlay.modal: Rectangle {
        width: window.width
        height: window.height - 40
        y: 40
        color: Style.Colors.overlayDrawer
    }

    background: null
    contentItem: InputApikey{
        id: inputApikey
        anchors.fill: parent
        Connections{
            target: inputApikey
            function onSaveAPIKey(apiKey){
                onlineCompanyList.saveAPIKey(model.id, apiKey)
                inputApikeyDialogId.close()
                if(model.installModel){
                    modelSelectViewId.setModelRequest(model.id, model.name, model.icon, model.promptTemplate, model.systemPrompt)
                }
            }
        }
    }
}
