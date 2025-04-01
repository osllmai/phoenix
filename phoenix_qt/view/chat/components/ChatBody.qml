import QtQuick 2.15
import QtQuick.Controls 2.15
import "./chat"
import '../../component_library/style' as Style
import '../../component_library/button'

Item {
    id: control
    width: parent.width
    height: parent.height
    signal openModelList()

    Column{
        spacing: 10
        anchors.fill: parent
        visible: !conversationList.isEmptyConversation
        MyMessageList{
            id: myMessageView
        }
        InputPrompt{
            id: inputBoxId
            Connections{
                target: inputBoxId
                function onSendPrompt(prompt){
                    if((conversationList.modelSelect) && (prompt !== "")){
                        conversationList.currentConversation.prompt(prompt, conversationList.modelId)
                    }else if((prompt !== "")){
                        notificationDialogId.open()
                        control.openModelList()
                    }
                }
            }
        }
    }

    NotificationDialog{
        id: notificationDialogId
        titleText: "No model selected"
        about:"Sorry! No model is currently active. Please try again later or check the settings."
    }

    Column{
        spacing: 16
        width: Math.min(700, parent.width - 48)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: conversationList.isEmptyConversation
        Label {
            id: phoenixId
            text: "Hello! I’m Phoenix."
            anchors.horizontalCenter: parent.horizontalCenter
            color: Style.Colors.textTitle
            font.pixelSize: 24
            font.styleName: "Bold"
        }
        Label {
            id: informationText
            width: parent.width
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            text: "Ask me anything!"
            color: Style.Colors.textInformation
            font.pixelSize: 14
        }
        InputPrompt{
            id:inputBoxId2
            Connections{
                target: inputBoxId2
                function onSendPrompt(prompt){
                    if((conversationList.modelSelect) && (prompt !== "")){
                        conversationList.addRequest(prompt)
                    }else if((prompt !== "")){
                        notificationDialogId.open()
                        control.openModelList()
                    }
                }
            }
        }
        Flow{
            spacing: 5
            width: Math.min(parent.width, documentId.width + grammarId.width + rewriteId.width + imageEditorId.width + imageId.width + 20)
            anchors.horizontalCenter: parent.horizontalCenter
            MyButton {
                id: documentId
                myText: "Document"
                myIcon: "qrc:/media/icon/document.svg"
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureBlue
                isNeedAnimation: true
            }
            MyButton {
                id: grammarId
                myText: "Grammer"
                myIcon: "qrc:/media/icon/grammer.svg"
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureRed
                isNeedAnimation: true
            }
            MyButton {
                id: rewriteId
                myText: "Rewrite"
                myIcon: "qrc:/media/icon/rewrite.svg"
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureOrange
                isNeedAnimation: true
            }
            MyButton {
                id: imageEditorId
                myText: "Image Editor"
                myIcon: "qrc:/media/icon/imageEditor.svg"
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureGreen
                isNeedAnimation: true
            }
            MyButton {
                id: imageId
                myText: "Image"
                myIcon: "qrc:/media/icon/image.svg"
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureYellow
                isNeedAnimation: true
            }
        }
    }
}
