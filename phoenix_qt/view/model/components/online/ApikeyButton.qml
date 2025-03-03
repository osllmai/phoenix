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
                onlineModelList.deleteRequest(model.id)
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
}
