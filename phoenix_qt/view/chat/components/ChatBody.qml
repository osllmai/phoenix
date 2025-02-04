import QtQuick 2.15
import "./chat"
import '../../component_library/style' as Style
import '../../component_library/button'

Item {
    id: controlId
    width: parent.width
    // width: Math.min(780, parent.width - 48)
    // anchors.horizontalCenter: parent.horizontalCenter

    Column{
        spacing: 10
        width: Math.min(680, parent.width - 48)
        anchors.horizontalCenter: parent.horizontalCenter
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
            width: parent.width
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            text: "Ask me anything! You can trust that our conversations are private, and your data is never shared for marketing."
            color: Style.Colors.textInformation
            font.pixelSize: 12
        }
        InputPrompt{
            id:inputBoxId
        }
        Flow{
            spacing: 5
            width: Math.min(parent.width, documentId.width + grammarId.width + rewriteId.width + imageEditorId.width + imageId.width + 20)
            anchors.horizontalCenter: parent.horizontalCenter
            MyButton {
                id: documentId
                myText: "Document"
                myIcon: "qrc:/media/icon/settings.svg"
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureBlue
                isNeedAnimation: true
            }
            MyButton {
                id: grammarId
                myText: "Grammer"
                myIcon: "qrc:/media/icon/settings.svg"
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureRed
                isNeedAnimation: true
            }
            MyButton {
                id: rewriteId
                myText: "Rewrite"
                myIcon: "qrc:/media/icon/settings.svg"
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureOrange
                isNeedAnimation: true
            }
            MyButton {
                id: imageEditorId
                myText: "Image Editor"
                myIcon: "qrc:/media/icon/settings.svg"
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureGreen
                isNeedAnimation: true
            }
            MyButton {
                id: imageId
                myText: "Image"
                myIcon: "qrc:/media/icon/settings.svg"
                bottonType: Style.RoleEnum.BottonType.Feature
                iconType: Style.RoleEnum.IconType.FeatureYellow
                isNeedAnimation: true
            }
        }
    }
}
