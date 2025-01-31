import QtQuick 2.15
import "./chat"
import '../../component_library/style' as Style
import '../../component_library/button'

Item {
    id: controlId
    width: Math.min(752, parent.width - 48)
    anchors.horizontalCenter: parent.horizontalCenter

    Column{
        spacing: 10
        anchors.verticalCenter: parent.verticalCenter
        Text{
            id: phoenixId
            text: "Hello! I’m Phoenix."
            anchors.horizontalCenter: parent.horizontalCenter
            color: Style.Colors.textTitle
            font.pixelSize: 18
            font.styleName: "Bold"
        }
        Text{
            id: informationText
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Ask me anything! You can trust that our conversations are private, and your data is never shared for marketing."
            color: Style.Colors.textInformation
            font.pixelSize: 12
        }
        InputPrompt{
            id:inputBoxId
        }
        Row{
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            MyButton {
                id: documentId
                myText: "Document"
                myIcon: "../../media/icon/settings.svg"
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureBlue
                isNeedAnimation: true
            }
            MyButton {
                id: grammarId
                myText: "Grammer"
                myIcon: "../../media/icon/settings.svg"
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureRed
                isNeedAnimation: true
            }
            MyButton {
                id: rewriteId
                myText: "Rewrite"
                myIcon: "../../media/icon/settings.svg"
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureOrange
                isNeedAnimation: true
            }
            MyButton {
                id: imageEditorId
                myText: "Image Editor"
                myIcon: "../../media/icon/settings.svg"
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureGreen
                isNeedAnimation: true
            }
            MyButton {
                id: imageId
                myText: "Image"
                myIcon: "../../media/icon/settings.svg"
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureYellow
                isNeedAnimation: true
            }
        }
    }
}
