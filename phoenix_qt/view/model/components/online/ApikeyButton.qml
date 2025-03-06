import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import '../../../component_library/style' as Style
import "../../../component_library/button"


Item {
    id: control
    height: 35
    width: parent.width

    InputApikey{
        id: inputApikey
        visible: !model.installModel
        Connections{
            target: inputApikey
            function onSaveAPIKey(apiKey){
                onlineModelList.saveAPIKey(model.id, apiKey)
            }
        }
    }

    Row{
        spacing: 5
        visible: model.installModel
        MyButton{
            id: deleteButton
            myText: "Delete"
            bottonType: Style.RoleEnum.BottonType.Danger
            onClicked:{
                deleteApikeylVerificationId.open()
            }
        }
        MyButton{
            id: startChatButton
            myText: "Start Chat"
            bottonType: Style.RoleEnum.BottonType.Primary
            onClicked:{
                // onlineModelList.deleteRequest(model.id)
            }
        }
    }

    VerificationDialog{
        id: deleteApikeylVerificationId
        titleText: "delete"
        about:"Are you sure you want to delete the LLM model? \nThis action is irreversible and may result in the loss of data or settings associated with the model."
        textBotton1: "delete"
        textBotton2: "cancel"
        Connections{
            target:deleteApikeylVerificationId
            function onButtonAction1(){
                onlineModelList.deleteRequest(model.id)
            }
            function onButtonAction2() {
                deleteApikeylVerificationId.close()
            }
        }
    }
}
